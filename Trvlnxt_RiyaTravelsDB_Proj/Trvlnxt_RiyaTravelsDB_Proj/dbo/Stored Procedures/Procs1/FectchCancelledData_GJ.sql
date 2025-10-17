

CREATE PROCEDURE [dbo].[FectchCancelledData_GJ]
	-- Add the parameters for the stored procedure here

AS
BEGIN

 IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL
  DROP table #tempTableA

  Create table #tempTableA
  ( pkId INT, orderId Varchar(100),riyaPNR Varchar(100), email Varchar(100),
   mob Varchar(100), depDate Datetime, GDSPNR Varchar(100), airlinePNR Varchar(100),
   airName Varchar(100), Cancellation_Date Datetime, sector Varchar(500), isProcessRefund Varchar(100)
   )


INSERT INTO #tempTableA 
Select *
 from
	( select distinct(BM.pkId), BI.orderId, BM.riyaPNR, BM.emailId as email,  
	         BM.mobileNo as mob, BM.depDate as 'deptDate', BM.GDSPNR, BI.airlinePNR, 
			 BI.airName, PB.CancelledDate AS 'Cancellation_Date', '' as sector, PB.isProcessRefund
      from tblBookMaster BM 
      inner join tblBookItenary BI ON bi.fkBookMaster=bm.pkId and bi.isReturnJourney=0
      INNER JOIN tblPassengerBookDetails PB ON PB.fkBookMaster =BM.pkId AND pb.isReturn=0
      WHERE  PB.Iscancelled=1 
	     and BM.IsBooked=1 
		 and PB.IsRefunded=0 
		 and isProcessRefund=0
	) p 
	ORDER BY p.Cancellation_Date DESC


--below Update for Sector data by Gaurav 03/07/2017 --	
		

IF ((
Select Count(1) from #tempTableA A 
Inner join tblBookItenary B
ON A.orderId = B.orderId and B.isReturnJourney=1) > 0)

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
     ON J.orderId=G.ID

	 END
Else

BEGIN

--Select X.* , Z.toSector, Z.frmSector, Z.frmSector +'-'+ Z.toSector as Sector

Update X
SET X.sector = Z.frmSector +'-'+ Z.toSector
from #tempTableA X
Inner join tblBookItenary Z
ON  X.orderId= Z.orderId 

END
	
SELECT * FROM #tempTableA

	
END

--Select * from tblBookItenary where isReturnJourney = 1




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FectchCancelledData_GJ] TO [rt_read]
    AS [dbo];

