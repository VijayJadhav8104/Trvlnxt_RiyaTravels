
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getCount] --9
	@Userid int
	as
BEGIN
select
(SELECT  count(distinct(t.pkId)) as pid	from  [dbo].[tblBookMaster] t
			left join dbo.Paymentmaster pm on pm.order_id=t.orderId
			inner join tblPassengerBookDetails p on p.fkBookMaster=t.pkId
		where t.IsBooked =0 and t.pkId in (select fkBookMaster from tblPassengerBookDetails where IsRefunded =0)
			AND T.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1
) 
			AND t.AgentID = 'B2C'  )
 as 'BKNG Process B2C',

			(SELECT  count(distinct(t.pkId)) as pid
		from  [dbo].[tblBookMaster] t
			left join dbo.Paymentmaster pm on pm.order_id=t.orderId
			inner join tblPassengerBookDetails p on p.fkBookMaster=t.pkId
			left join B2BRegistration B ON cast(B.FKUserID as varchar)=CAST (T.AgentID AS VARCHAR(50))
		where t.IsBooked =0 and t.pkId in (select fkBookMaster from tblPassengerBookDetails where IsRefunded =0)
			AND T.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1
)
			 AND  pm.payment_mode is null or  pm.payment_mode != 'Hold' and t.IsBooked is not null
			AND t.AgentID != 'B2C' AND (t.AgentAction= 0 or t.AgentAction IS NULL AND t.TicketIssue IS NULL) and pm.order_status!='Hold' and pm.order_status!='Success') as 'Update Ticket',

			(SELECT  count(distinct(t.pkId)) as pid
from  [dbo].[tblBookMaster] t
left join dbo.Paymentmaster pm on pm.order_id=t.orderId
inner join tblPassengerBookDetails p on p.fkBookMaster=t.pkId
 where t.IsBooked =0 and t.pkId in (select fkBookMaster from tblPassengerBookDetails where IsRefunded =0)
 AND T.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1
) and AgentAction=2) AS 'Pending Tickets',


 (SELECT count(DISTINCT (BM.GDSPNR))
      FROM tblBookMaster BM 
      LEFT JOIN tblBookItenary BI ON bi.fkBookMaster = bm.pkId --and bi.isReturnJourney = 0
      LEFT JOIN tblPassengerBookDetails PB ON PB.fkBookMaster = BM.pkId --AND pb.isReturn=0
      WHERE  (PB.Iscancelled = 1  or PB.FailedFlag = 1)
	     AND BM.IsBooked = 1 
		 AND PB.IsRefunded = 0 
		 AND (isProcessRefund = 0 or isProcessRefund is null)  AND (cancelclosed = 0 or cancelclosed is null)
		  AND BM.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1
)) as 'Cancellation', 
	  0 as 'Reschedule',
	 (SELECT count(DISTINCT (BM.pkId))
      FROM tblBookMaster BM   LEFT JOIN tblBookItenary BI ON bi.fkBookMaster = bm.pkId 
      LEFT JOIN tblPassengerBookDetails PB ON PB.fkBookMaster = BM.pkId 
      WHERE PB.Iscancelled=0 and BM.IsBooked=1 and PB.IsRefunded=0 and isProcessRefund=1 and PB.CancelClosed=0
	  AND BM.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1
)) as 'Refund', 0 as 'Highrisk Payment'

END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getCount] TO [rt_read]
    AS [dbo];

