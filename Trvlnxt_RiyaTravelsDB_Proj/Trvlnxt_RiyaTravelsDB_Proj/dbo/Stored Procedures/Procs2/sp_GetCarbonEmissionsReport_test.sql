-- [dbo].[sp_GetCarbonEmissionsReport] '2023-06-01','2023-06-26','45325','',null
CREATE Procedure [dbo].[sp_GetCarbonEmissionsReport_test]     
	@fromDate Datetime    
	, @todate Datetime    
	, @AgentID varchar(20)    
	, @TicketNumber varchar(50) = ''      
	, @GDSPNR varchar(20) = ''      
AS      
BEGIN
	SELECT   (SELECT TOP 1 _NAME 
				FROM Airlinesname 
				WHERE _CODE = BM.ValidatingCarrier) AS [Airline Name]  
			, BM.ValidatingCarrier AS  [Airline Code]    
			, CASE BM.VendorName WHEN 'Amadeus' THEN CONVERT(VARCHAR(20),FORMAT(AN.[AWB Prefix], '000')) + '-' + PB.TicketNumber ELSE PB.TicketNumber END AS [Ticket Number]    
			, CASE WHEN ISNULL(PB.title,'') = '' THEN '' ELSE PB.title + ' ' END + PB.paxFName + ' ' + PB.paxLName AS [Passenger Name]
			, (SELECT STUFF((SELECT '-' + (CASE WHEN ROW_NUMBER() OVER (ORDER BY pkid) = 1 
												THEN tbi.frmSector + '-' + tbi.toSector 
											ELSE tbi.toSector END)    
								FROM tblBookItenary AS tbi WITH(NOLOCK)
								WHERE tbi.orderId = BM.orderId 
								FOR XML PATH ('')) , 1, 1, '')) AS Sector
			, (SELECT STUFF((SELECT '/' + b.cabin 
								FROM tblBookItenary AS b WITH(NOLOCK)
								WHERE b.orderId = BM.orderId 
								FOR XML PATH ('')) , 1, 1, '')) AS  [Cabin Class]    
			, CONVERT(varchar,BM.IssueDate,106) AS [Booking Date/Time]--+ '/'+CONVERT(varchar(5),bm.IssueDate,108)
			, (SELECT STUFF((SELECT '-' + CONVERT(varchar,b.IssueDate,106) + '/'+CONVERT(varchar(5),b.IssueDate,108) FROM tblBookMaster AS b WHERE b.GDSPNR = BM.GDSPNR AND b.riyaPNR = BM.riyaPNR GROUP BY b.IssueDate FOR XML PATH ('')) , 1, 1, '')) AS [Booking Date/Time]
			, (SELECT STUFF((SELECT '-' + CONVERT(varchar,b.deptTime,106) + '/'+CONVERT(varchar(5),b.deptTime,108) 
								FROM tblBookMaster AS b WITH(NOLOCK)
								WHERE b.GDSPNR = BM.GDSPNR 
								AND b.riyaPNR = BM.riyaPNR FOR XML PATH ('')) , 1, 1, '')) AS [Departure Date/Time]    
			, (SELECT STUFF((SELECT '-' + CONVERT(varchar,b.arrivalTime,106) + '/'+CONVERT(varchar(5),b.arrivalTime,108) 
								FROM tblBookMaster AS b WITH(NOLOCK)
								WHERE b.GDSPNR = BM.GDSPNR 
								AND b.riyaPNR = BM.riyaPNR FOR XML PATH ('')) , 1, 1, '')) AS [Arrival Date/Time]    
			, (SELECT CAST(SUM(CAST(LTRIM(DATEDIFF(MINUTE, 0, CAST(b.TotalTimeStopOver AS TIME))) AS INT)) / 60 AS VARCHAR) +':'+ CAST(SUM(CAST(LTRIM(DATEDIFF(MINUTE, 0, CAST(b.TotalTimeStopOver AS TIME))) AS INT))%60 AS VARCHAR) 
					FROM tblBookItenary b WITH(NOLOCK)
					WHERE b.orderId = BM.orderId
					AND (TotalTimeStopOver IS NOT NULL AND TotalTimeStopOver != '')    
					AND CHARINDEX('.', TotalTimeStopOver) = 0 AND CHARINDEX('-', TotalTimeStopOver) = 0    
					AND TotalTimeStopOver LIKE '%:%'    
					AND len(TotalTimeStopOver)  > 3     
					AND CAST(SUBSTRING(TotalTimeStopOver, 0,CHARINDEX(':',TotalTimeStopOver)) AS Int)  < 24     
					AND CAST(SUBSTRING(TotalTimeStopOver, CHARINDEX(':',TotalTimeStopOver)+1,2) AS Int)  < 60    
				) AS  [Flying Hours]    
				, (SELECT top 1 CAST(TotalTimeStopOver   AS VARCHAR) 
					FROM tblBookItenary b WITH(NOLOCK)
					WHERE b.orderId = BM.orderId
					AND (TotalTimeStopOver IS NOT NULL AND TotalTimeStopOver != '')    
					AND CHARINDEX('.', TotalTimeStopOver) = 0 AND CHARINDEX('-', TotalTimeStopOver) = 0    
				--	AND TotalTimeStopOver LIKE '%:%'    
				--	AND CAST(SUBSTRING(TotalTimeStopOver, 0,3) AS Int) < 24     
				--	AND CAST(SUBSTRING(TotalTimeStopOver, 4,2) AS Int) < 60    
				) AS  [Flying Hours1]  
			, (SELECT SUM(CONVERT(Decimal(18,2), b.TotalflightLegMileage)) 
					FROM tblBookMaster AS b WITH(NOLOCK)
					WHERE b.GDSPNR = BM.GDSPNR 
					AND b.riyaPNR = BM.riyaPNR) AS Miles    
			, (SELECT SUM(CONVERT(Decimal(18,2), b.TotalCarbonEmission)) 
					FROM tblBookMaster AS b WITH(NOLOCK)
					WHERE b.GDSPNR = BM.GDSPNR 
					AND b.riyaPNR = BM.riyaPNR) AS [CO2]--+NCHAR(8322)    
	FROM tblBookMaster AS BM WITH(NOLOCK)
	INNER JOIN tblPassengerBookDetails AS PB WITH(NOLOCK) ON BM.pkId = PB.fkBookMaster    
	LEFT JOIN AirlinesName AN WITH(NOLOCK) ON ISNULL(BM.ValidatingCarrier,BM.airCode)= AN._CODE     
	WHERE (@GDSPNR is NULL OR @GDSPNR = '' OR BM.GDSPNR = @GDSPNR)     
	AND (@TicketNumber = ''    
	  OR PB.TicketNumber = @TicketNumber    
	  OR CONVERT(VARCHAR(20),FORMAT(AN.[AWB Prefix], '000'))+PB.TicketNumber like '%'+@TicketNumber+'%'    
	  OR CONVERT(VARCHAR(20),FORMAT(AN.[AWB Prefix], '000'))+'-'+PB.TicketNumber like '%'+@TicketNumber+'%'
	)    
	AND (@AgentID = '' OR BM.AgentID = @AgentID)    
	AND (@TicketNumber != '' OR (CONVERT(date,BM.IssueDate) BETWEEN CONVERT(date,@fromDate) AND CONVERT(date,@todate)))    
	AND BM.AgentID != 'B2C'    
	AND BM.returnFlag = 0    
	AND BM.IsBooked = 1      
	AND BM.BookingStatus = 1    
	AND BM.VendorName='Amadeus'    
END