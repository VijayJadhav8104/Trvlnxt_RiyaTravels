CREATE proc [dbo].[PushB2CData] -- [PushB2CData] 'RT20181023182827526'

--@orderId nvarchar(50)

As
BEGIN

	select p.pid as ID,b.orderId as 'Order_Id', CASE WHEN b.CounterCloseTime=1 THEN 'AIR-DOM' ELSE 'AIR-INT' END as 'BookingType',case when LEN(p.ticketNum)>20 
	
 then SUBSTRING(SUBSTRING(p.ticketNum, 9, CHARINDEX('/', p.ticketNum)),1,10) Else p.ticketNum END as 'TicketNumber'

,REPLACE(CASE WHEN b.airCode='SG' THEN 'SGO' WHEN b.airCode='G8' THEN 'G8W' WHEN b.airCode='6E' THEN  '6EQ​'  ELSE b.airCode END,'?','') as 'SupplierCode'

,'ICUST35086' as 'CustomerNumber',case when p.IsRefunded=1 then 'Cancellation' else 'Sale' end as 'TransactionType'

,case when b.Vendor_No is not null then b.Vendor_No else '' end  'VendorNo'

,'CASH' as FormofPayment,b.GDSPNR as 'PNR',p.paxType as 'PaxType',p.title+'  '+ p.paxFName+' '+p.paxLName as 'PAX Name'

,'BOMRC' as'LocationCode',convert(varchar(11),b.inserteddate,103) as 'IssueDate',convert(varchar(11),t.inserteddt,103) as 'Payment Date','Cash' as 'Mode of Payment','INR' as 'CurrencyType',P.basicFare 'BasicFare',p.OCTax as 'OCtax',p.YQ as 'YQTax',p.YRTax


 as 'YrTax'

,p.JNTax as 'JNTax',p.INTax as 'XTTax',p.serviceCharge as 'ServiceCharge',P.totalFare as 'TotalFare',t.mer_amount as 'decAmount',b.PLBCommission as 'PlbC', 'OFFLINE' as 'Booking Source Type'

,'CREDIT' as 'TOPUP/CREDIT'

from tblBookMaster b 
join tblPassengerBookDetails p 
on b.pkId=p.fkBookMaster 
join Paymentmaster t 
on b.orderId=t.order_id
where b.IsBooked=1 and (p.ERPkey is null or p.IsRefunded=1)  and convert(varchar(25),b.inserteddate,23)=Convert(varchar(25),GETDATE(),23)  order by IssueDate desc--and p.isReturn=0 
----and b.orderId='RT20181102180350947' order by b.orderId desc -- b.orderId='RT20181102180350947'cast(


--select * from nav where id ='88825'

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[PushB2CData] TO [rt_read]
    AS [dbo];

