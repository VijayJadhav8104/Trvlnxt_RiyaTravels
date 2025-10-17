CREATE Procedure [dbo].[PrintCopy_GetPassengerList]      
	@RiyaPNR nvarchar(20)=null      
AS      
BEGIN
	SELECT tb.RiyaPNR
			, (ISNULL(title,'')+'. '+paxFName+' '+ISNULL(paxLName,'') +' '+'('+ CASE WHEN paxType = 'LBR' OR paxType = 'IIT' THEN 'ADULT' ELSE ISNULL(paxType, '')END + ')') as PassengerName
			, CASE 
              WHEN A.paxType = 'LBR'  OR A.paxType = 'IIT' THEN 'ADULT'
              ELSE ISNULL(A.paxType, '')
              END AS paxType
			, A.pid
	INTO #mT FROM tblPassengerBookDetails AS A
	LEFT JOIN tblBookMaster tb on tb.pkid=A.fkbookmaster
	WHERE tb.riyapnr= @RiyaPNR
	--AND A.totalFare > 0
	ORDER BY a.pid ASC

	SELECT DISTINCT RiyaPNR
					, PassengerName
					, PaxType
					, (SELECT STUFF((SELECT ',' + CONVERT(Varchar, B.pid) FROM #mT B
						WHERE B.PassengerName = #mT.PassengerName
						FOR XML PATH('')),1,1,''))  AS PID
	FROM #mT 
	ORDER BY PID

	DROP TABLE #mT
END