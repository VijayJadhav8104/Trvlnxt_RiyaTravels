--GetBookingConfirmedDetailsNewDublicate'TNH00020771','',21961                                                      
CREATE PROCEDURE GetBookingConfirmedDetailsNewDublicate                                                                                                                                 
                                                                                                                                
 @bookingid varchar(200)=null,                                                                                                                              
 @pkid varchar(200)=null ,                                                                                                          
 @AgentId int                                                                                                          
                                                                                                                              
AS                                                                                                                              
BEGIN                                                                                                                              
                                                                                                                               
   select                                                                                                             
   HB.DisplayDiscountRate,                                                                                                            
   (HB.LeaderTitle+' '+ HB.LeaderFirstName+' '+HB.LeaderLastName) as LeaderFirstName,                                                                                                                              
   HB.pkId,                                                                                 
   HB.LeaderLastName,                                                                                
   HB.HotelConfNumber as HotelConfirmation,                                                                                        
   HB.HotelConfNumber as HotelConfNumber,                                                                                        
   SM.Status as CurrentStatus,                                                                                                                                    
   '' as VoucherID,                                                                                                                                     
   CONVERT(varchar,HB.inserteddate,0) as BookingDate,                                                                                                                                
   --FORMAT (HB.inserteddate, 'MM/dd/yyyy hh:mm tt') as BookingDate,                                                                                                                              
   ISNULL(CONVERT(varchar,HB.ExpirationDate,0),GETDATE()) as DeadlineDate,                                                                                                                                
   --FORMAT (HB.ExpirationDate, 'MM/dd/yyyy hh:mm tt') as DeadlineDate,                                                                                                                                                                                        

   '' as BranchName,                                                                                                                                     
   '' as ReservationID,                                                                                                                                                                    
   CASE WHEN B2BPaymentMode = 3 THEN 'Yes' ELSE 'No' END as PaymentGateway,        
              
  HB.PayAtHotel,                                  
--CONVERT(varchar,HB.CheckInDate,6) as CheckInDate,                             
   --CONVERT(varchar,HB.CheckOutDate,6) as CheckOutDate,                               
   CONVERT(varchar(12),HB.CheckInDate,0) as CheckInDate,                                          
   CONVERT(varchar(12),HB.CheckOutDate,0) as CheckOutDate,                                               
   --HB.SelectedNights as NoofNights,                                                     
   HB.SelectedNights,                                                                
   HB.ClosedRemark as Remarks,                                                 
   HB.HotelName as HotelName,                                                                                  
   ISNULL (HB.HotelPhone,'') as HotelPhoneNo,                                                                                      
   HB.HotelAddress1 as HotelAddress,                                                                                     
   HB.cityName as HotelCity,                                                              
   HB.CountryName as HotelCountry,                                                                                                  
   HB.orderId,                                                                                                                        
   HB.pkId,                                                                                    
   HB.book_Id as BId,                                                                                                                                
   HB.CancellationPolicy,                                                                                                                                    
   HB.ContractComment as ContractComment,                                                                                                                  
   HB.CancellationCharge,                                                                                                                                    
   ISNULL( HB.request,'')as request,                                                                                                                                    
   HB.BookingReference,                                                                                                                
    HB.TotalRooms as totalroom,                                            
 AL.AgentLogoNew as AgentLogo,                                        
 AL.Address as AgentAddress,                                        
   ------> Passanger Details                                                                                                                                                                                                                             
                                                                                                                                      
   HC.CountryName as Nationality,                                                                                                                                    
   HB.PassengerPhone,                                                                                                                                    
   BR.AddrEmail as passengeremail,                                                                                                 
   HB.TotalAdults,                                                                                                                                    
   ISNULL(HB.TotalChildren,0)as TotalChildren,                                                                                                     
   HB.TotalRooms,                                 
   HB.FileNo as  FileNo,                                
   HB.InquiryNo as InquiryNo,     
   HB.OpsRemark as OpsRemark,                                
   HB.AcctsRemark as AccountRemark,                                
 HB.SupplierRate as SupplierRate,                                
   HB.SupplierCurrencyCode as SupplierCurrencyCode,                               
                                                                                                               
  -- cast(HB.DisplayDiscountRate / cast(HB.TotalRooms as int) as float) as 'TotalPrice',                
  cast(cast(DisplayDiscountRate as float) / cast(TotalRooms as float)as float)  as 'TotalPrice',                                                                                            
  cast(cast(expected_prize as float) / cast(TotalRooms as float)as float)  as 'TotalPriceSupplier',                             
  cast((cast(cast(DisplayDiscountRate as float) - cast(expected_prize as float)as decimal(18,3)) * 100)/DisplayDiscountRate  as decimal(18,3)) as 'markup',                                                    
  cast(cast(DisplayDiscountRate as float) - cast(expected_prize as float)as decimal(18,3))as 'ApproxRevenue',                                                                                                                      
   --(cast(HB.DisplayDiscountRate as float) / cast(HB.TotalRooms as float))  'Rate',                                                                                                
                                                   
                                            
                                                                                                                                       
   -------> Agent Information                                                                   
                                                                                                                                    
   BR.AgencyName as agencyname,                                                                                                                      
   AL.FirstName+' '+AL.LastName as AgentName,                                                                                                                  
   AL.Address+', '+AL.City+', '+AL.Country as AgentAddress,                                                                                                                            
   BR.AddrMobileNo as AgentMobile,                                                                                        
   HB.AgentRefNo as AgentRefNo,                                                                                        
   --HB.AgentRefNo,                                                                           
   MU.FullName as ConsultantName,                                                          
   --'' as ConsultantName,                                                                                                                                    
   '' as SalesManager,                                   
    AL.BookingCountry as 'BookingCountry'   ,                                       
                                                                                                                               
