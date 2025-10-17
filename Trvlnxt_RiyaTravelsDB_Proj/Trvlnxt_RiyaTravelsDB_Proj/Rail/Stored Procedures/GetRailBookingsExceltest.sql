CREATE PROCEDURE [Rail].[GetRailBookingsExceltest]
 @Id int=0,
 @BookingFromDate varchar(50)='',                              
 @BookingToDate varchar(50)='',
 @RiyaUserID nvarchar(200)='',                              
 @Branch nvarchar(200)='',                              
 @Agent nvarchar(200)='',
 @BookingID nvarchar(200)=''
AS
BEGIN
	SELECT DISTINCT bk.Id,
	'Rail' as 'Service',
	 bk.BookingId ,
	 '--' as'Order ID',
	 '--' as'Branch',
	 b2b.BranchCode,
	 b2b.AgencyName,
	 usr.UserName,
	 bk.AgentId,
	 (select top 1 pax.FirstName +' '+ pax.LastName from Rail.PaxDetails pax where pax.fk_ItemId=bk.Id) as 'Leader Name ',
	 bk.creationDate as 'Booking Date',
	 bk.creationDate as 'Service Date',
	 bk.expirationDate as 'CheckOut Date',
	 bk.creationDate as 'Service Date',
	 '--' as'Travel Date',
	 '-----' as 'Destination',
	'-----' as 'Duration (Days &Nights)',
	'--' as'Deadline',
	 bk.bookingStatus as [Current Status],
	bk.AmountPaidbyAgent as 'Booking Amount',
	'INR' as 'Booking Currency',
	'----'as 'Agent rate (INR)',
	'----'as 'AgentRate[Booking Currency]',
	'----' as 'Revenue', 
	--CASE 
	--			WHEN bk.PaymentMode = 1
	--				THEN 'Hold'
	--			WHEN bk.PaymentMode = 2
	--				THEN 'Credit Limit'
	--			WHEN bk.PaymentMode = 3
	--				THEN 'Make Payment'
	--			WHEN bk.PaymentMode = 4
	--				THEN 'Self Balance'
	--			END AS 'PaymentMode',
	'----'as 'PG Charges',
	'----' as'Payment Gateway Status',
	'----' as 'Payment Gateway Type',
	b2b.GST_No as 'GST Number',
	'-----' as 'Supplier',
	bk.BookingReference as 'Supplier ref No',
	'INR' as 'Supplier Currency',
	'----' as 'Supplier rate (SC)',
	al.ROE,
	'----' as 'Supplier rate (INR)',
	'----' as 'City',
	al.Country,
   --pax.leadTraveler as 'No.of Passenger'
	bk.OBTCNo,
	b2b.PANName,
	b2b.PANNumber,
	'----'as 'Passport Number'
	
		FROM Rail.Bookings bk
		LEFT JOIN AgentLogin al ON bk.AgentId = al.UserID
		LEFT JOIN B2BRegistration b2b ON bk.AgentId = b2b.FKUserID
		LEFT JOIN mUser usr ON bk.RiyaUserId = usr.ID
		LEFT JOIN RAIL.BookingItems bki ON bk.Id=bki.fk_bookingId
		left join rail.PaxDetails pax on  pax.bookingId=bk.Id
		where 
		(Convert(varchar(12),bk.creationDate,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                                
		case when @BookingToDate <> ''   
		then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)  
		else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate='')) 
		And(( @RiyaUserID ='') or (bk.RiyaUserId IN  (select Data from sample_split(@RiyaUserID,','))) )    
		And (( @Branch ='') or (b2b.BranchCode IN  (select Data from sample_split(@Branch,','))) )   
		And ((@Agent ='') or (bk.AgentID IN  (select Data from sample_split(@Agent,','))) )  
		And ((@BookingID ='') or (bk.BookingReference = @BookingID))
		order by bk.creationDate desc
		
END

