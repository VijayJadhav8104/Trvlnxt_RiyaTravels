CREATE Procedure [dbo].[Sp_GetPrintpopupPassengerList]
@RiyaPNR nvarchar(20)=null
as
begin

--select RiyaPNR, title+'. '+paxFName+' '+paxLName +' '+'('+paxType+')' as PassengerName,tp.pid,tp.PaxType from tblPassengerBookDetails tp
--left join tblBookMaster tb on tb.pkid=tp.fkbookmaster
--where tb.riyapnr=@RiyaPNR and (tp.isReturn=0 or (tp.isReturn=1 and (select count(pkId) from tblBookMaster where riyaPNR=@RiyaPNR) =1)) order by paxType	


SELECT tb.RiyaPNR
			, (title+'. '+paxFName+' '+paxLName +' '+'('+paxType+')') as PassengerName
			, A.PaxType
			, A.pid
	INTO #mT FROM tblPassengerBookDetails AS A WITH(NOLOCK)
	LEFT JOIN tblBookMaster tb WITH(NOLOCK) on tb.pkid=A.fkbookmaster
	WHERE tb.riyapnr= @RiyaPNR
	AND A.totalFare>0
	ORDER BY paxType

	SELECT DISTINCT RiyaPNR
					, PassengerName
					, PaxType
					, (SELECT STUFF((SELECT ',' + CONVERT(Varchar, B.pid) FROM #mT B
						WHERE B.PassengerName = #mT.PassengerName
						FOR XML PATH('')),1,1,''))  AS PID
	FROM #mT 

	DROP TABLE #mT


end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetPrintpopupPassengerList] TO [rt_read]
    AS [dbo];