------> Confirmation details                                                                                                                                    
   ISNULL(HB.ConfirmationNumber, 0 ) as ConfirmationNumber,                                                                                                                                    
   HB.HotelStaffName,                                                                                   
   HB.ConfirmationRemark,                                                                                                                                    
   FORMAT (HB.ConfirmationDate, 'MM/dd/yyyy hh:mm tt') as ConfirmationDate,                      
   ------> Voucher number                                                                                                                                    
   HB.VoucherNumber,                                                                                                                                    
 HB.CurrencyCode as 'Currency',                                   
   HB.CurrencyCode as BookingCurrency,                                                                                                     
   HB.AgentId,                                                                                                                                                     
   --Consultant,             
   -- Destination,                                
   HB.TotalCharges as Amount                                                                                                                                    
   --BookingDate,                                                                                         
   ,HB.SupplierName                                                                                           
   , isnull(HB.SupplierReferenceNo,0) as SupplierReferenceNo                                                                            
   ,HB.providerConfirmationNumber as SupplierReferenceNo                                                                                                
    ,HB.SearchApiId                                                                                                                              
   ,HB.AdminNote                                                                                                       
                                                                                                                 
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
   ,HB.RiyaAgentID                                                                                          
   ,HB.OBTCNo                                                                                          
   ,HB.SpecialRemark                                                                       
   ,MU.FullName as RiyaUserName                                                                                       
   ,HB.B2BPaymentMode as B2BPaymentMode                                                      
   ,HB.CancellationDeadLine AS CancelDate                                                                                    
   ,HB.expected_prize as ExpectedPrize                                                                     
   ,isnull(HB.HotelTaxes,0) as HotelTaxes                         
   ,isnull(HB.HotelTotalGross,0) as HotelTotalGross                         
   ,isnull(HB.AgentCommission,0) as AgentCommission                        
   ,isnull(HB.HotelTDS,0) as HotelTDS                         
   ,isnull(HB.TotalRoomAmount,0) as TotalRoomAmount                                                                
   ,SM.id as BookingStatusId,                                          
  isnull (HB.MainAgentID,0) as MainAgentID ,                                                         
   ISNULL(HB.FailureReason,'') as FailureReason,                                                      
   ISNULL(HB.HotelPhone,'02522-Null Case') as HotelPhone,                                
   ISNULL(HB.HotelRating,'') as HotelRating,                                              
   ISNULL(HB.AmountBeforePgCommission,0) as AmountBeforePgCommission,                             
   ISNULL(HB.Lat,0) as Lat,                            
   ISNULL(HB.Lang,0) as Lang,                    
   ISNULL(HB.FullRefund,0) AS FullRefund,                    
    ISNULL(HB.HotelIncludes,'') AS HotelIncludes,      
 ISNULL(HB.STotalRate,0) AS STotalRate,      
 ISNULL(HB.SCurrency,0) AS SCurrency,    
 ISNULL(HB.BookingPortal,'TNH') AS BookingPortal,  
  ISNULL(HB.AgentServiceFee,0) AS AgentServiceFee,    
  ISNULL(HB.AgentServiceFeeRealTime,0) AS AgentServiceFeeRealTime       
      
  ----> B2BHotel_Commission                                                 
  ,ISNULL(HComm.Commission,0) as Commission                                                                          
  ,ISNULL(HComm.GST,0) as GST                                                                          
  ,ISNULL(HComm.TDS,0) as TDS                                                                          
  ,ISNULL(HComm.SupplierCommission,0) as SupplierCommission                                    
  ,ISNULL(HComm.RiyaCommission,0) as RiyaCommission                                                                          
  ,ISNULL(HComm.EarningAmount,0) as EarningAmount                            
  ,ISNULL(HComm.Payment,0) as Payment                                                                      
  ,Isnull(HComm.TDSDeductedAmount,0) TDSDeductedAmount                                                                   
                                                                    
  ,ISNULL(HB.CheckInTime,'') as CheckInTime                                                                      
  ,ISNULL(HB.CheckOutTime,'') as CheckOutTime                                                                     
  ,isnull(HB.SuBMainAgentID,0) as SubMainAgentId                                                                    
  ,isnull(HB.SB_ReversalStatus,0) as SelfBalanceReversal            
  ,isnull(HB.ChainName,'') as ChainName            
  ,isnull(HB.MembershipNumber,'') as MembershipNumber            
  ,ISNULL(BR.ShowHotelLogs,0) as ShowHotelLogs                                       
  from Hotel_BookMaster HB                                                                                  
  left join mUser MU on HB.MainAgentID=MU.ID                                                                                                                                                                     
  left join Hotel_CountryMaster HC on HB.BookingCountry=HC.CountryCode                                                                                                       
  left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId                                                                                                                                    
  left join Hotel_Status_Master SM on SH.FkStatusId=SM.Id                                                                                                                
  left join AgentLogin AL on HB.RiyaAgentID=AL.UserID                                                                                        
  left join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                       
  Left Join mUser MU1 on HB.MainAgentID = MU1.ID                                                                            
  left join B2BHotel_Commission HComm on HComm.Fk_BookId=HB.pkId                                             
  --inner join mBranch MB on BR.BranchCode=MB.BranchCode                                                    
  --inner join muser MU on HB.MainAgentID=MU.ID                                                         
   where                                                                           
  (HB.pkId = @pkid or @pkid=null or(HB.BookingReference=@bookingid and BookingReference!='') or @bookingid=null) and SH.IsActive=1 and RiyaAgentID=@AgentId                                                                                                   
                       
