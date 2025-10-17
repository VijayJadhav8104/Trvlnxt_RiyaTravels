
CREATE PROCEDURE [dbo].[SearchRefund]
	-- Add the parameters for the stored procedure here
	@Search varchar(30)= null
AS
BEGIN

	select * into #tempTableA from
	( select b.pid,b.paxfname+' '+b.paxlname as paxname,a.emailId as email,a.mobileNo as mob,a.RiyaPNR,a.airName,tbi.airlinePNR ,
	
			 a.frmsector,a.tosector AS tosector,a.depDate AS deptdate,a.deptTime AS depttime,a.arrivaldate AS arrivaldate,
			a.OrderId,b.totalfare,a.inserteddate as booking_date,a.GDSPNR,ch.RefundAmount,order_status,
			c.payment_mode,c.getway_name
     	   
	 from tblBookMaster a
	 inner join tblPassengerBookDetails b
	 on a.pkId=b.fkBookMaster
	  left join CancellationHistory ch on a.OrderId=ch.OrderId and ch.FlagType=2
	 left join Paymentmaster c
	 on a.OrderId=c.order_id
	 	 left join tblBookItenary tbi
	 on a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
	 where b.IsRefunded=0 and a.IsBooked=1 and a.RiyaPNR like '%'+@Search+'%' or a.GDSPNR like '%' +@Search+'%'  or @Search ='' 
				And  b.RefundAmount >0 )p ORDER BY 
				p.booking_date DESC
	
	select * from #tempTableA

	drop table #tempTableA
	
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SearchRefund] TO [rt_read]
    AS [dbo];

