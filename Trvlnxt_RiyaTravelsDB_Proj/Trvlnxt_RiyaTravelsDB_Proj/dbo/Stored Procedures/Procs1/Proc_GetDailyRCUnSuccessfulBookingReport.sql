          
--[dbo].[Proc_GetDailyRCUnSuccessfulBookingReport]          
CREATE Procedure Proc_GetDailyRCUnSuccessfulBookingReport                    
As              
Begin              
         
  SELECT             
 B2B.agencyname as CustomerName,      
   B2B.Icast as AgentId,      
   HB.inserteddate as BookingDate,      
   HB.BookingReference as BookingId,      
   HM.Status as BookingStatus,      
   (HB.CurrencyCode+' '+HB.DisplayDiscountRate) as BookingCurrencyAndAmount,      
   HB.SupplierName as Supplier,      
   HB.cityName as City,      
   HB.CountryName as Country,      
   HB.HotelName as HotelName,
   HB.CheckInDate as CheckInDate,
   HB.CheckOutDate as CheckOutDate,
   ISNULL(HPM.FirstName+' '+ HPM.LastName,'') as GuestName,
   ISNULL(HPM.Pancard,'') As PanCardNumber,
   ISNULL(HPM.PanCardName,'') As GuestPanName,
   ISNULL(HPM.PassportNum,'') As GuestPassportNumber,
   ISNULL(HB.failurereason,'') as BookingFailReason  
    FROM                 
 Hotel_BookMaster HB WITH (NOLOCK)                             
 join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and  HH.FkStatusId in (5,9,10,11,13)  and IsActive=1                        
 join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                                                                                                                                                                                        
 left join B2BRegistration B2B on B2B.FKUserID=HB.RiyaAgentID                            
 left join agentLogin AL on AL.UserID=B2B.FKUserID             
 left join mUser mu on mu.ID=HB.MainAgentID 
 left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and IsLeadPax=1
where  AL.userTypeID=4  and B2B.EntityName='RIYA TRAVEL TOURS INDIA PV'  and B2B.CustomerCOde='23r231'                                                           
  and HB.BookingPortal in('TNH','TNHAPI')                                       
  and HB.RiyaAgentID is not null                                                                                                                                                                 
  --and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')           
  and (Convert(date,HH.CreateDate) >= Convert(date,getdate()))                               
END