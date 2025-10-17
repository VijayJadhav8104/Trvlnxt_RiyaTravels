-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- execute  B2BHotel_Email 296  
-- =============================================  
CREATE PROCEDURE B2BHotel_Email  
 -- Add the parameters for the stored procedure here  
   
 @Id int=0  
  
AS  
BEGIN  
   
 select   
   HB.BookingReference as book_Id,   
   HB.HotelConfNumber as HotelConfirmation,   
   SM.Status as CurrentStatus,  
   '' as VoucherID,   
   CONVERT(varchar,HB.inserteddate,6) as BookingDate,   
   FORMAT (HB.ExpirationDate, 'MM/dd/yyyy hh:mm tt') as DeadlineDate,  
--   MB.Name as BranchName,   
   '' as BranchName,   
   '' as ReservationID,   
   --'' as PaymentGateway,   
   CASE WHEN B2BPaymentMode = 3 THEN 'Yes' ELSE 'No' END as PaymentGateway,   
   --HB.HotelName as PayHotel,   
   CASE WHEN B2BPaymentMode = 3 THEN 'Yes' ELSE 'No' END as PayHotel,   
   CONVERT(varchar,HB.CheckInDate,6) as CheckInDate,   
   CONVERT(varchar,HB.CheckOutDate,6) as CheckOutDate,   
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
   RM.NumberOfRoom as RoomNo,  
   HP.Salutation+' '+HP.FirstName + ' '+hp.LastName  as PassengerName,  
   HC.CountryName as Nationality,  
   HB.PassengerPhone,  
   HB.PassengerEmail,  
   HB.TotalAdults,  
   ISNULL(HB.TotalChildren,0)as TotalChildren,  
   HB.TotalRooms,  
   HB.DisplayDiscountRate as 'TotalPrice',  
     
     
   -------> Agent Information  
--   AL.FirstName+' '+AL.LastName as AgentName,  
   BR.AgencyName as AgentName,  
   HB.AgentRefNo,  
--   MU.FullName as ConsultantName,  
   '' as ConsultantName,  
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
     
  from Hotel_BookMaster HB  WITH (NOLOCK)  
  inner join Hotel_Pax_master HP  WITH (NOLOCK) on HB.pkId=HP.book_fk_id  
  inner join Hotel_Room_master RM  WITH (NOLOCK) on HB.pkId=RM.book_fk_id  
  inner join Hotel_CountryMaster HC  WITH (NOLOCK) on HP.Nationality=HC.CountryCode  
  inner join Hotel_Status_History SH  WITH (NOLOCK) on HB.pkId=SH.FKHotelBookingId  
  inner join Hotel_Status_Master SM  WITH (NOLOCK) on SH.FkStatusId=SM.Id  
    
  --inner join AgentLogin AL on HB.RiyaAgentID=AL.UserID  
  inner join B2BRegistration BR  WITH (NOLOCK) on HB.RiyaAgentID=BR.FKUserID   
  inner join mBranch MB  WITH (NOLOCK) on BR.BranchCode=MB.BranchCode  
  left join muser MU  WITH (NOLOCK) on HB.MainAgentID=MU.ID  
    
  where --book_Id is not null  and   
  (HB.pkId = @Id or @Id=0) and SH.IsActive=1  
    
   
    
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[B2BHotel_Email] TO [rt_read]
    AS [dbo];

