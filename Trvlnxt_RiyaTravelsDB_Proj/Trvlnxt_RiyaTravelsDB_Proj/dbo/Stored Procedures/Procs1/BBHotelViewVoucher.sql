-- =============================================            
-- Author:  <Author,,Name>            
-- Create date: <Create Date,,>            
-- Description: <Description,,>            
-- BBHotelViewVoucher 'RT443153','21057'            
-- =============================================            
CREATE PROCEDURE BBHotelViewVoucher            
             
 @bookingid varchar(200)=null,            
 @pkid varchar(200)=null            
            
AS            
BEGIN            
             
   select                   
   distinct (HP.Salutation+' '+HP.FirstName +' '+ HP.LastName) as PassengerName,                
                 
   HP.Salutation as 'title',              
   HP.FirstName as 'fname',              
   HP.LastName as 'Lname',              
   HB.BookingReference as book_Id,                   
   HB.HotelConfNumber as HotelConfirmation,                   
   SM.Status as CurrentStatus,                  
   '' as VoucherID,                   
   CONVERT(varchar,HB.inserteddate,0) as BookingDate,              
   --FORMAT (HB.inserteddate, 'MM/dd/yyyy hh:mm tt') as BookingDate,            
   CONVERT(varchar,HB.ExpirationDate,0) as DeadlineDate,              
   --FORMAT (HB.ExpirationDate, 'MM/dd/yyyy hh:mm tt') as DeadlineDate,                  
                
   '' as BranchName,                   
   '' as ReservationID,                   
                 
   CASE WHEN B2BPaymentMode = 3 THEN 'Yes' ELSE 'No' END as PaymentGateway,                   
                   
   CASE WHEN B2BPaymentMode = 3 THEN 'Yes' ELSE 'No' END as PayHotel,                   
   --CONVERT(varchar,HB.CheckInDate,6) as CheckInDate,                   
   --CONVERT(varchar,HB.CheckOutDate,6) as CheckOutDate,              
               
   CONVERT(varchar(12),HB.CheckInDate,0) as CheckInDate,              
   CONVERT(varchar(12),HB.CheckOutDate,0) as CheckOutDate,              
            
   HB.SelectedNights as NoofNights,                   
   HB.ClosedRemark as Remarks,                   
   HB.HotelName as HotelName,                   
   ISNULL (HB.HotelPhone,'02522-Null Case') as HotelPhoneNo,                  
   HB.HotelAddress1 as HotelAddress,                   
   HB.cityName as HotelCity,                  
   HB.CountryName as HotelCountry,                  
                     
   HB.pkId,                  
   HB.book_Id as BId,                  
   HB.CancellationPolicy,                  
   HB.ContractComment as ContractComment,                  
   HB.CancellationCharge,                  
   ISNULL( HB.request,'')as request,                  
   HB.BookingReference,                  
                  
   ------> Passanger Details                  
   RM.RoomTypeDescription as RoomType,                  
   HB.TotalRooms as RoomNo,                  
                     
   HC.CountryName as Nationality,                  
   HB.PassengerPhone,                  
   HB.PassengerEmail,                  
   HB.TotalAdults,                  
   ISNULL(HB.TotalChildren,0)as TotalChildren,                  
   HB.TotalRooms,                  
                 
   hp.room_fk_id as RoomId,                  
  -- cast(HB.DisplayDiscountRate / cast(HB.TotalRooms as int) as float) as 'TotalPrice',                  
  cast(cast(DisplayDiscountRate as float) / cast(TotalRooms as float)as float)  as 'TotalPrice',              
  cast(cast(expected_prize as float) / cast(TotalRooms as float)as float)  as 'TotalPriceSupplier',              
  cast((cast(cast(DisplayDiscountRate as float) - cast(expected_prize as float)as decimal(18,3)) * 100)/DisplayDiscountRate  as decimal(18,3)) as 'markup',              
  cast(cast(DisplayDiscountRate as float) - cast(expected_prize as float)as decimal(18,3))as 'ApproxRevenue',              
   --(cast(HB.DisplayDiscountRate as float) / cast(HB.TotalRooms as float))  'Rate',                   
                    
                     
                     
   -------> Agent Information                  
                  
   BR.AgencyName as AgencyName,    
   AL.FirstName+' '+AL.LastName as AgentName,          
   AL.Address+', '+AL.City+', '+AL.Country as AgentAddress,          
   AL.MobileNumber as AgentMobile,           
   HB.AgentRefNo,                  
   MU.FullName as ConsultantName,                  
   --'' as ConsultantName,                  
   '' as SalesManager,                  
             
   ------> Confirmation details                  
   ISNULL(HB.ConfirmationNumber, 0 ) as ConfirmationNumber,                  
   HB.HotelStaffName,                  
   HB.ConfirmationRemark,                  
   FORMAT (HB.ConfirmationDate, 'MM/dd/yyyy hh:mm tt') as ConfirmationDate,                  
   ------> Voucher number                  
   HB.VoucherNumber,                  
   HB.CurrencyCode as 'Currency',                  
                  
   HB.AgentId,                  
   HB.AgentRefNo,                  
   --Consultant,                  
   -- Destination,                  
   HB.TotalCharges as Amount                  
   --BookingDate,                  
   ,HB.SupplierName                  
   --, isnull(HB.SupplierReferenceNo,0) as SupplierReferenceNo                  
   ,HB.SupplierReferenceNo as SupplierReferenceNo                  
   ,HP.FirstName+' '+HP.LastName as TravellerName                  
   ,HB.AdminNote               
   ,HP.id as 'PaxId'          
   ,HB.AgentRemark as AgentReference          
   ,HB.SpecialRemark as SpecialNote        
   ,HB.Meal ,   
   case  
   when HB.SubAgentId > 0  
   THEN  
   AL.FirstName   
   ELSE  
   MU.FullName end as 'User'      
   ,MU1.FullName as 'SubUser'      
         
                     
  from Hotel_BookMaster HB  WITH (NOLOCK)                 
  left join mUser MU WITH (NOLOCK) on HB.MainAgentID=MU.ID                  
  left join Hotel_Pax_master HP WITH (NOLOCK) on HB.pkId=HP.book_fk_id                  
  left join Hotel_Room_master RM WITH (NOLOCK) on HB.pkId=RM.book_fk_id                  
  left join Hotel_CountryMaster HC WITH (NOLOCK) on HP.Nationality=HC.CountryCode                  
  left join Hotel_Status_History SH WITH (NOLOCK) on HB.pkId=SH.FKHotelBookingId                  
  left join Hotel_Status_Master SM WITH (NOLOCK) on SH.FkStatusId=SM.Id                  
                    
  left join AgentLogin AL WITH (NOLOCK) on HB.RiyaAgentID=AL.UserID                  
  left join B2BRegistration BR WITH (NOLOCK) on HB.RiyaAgentID=BR.FKUserID      
  Left Join mUser MU1 WITH (NOLOCK) on HB.SuBMainAgentID = MU1.ID      
    --inner join mBranch MB on BR.BranchCode=MB.BranchCode                  
    --inner join muser MU on HB.MainAgentID=MU.ID                  
                    
                   
                    
   where             
  (HB.pkId = @pkid or @pkid=0) and HB.BookingReference=@bookingid and SH.IsActive=1               
            
  order by HP.ID asc             
            
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[BBHotelViewVoucher] TO [rt_read]
    AS [dbo];

