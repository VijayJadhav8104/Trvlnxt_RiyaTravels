--[dbo].[Proc_GetDailyRBTUnSuccessfulBookingReport]                 
CREATE Procedure Proc_GetDailyRBTUnSuccessfulBookingReport                
                 
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
   ISNULL(HB.failurereason,'') as BookingFailReason
    FROM                   
 Hotel_BookMaster HB WITH (NOLOCK)                               
 join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and  HH.FkStatusId in (5,9,10,11,13)  and IsActive=1                        
 join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                                                                                                                                                                               
 left join B2BRegistration B2B on B2B.FKUserID=HB.RiyaAgentID                              
 left join agentLogin AL on AL.UserID=B2B.FKUserID          
 left join mUser MU on MU.ID=HB.MainAgentID                              
where  AL.userTypeID=5  and (B2B.EntityName='HCL TECHNOLOGIES LIMITED' or B2B.EntityName='TATA CONSULTANCY SERVICES LIMITED')                                                                
  and HB.BookingPortal in('TNH','TNHAPI')                                         
  and HB.RiyaAgentID is not null                                                     
  and (Convert(date,HH.CreateDate) >= Convert(date,getdate()))                       
               
END