-- passenger details                                                                                                          
  select ISNULL(PAX.MealBasis,'') as MealBasis,
  CONVERT(date, PAX.IssueDate, 103),
  CONVERT(date, PAX.Expirydate, 103),
  
  PAX.* from Hotel_Pax_master as PAX                                                                                                              
                                                                 
  INNER JOIN Hotel_BookMaster HB ON PAX.book_fk_id=HB.pkId                                                                                                              
                                                                                                                
  where (HB.pkId = @pkid or @pkid=null or (HB.BookingReference=@bookingid and BookingReference!='') or @bookingid=null) and RiyaAgentID=@AgentId                                                                                              
                                                                                                                                    
--- Room Details                                                                                             
  select ISNULL(Room.RoomMealBasis,'') as RoomMealBasis,  Room.* from Hotel_Room_master as Room                                                                                                              
                              
  INNER JOIN Hotel_BookMaster HB ON Room.book_fk_id=HB.pkId                            
  where (HB.pkId = @pkid or @pkid=null or(HB.BookingReference=@bookingid and BookingReference!='') or @bookingid=null)  and RiyaAgentID=@AgentId                                                                                                           
                                                                                                 
-- Room Rates Per night                                                                                              
                                                                                                             
  select RPN.* from Hotel.Hotel_RoomRatesPerNight as RPN                                                              
                                                                                                                
  INNER JOIN Hotel_BookMaster HB ON RPN.FkBookingId=HB.pkId                                    
                                                                                                                
  where (HB.pkId = @pkid or @pkid=null or (HB.BookingReference=@bookingid and BookingReference!='') or @bookingid=null) and RiyaAgentID=@AgentId                                                                                                           
                                   
---- cancellation pollicy                                                                                         
                                                                                              
 select isnull(HBCP.CPStardDate,GETDATE()) as CPStardDate, isnull(HBCP.CPEndDate,GETDATE()) as CPEndDate, HBCP.* from  [Hotel].HotelCancelBookPolicies as HBCP                                           
    INNER JOIN Hotel_BookMaster HB ON HB.pkId=HBCP.FKBookingId                                             
  where (HB.pkId = @pkid or @pkid=null or (HB.BookingReference=@bookingid and BookingReference!='') or @bookingid=null) and RiyaAgentID=@AgentId                                     
                                                                                           
  ----- GST Details                                                        
  select isnull(GST.GstNumber,'') as GstNumber,isnull(GST.CompanyName,'') as CompanyName,isnull(GST.EmailId,'') as EmailId,                                                               
  isnull(GST.MobileNo,'') as MobileNo,isnull(GST.Address,'') as Address,isnull(GST.City,'') as City,isnull(GST.State,'') as State,           
  isnull(GST.PinCode,'') as PinCode from  Hotel_BookingGSTDetails as GST                                                              
   INNER JOIN Hotel_BookMaster HB ON HB.pkId=GST.PKID                                                                                                  
  where (HB.pkId = @pkid or @pkid=null or (HB.BookingReference=@bookingid and BookingReference!='') or @bookingid=null) and RiyaAgentID=@AgentId                                                                                             
                                                                                
  select isnull(AC.Text,'') as Text, isnull(AC.Description,'') as Description,isnull(AC.Amount,0) as Amount,isnull(AC.Currency,'') as Currency from hotel.AdditionalCharges as AC                      
  INNER JOIN Hotel_BookMaster HB ON AC.FkBookId=HB.pkId                                                                
  where (HB.pkId = @pkid or @pkid=null or (HB.BookingReference=@bookingid and BookingReference!='') or @bookingid=null)  and RiyaAgentID=@AgentId                                                     
                                                                           
END 