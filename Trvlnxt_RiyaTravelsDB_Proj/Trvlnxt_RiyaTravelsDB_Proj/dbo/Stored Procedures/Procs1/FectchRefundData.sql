
CREATE PROCEDURE [dbo].[FectchRefundData] --9
	-- Add the parameters for the stored procedure here
	@Userid int
AS
BEGIN

	

--		select * into #tempTableA from
--	( select distinct(BM.pkId),BI.orderId, BM.riyaPNR,BM.emailId as email,  BM.mobileNo as mob,BM.depDate as 'deptDate',
--	BM.GDSPNR,BI.airlinePNR, BI.airName,
--getdate() AS 'Cancellation_Date','' as sector,PB.isProcessRefund
-- from tblBookMaster BM 
--  inner join tblBookItenary BI ON bi.fkBookMaster=bm.pkId and bi.isReturnJourney=0
--  INNER JOIN tblPassengerBookDetails PB ON PB.fkBookMaster =BM.pkId AND pb.isReturn=0
--   WHERE  PB.Iscancelled=0 and BM.IsBooked=1 and PB.IsRefunded=0 and isProcessRefund=1)p ORDER BY 
--				p.Cancellation_Date DESC
	
--	select * from #tempTableA

--	drop table #tempTableA


IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL
  DROP table #tempTableA

  CREATE TABLE #tempTableA
  ( pkId INT, orderId VARCHAR(100),riyaPNR VARCHAR(100), email VARCHAR(100),
    mob VARCHAR(100), depDate DATETIME, GDSPNR VARCHAR(100), airlinePNR VARCHAR(100),
    airName VARCHAR(100), Cancellation_Date DATETIME, sector VARCHAR(500), 
	isProcessRefund VARCHAR(100),Country varchar(2),OfficeID varchar(50),
	AgencyName VARCHAR(50)
   )


INSERT INTO #tempTableA 
SELECT *
 FROM
	( SELECT DISTINCT (BM.pkId), BI.orderId, BM.riyaPNR, BM.emailId as email,  
	         BM.mobileNo as mob, BM.depDate as 'deptDate', BM.GDSPNR, BI.airlinePNR, 
			 BI.airName, PB.CancelledDate AS 'Cancellation_Date', '' as sector, PB.isProcessRefund,bm.Country,bm.OfficeID,
			 ISNULL((SELECT B.AgencyName FROM B2BRegistration B WHERE CONVERT(varchar(50),B.FKUserID)=BM.AgentID),'B2C') as AgencyName
      FROM tblBookMaster BM 
      LEFT JOIN tblBookItenary BI ON bi.fkBookMaster = bm.pkId --and bi.isReturnJourney = 0
      LEFT JOIN tblPassengerBookDetails PB ON PB.fkBookMaster = BM.pkId --AND pb.isReturn=0
      WHERE PB.Iscancelled=0 and BM.IsBooked=1 and PB.IsRefunded=0 and isProcessRefund=1
	   AND BM.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)
	   and PB.CancelClosed=0
	) p 
 ORDER BY p.Cancellation_Date DESC
	
--below Update for Sector data by Gaurav 03/07/2017 --	
		

IF ((
Select Count(1) from #tempTableA A 
Inner join tblBookItenary B
ON A.orderId COLLATE Latin1_General_CI_AI = B.orderId and B.isReturnJourney=1) > 0)


Begin 
	
	Update J  
	SET J.sector = G.A 
	From #tempTableA J
	Inner JOIN 
	( Select A,  ID  
	  from (
           Select A.frmSector + '-' + A.toSector +'-'+ B.toSector as A,  --
		    A.orderId as ID,B.isReturnJourney as RJ, ROW_NUMBER() Over ( PARTITION BY A.orderId Order by A.orderId ) as RN 
           from tblBookItenary A 
           Inner join tblBookItenary B ON A.orderId= B.orderId  and B.isReturnJourney = 1
           ) C
      where RN=1 and C.RJ = 1 ) G
     ON J.orderId COLLATE Latin1_General_CI_AI =G.ID

	 END
Else

BEGIN

--Select X.* , Z.toSector, Z.frmSector, Z.frmSector +'-'+ Z.toSector as Sector

Update X
SET X.sector = Z.frmSector +'-'+ Z.toSector
from #tempTableA X
Inner join tblBookItenary Z
ON  X.orderId COLLATE Latin1_General_CI_AI = Z.orderId 

END

	
SELECT orderId, riyaPNR,email, mob, min(depDate) as depDate, GDSPNR,airlinePNR, airName,Cancellation_Date,sector,isProcessRefund,
Country,OfficeID,AgencyName
FROM #tempTableA
Group by orderId, riyaPNR,email, mob, GDSPNR,airlinePNR, airName,Cancellation_Date,sector,isProcessRefund,Country,OfficeID ,AgencyName 

drop table #tempTableA 
	
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FectchRefundData] TO [rt_read]
    AS [dbo];

