        
--[dbo].[Proc_GetDailyUnSuccessfulBookingReport]        
CREATE Procedure Proc_GetDailyUnSuccessfulBookingReport                  
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
 --left join B2BHotel_Commission BC on BC.Fk_BookId = hb.pkId           
 --left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1          
 --left join tblSelfBalance tbs on tbs.BookingRef = HB.orderId and tbs.UserID = HB.MainAgentID                                                     
 --left join tblAgentBalance tbla on tbla.BookingRef = HB.orderId  and  tbla.AgentNo = HB.RiyaAgentID                            
 --left join B2BMakepaymentCommission B2BMC on B2BMC.FkBookId=HB.pkId                          
 left join B2BRegistration B2B on B2B.FKUserID=HB.RiyaAgentID                          
 left join agentLogin AL on AL.UserID=B2B.FKUserID           
 left join mUser mu on mu.ID=HB.MainAgentID         
 --left join mAgentGroup MAG on MAG.Id=AL.GroupId                          
 --left join Hotel_BookingGSTDetails gst on gst.PKID=HB.pkId or gst.OrderId=HB.orderId                          
 --left join Hotel_AttributesData HA on HA.FKBookId=HB.pkId                    
where    
--AL.userTypeID=5  and B2B.EntityName='TATA CONSULTANCY SERVICES LIMITED' and   
HB.BookingPortal in('TNH','TNHAPI')                                     
  and HB.RiyaAgentID is not null                                                                                                                                                               
  --and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')         
  and (Convert(date,HH.CreateDate) >= Convert(date,getdate()))                    
           
END