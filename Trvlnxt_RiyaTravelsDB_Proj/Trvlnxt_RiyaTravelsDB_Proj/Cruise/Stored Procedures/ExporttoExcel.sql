CREATE procedure [Cruise].[ExporttoExcel]
 @Id VARCHAR(20) = NULL ,
 @BookingFromDate varchar(50)='',                                
 @BookingToDate varchar(50)='',  
 @RiyaUserID nvarchar(200)='',                                
 @Branch nvarchar(200)='',                                
 @Agent nvarchar(200)='',  
 @BookingID nvarchar(200)='',
 @BookingStatus nvarchar(200)=''
 As
 BEGIN
 Select DISTINCT 
'Cruise' as 'Service',
bk.BookingId,
bk.OrderId,
mb.Name as 'Branch',
mb.BranchCode,
b2b.AgencyName,
al.UserName,
bk.AgentId,
(case when bk.Status=0 then 'NA' when bk.Status=1 then 'Confirmed'  when bk.Status=2 then 'Hold' when bk.Status=3 then 'PendingTicket'  when bk.Status=4 then 'Cancel'
 when bk.Status=5 then 'Close'  when bk.Status=6 then 'Cancellation'  when bk.Status=7 then 'ToBeReschedule' 
 when bk.Status=8 then 'Reschedule'  when bk.Status=9 then 'HoldCancel'  when bk.Status=10 then 'BookingTrack' 
 when bk.Status=11 then 'OnlineCancellation'  when bk.Status=12 then 'TicketingAccess'  when bk.Status=13 then 'ConsoleInserted' when bk.Status=14 then 'Failed' END) AS Status, 
(select  pax.FirstName +' '+ pax.LastName from Cruise.BookedPaxDetails pax where pax.FkBookingId=bk.Id and pax.IsPrimaryPax=1) as  'Leader Name ',
(select Count(pax.FkBookingId) from Cruise.BookedPaxDetails pax where pax.FkBookingId=bk.Id) as 'No.of Passenger',
pax.DateOfBirth,
pax.PanName,
pax.Pan,
pax.PassportNumber,
pax.IssueDate,
pax.ExpiryDate,
bk.CreatedOn as 'Booking Date',
BI.EndDate as 'CheckOut Date',
BI.StartDate as 'Service Date',
(select  ISNULL(ite.StartDate,'') as  StartDate from Cruise.BookedItineraries ite where ite.FkBookingId=bk.Id) as 'Travel Date',
BI.DestinationPort as 'Destination',
BI.Nights as 'Duration (Days &Nights)',
'INR' as 'Booking Currency',
'INR' as 'Supplier Currency',
bk.RiyaCommission,
bk.AgentCommission ,
bk.BasePrice,
bk.PortCharges,
bk.Gratuity,
bk.FuelSurcharge,
bk.Discount,
bk.ExcursionTotalPrice,
bk.GrossPrice,
bk.GrossTax,
bk.AmountPaidbyAgent as 'Booking Amount',
CASE 
				WHEN bk.PaymentMode = 1
					THEN 'Hold'
				WHEN bk.PaymentMode = 2
					THEN 'Credit Limit'
				WHEN bk.PaymentMode = 3
					THEN 'Make Payment'
				WHEN bk.PaymentMode = 4
					THEN 'Self Balance'
				END AS 'PaymentMode',
'----'as 'PG Charges',
'----' as'Payment Gateway Status',
'----' as 'Payment Gateway Type',
b2b.GST_No as 'GST Number',
bk.Supplier,
bk.BookingReferenceid as 'Supplier ref No',
al.ROE,
BI.DestinationPort as 'City',
al.Country,
BI.Ship as 'Ship Name',
BI.Nights as'no of Night',
pax.RoomNo,
pax.Deck,
pax.RoomType,
bk.OBTCNo
 from Cruise.Bookings bk   
  LEFT JOIN AgentLogin al ON bk.AgentId = al.UserID  
  LEFT join cruise.BookedPaxDetails pax on bk.id=pax.FkBookingId
  LEFT join cruise.BookedItineraries BI on bk.Id=BI.FkBookingId	
  LEFT JOIN B2BRegistration b2b ON bk.AgentId = b2b.FKUserID  
  LEFT JOIN mUser usr ON bk.RiyaUserId = usr.ID  
  LEFT JOIN  mBranch MB on MB.BranchCode=b2b.BranchCode  
  WHERE 
  
     (Convert(varchar(12),bk.CreatedOn,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                                
     case when @BookingToDate <> ''   
	 then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)  
     else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate=''))                                            
    
    
  And  
  (( @RiyaUserID ='') or (bk.RiyaUserId IN  (select Data from sample_split(@RiyaUserID,','))) )    
  And (( @Branch ='') or (b2b.BranchCode IN  (select Data from sample_split(@Branch,','))) )   
  And ((@Agent ='') or (bk.AgentID IN  (select Data from sample_split(@Agent,','))) )
  And (( @BookingStatus ='') or (bk.Status IN  (select Data from sample_split( @BookingStatus,','))) ) 
  And ((@BookingID ='') or (bk.BookingReferenceid = @BookingID))         
  And   
  bk.IsActive =1   
	

END

--[Cruise].[ExporttoExcel] '','','','','','','',1