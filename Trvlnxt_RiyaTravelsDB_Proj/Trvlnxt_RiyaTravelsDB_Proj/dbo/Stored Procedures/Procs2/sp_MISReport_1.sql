    
--,(SELECT Sum(Convert(decimal,CarbonEmission)) FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = B.orderId) AS CarbonEmission      
    
    
--exec [dbo].[sp_MISReport] '2023-06-01','2023-06-30','',''                    
CREATE procedure [dbo].[sp_MISReport_1]                    
 @FromDate Datetime,                    
 @Todate Datetime,                    
 @AgentID Varchar(50),                    
 @AgencyNameList Varchar(MAX)='',                    
 @OfficeID varchar(255)='',                  
 @GroupId Varchar(255)=''                    
AS                    
BEGIN                    
 SELECT UPPER(FORMAT(inserteddate_old, 'dd-MMM-yyyy HH:mm:ss')) AS 'Issue Date'                    
   , Icast AS 'Customer Number'                    
   , LocationCode as 'Location Code'                    
   , B.riyaPNR AS 'MoBooking Number'                    
   , B.GDSPNR AS 'GDS PNR'                    
   , P.TicketNumber   AS 'Ticket Number'                    
   , STUFF((SELECT '/' + s.airlinePNR                     
      FROM tblBookItenary s WITH(NOLOCK)                    
      WHERE s.orderId = B.orderId                     
      FOR XML PATH('')), 1, 1, '') AS 'AIRLINE PNR'                    
   , (CASE WHEN B.BookingStatus = 1                     
      THEN 'TKTT'                     
     ELSE 'RFND' END) AS 'Transaction Type'                    
   , 'RBT' AS [Customer-Id]                    
   , B.airCode AS 'Supplier Code'                    
   , P.paxType AS 'Pax Type'                    
   , P.paxFName AS 'First Name'                    
   , P.paxLName AS 'Last Name'                    
   , C.CurrencyCode AS 'Currency Type'                    
   , B.ROE                    
   , B.AgentROE                    
   , ROUND(P.basicFare * B.ROE,2) AS 'Basic Fare'                    
   , ROUND(P.YRTax * B.ROE,2) AS YRTax                    
   , ROUND(P.YQ * B.ROE,2) AS YQTax                    
   , ROUND(P.INTax * B.ROE,2) AS INTax                    
   , ROUND(P.JNTax * B.ROE,2) AS JNTax                    
   , ROUND(P.OCTax * B.ROE,2) AS OCTax                    
   , ROUND(P.YMTax * B.ROE,2) AS YMTax                    
   , ROUND(P.WOTax * B.ROE,2) AS WOTax                    
   , ROUND(P.OBTax * B.ROE,2) AS OBTax                    
   , ROUND(P.RFTax * B.ROE,2) AS RFTax                    
   , ROUND(P.ExtraTax * B.ROE,2) AS XTTax                    
   , ROUND(P.totalTax * B.ROE,2) AS 'Total Tax'                    
   , ROUND(P.totalFare * B.ROE,2) AS 'Total Fare'                    
   , (SELECT SUM(SSR_Amount)                     
     FROM tblSSRDetails s WITH(NOLOCK)                    
     INNER JOIN tblPassengerBookDetails p1 WITH(NOLOCK) on p1.pid=s.fkPassengerid                    
     INNER JOIN tblBookMaster b1 WITH(NOLOCK) on b1.pkId=p1.fkBookMaster                    
     WHERE (b.orderId=b1.orderId) AND  SSR_Type='Baggage' AND s.SSR_Status=1 AND SSR_Amount > 0                    
     AND paxFName + ISNULL(paxLName,'') IN (SELECT paxFName + ISNULL(paxLName,'')                                  
               FROM tblPassengerBookDetails WITH(NOLOCK)                    
               WHERE pid=p1.pid AND pid = P.pid)                    
     GROUP BY paxFName + ISNULL(paxLName,'')) AS [Extra Baggage Amount]                    
   , (SELECT SUM(SSR_Amount) FROM tblSSRDetails s WITH(NOLOCK)                    
     INNER JOIN tblPassengerBookDetails p1 on p1.pid=s.fkPassengerid                    
     INNER JOIN tblBookMaster b1 on b1.pkId=p1.fkBookMaster                    
     WHERE (b.orderId=b1.orderId) AND  SSR_Type='Seat' AND s.SSR_Status=1 AND SSR_Amount>0 AND                    
     paxFName + ISNULL(paxLName,'') IN (SELECT paxFName + ISNULL(paxLName,'')                    
              FROM tblPassengerBookDetails WITH(NOLOCK)                    
              WHERE pid=p1.pid AND pid = P.pid)                    
     GROUP BY paxFName + ISNULL(paxLName,'')) as [Seat Preference Charge]                    
   , (SELECT sum(SSR_Amount) FROM tblSSRDetails s WITH(NOLOCK)                    
     INNER JOIN tblPassengerBookDetails p1 WITH(NOLOCK) on p1.pid=s.fkPassengerid                    
     INNER JOIN tblBookMaster b1 WITH(NOLOCK) on b1.pkId=p1.fkBookMaster                    
     WHERE (b.orderId=b1.orderId) AND  SSR_Type='Meals' AND s.SSR_Status=1 AND SSR_Amount>0 AND                    
     paxFName + ISNULL(paxLName,'') IN (SELECT paxFName + ISNULL(paxLName,'')                    
              FROM tblPassengerBookDetails WITH(NOLOCK)                    
      WHERE pid=p1.pid AND pid = P.pid)                    
     GROUP BY paxFName + ISNULL(paxLName,'')) as [Meal Charges]                    
   , ISNULL(p.IATACommission,0) + ISNULL(p.PLBCommission,0) +  ISNULL(p.DropnetCommission,0) AS Discount                    
   , STUFF((SELECT '/' + I.farebasis FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'Fare Basis'                    
   , STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'Sector'                    
   , STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'Flight Number'                    
   , STUFF((SELECT '/' +  substring(I.cabin,0,2) FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'RBD'                    
   , STUFF((SELECT ',' + convert(varchar(11),UPPER(FORMAT(CONVERT(DATETIME,s.depDate),'dd-MMM-yyyy'))) FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'Date of Travel'                    
   , STUFF((SELECT ',' + convert(varchar(11),UPPER(FORMAT(CONVERT(DATETIME,s.arrivalDate),'dd-MMM-yyyy'))) FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS [Travel End Date]                    
   , (case when counterclosetime=1 then 'Air-domestic' else 'Air-Int'end) AS 'Product Type'                    
   , B.frmSector AS 'From City'                    
   , B.toSector AS 'To City'                    
   , P.CancellationPenalty AS [Penalty Amount]                    
   , A.TR_POName [TR/PO No.]                    
   , (case WHEN (SELECT top 1 CLIQCID                     
       FROM PNRRetrivalFromAudit WITH(NOLOCK)                    
       WHERE GDSPNR = B.GDSPNR                    
       AND IsBookMasterInserted = '1'                    
       AND OfficeID = B.OfficeID                     
       AND R.Icast = ICust) = '228934' OR A.CLIQCID ='228934'                    
     THEN 'Concur' ELSE 'Travel Next' END) AS [Booking Source Type]                    
   , B.fromAirport AS [Departure Terminal]                           
   , B.toAirport AS [Arrival Terminal]               
   ,A.BTANO as BTANUMBER          
   ,a.OUNameIDF as OUname          
   , CASE WHEN B.FareType='Special Fare' THEN 'Special' ELSE B.FareType END AS 'Fare Type'                    
   , CASE WHEN P.isReturn=0 THEN 'One Way' ELSE 'Return' END AS [Trip Type]                       
   , A.CostCenter AS [Cost Center]                    
   , A.Traveltype AS [Travel Type]                    
   , A.EMPLOYEEORGUNIT AS [EMPLOYEE ORGUNIT]                    
   , A.EmpDimession AS [Employee Code]                    
   , A.EMPLOYEELOCATIONDESCRIPTION AS [EMPLOYEE LOCATION DESCRIPTION]                    
   , A.EMPLOYEELOCATIONCODE AS [EMPLOYEE LOCATION CODE]                    
   , A.Changedcostno AS [Changed Cost Centre]                    
   , A.Travelduration AS [Travel Duration]                    
   , A.TASreqno AS [TAS Request Number]                    
   , A.RequestID AS [Request No]                    
   , A.Companycodecc AS [Company code CC/entity name]                    
   , A.Projectcode AS [Project Code]                    
   , A.EMPLOYEEPROJECTCODE AS [EMPLOYEE PROJECT CODE]                    
   , A.EMPLOYEEMARKET AS [EMPLOYEE MARKET]                    
   , A.EMPLOYEESUBMARKET AS [EMPLOYEE SUBMARKET]                       
   , A.DEVIATION_APPROVER_NAME_AND_EMPCODE AS [DEVIATION APPROVER NAME AND EMP CODE]                    
   , A.DEVIATIONAPPROVER AS [DEVIATION APPROVER]                    
   , A.ConcurID AS [Concur ID]                    
   , A.EMPLOYEESPOSITION AS [EMPLOYEES POSITION BILLIABLE TO CLIENT]                    
   , A.TRAVELCOSTREIMBURSABLE AS [TRAVEL COST REIMBURSABLE BY CLIENT]                    
   , A.REASONFORDEVIATIONAIR AS [REASON FOR DEVIATION AIR]                    
   , A.LOWEST_LOGICAL_FARE_1 AS [LOWEST LOGICAL FARE1]                    
   , A.LOWEST_LOGICAL_FARE_2 AS [LOWEST LOGICAL FARE2]                    
   , A.LOWEST_LOGICAL_FARE_3 AS [LOWEST LOGICAL FARE3]                   
   ,A.DEVIATION_APPROVER_NAME_AND_EMPCODE as [DEVIATION APPROVER NAME AND EMP CODE]                
   ,A.FareRule as [FareRule]              
   ,A.FareType as [Attributes Fare Rule]         
   ,A.ApproverName as [Approver Name]   
   ,A.TravelRequestNumber as [Travel Request Number]      
               
   ,A.Project_Code AS  [Project Code]    ,A.TravelExpenseType AS  [Travel Expense Type]    ,A.CartNumber AS  [Cart Number]    ,A.CartStatus AS  [Cart Status]    ,A.BookedByName AS  [Booked By Name]            
            
   , (CASE WHEN (SELECT top 1 CLIQCID                     
       FROM PNRRetrivalFromAudit WITH(NOLOCK)                     
       WHERE GDSPNR = B.GDSPNR                    
       AND IsBookMasterInserted = '1'                    
       AND OfficeID = B.OfficeID                    
       AND R.Icast = ICust) != '' OR A.CLIQCID != ''                    
     THEN '228934' ELSE '' END) AS [CLIQ CID]                    
   , (SELECT TOP 1 bank_ref_no                    
    FROM Paymentmaster WITH(NOLOCK)                    
    WHERE order_id = B.orderId) AS bank_Ref_Number              
       
 ,STUFF((SELECT ' /' +  RIGHT(cabin, LEN(cabin) - CHARINDEX('-', cabin))       
FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = B.orderId FOR XML PATH('')),2,1,'') AS 'Cabin'      
      
--,(SELECT CarbonEmission FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = B.orderId) AS CarbonEmission      
 ,(SELECT Sum(Convert(decimal,CarbonEmission)) FROM tblBookItenary I WITH(NOLOCK) WHERE I.orderId = B.orderId) AS CarbonEmission       
 FROM tblBookMaster B WITH(NOLOCK)                    
 LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CONVERT(VARCHAR(50),R.FKUserID)=B.AgentID                    
 LEFT JOIN tblPassengerBookDetails P WITH(NOLOCK) ON P.fkBookMaster=B.pkId                    
 LEFT JOIN mcountrycurrency C WITH(NOLOCK) ON C.CountryCode=B.Country                    
 LEFT JOIN mAttrributesDetails A WITH(NOLOCK) ON A.OrderID=B.orderId    and A.fkPassengerid = p.pid                    
 --and a.id = (select max(id) from mAttrributesDetails WITH(NOLOCK) where A.OrderID=B.orderId and A.OrderID=B.orderId)                    
 WHERE B.AgentID!='B2C'                    
 AND IsBooked=1                    
 AND B.BookingStatus IN (1,4,11)                    
 AND CONVERT(date,b.inserteddate) BETWEEN @FromDate AND @Todate                    
 AND ((@OfficeID = '') OR (B.OfficeID IN ( SELECT Data FROM sample_split(@OfficeID,','))))                    
 AND ((@AgencyNameList = '') OR (b.AgentID IN ( SELECT Data FROM sample_split(@AgencyNameList,','))))                    
 AND P.totalFare > 0                    
 AND B.totalFare > 0                    
 AND (SELECT userTypeID                     
   FROM agentLogin WITH(NOLOCK)                    
   WHERE CONVERT(VARCHAR(50),UserID) = b.AgentID) = 5                    
 AND (SELECT GroupId                     
   FROM agentLogin WITH(NOLOCK)                    
   WHERE CONVERT(VARCHAR(50),UserID) = b.AgentID)  IN (SELECT Data FROM sample_split(@GroupId, ','))                     
 ORDER BY B.inserteddate DESC                     
END