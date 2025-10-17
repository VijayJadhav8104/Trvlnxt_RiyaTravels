CREATE PROCEDURE [dbo].[B2BHotel_SearchBookingsForCancellation]                                                                    
 -- Add the parameters for the stored procedure here                                                                    
 @Id int=null,                                                                                                                                
 @Action int=0,    
 @ModifiedBy int=0    
AS                                                                    
BEGIN                                                                    
                                                                    
 begin         
  if(@Action=1)         
select distinct                                                            
 HB.pkId,                                    
 case when HB.ExpirationDate<GETDATE()                       
 and SH.FkStatusId=3 THEN 1 ELSE 0 END As CancelExpeired,             
           
 case when  HB.RequestForCancelled is null then 'NO' else 'Yes' end as 'RequestForCancelled',          
                                                                  
  HB.BookingReference as book_Id                                               
   ,  HB.orderId as 'OrderID'                     
                                                    
                                                                       
   ,Case When HM.Status = 'Confirmed' Then '<span style="color:blue; ">Hold</span>'+' / '+   Case                                             
      when B2BPaymentMode=1 then '<span style="color:blue; ">Hold</span>'                                            
   when B2BPaymentMode=2 then '<span style="color:Black; ">Credit Limit</span>'                                            
   when  B2BPaymentMode=3 then '<span style="color:Black;">Make Payment</span>'                                            
   when  B2BPaymentMode=4 then '<span style="color:Black; ">Self Balalnce</span>'                                            
   else   ''                                  
   end                                            
                                               
   else HM.Status +' / '+ Case when B2BPaymentMode=1 then '<span style="color:blue;">Hold</span>'                                            
   when B2BPaymentMode=2 then '<span style="color:Black; ">Credit Limit</span>'                                            
   when  B2BPaymentMode=3 then '<span style="color:Black;">Make Payment</span>'                                            
   when  B2BPaymentMode=4 then '<span style="color:Black; ">Self Balance</span>'                                            
   else   'NA'                                            
   end                                                                  
   End as CurrentStatus                                                                                       
     ,BR.AgencyName + ISNULL(+'-'+mu.FullName,'') as 'AgencyName'                                               
   ,HB.cityName as Destination                                                         
   ,(HB.CurrencyCode +' '+ HB.DisplayDiscountRate ) as Amount                                                                    
   ,convert(varchar,HB.inserteddate, 0) as BookingDate                                                                      
                                                                   
   ,HB.CheckInDate as ServiceDate   --*                                                                    
                                                                    
   ,convert(varchar,CancellationDeadLine,0) as DeadlineDate                                                                        
   ,HB.SupplierName                                                                    
   ,HB.SupplierReferenceNo                                                 
  ,Case                                        
      when B2BPaymentMode=1 then '<span style="color:blue; font-weight:bold">Hold</span>'                                            
   when B2BPaymentMode=2 then '<span style="color:Black; font-weight:bold">Credit Limit</span>'                                            
   when  B2BPaymentMode=3 then '<span style="color:Black; font-weight:bold">Make Payment</span>'                                            
   when  B2BPaymentMode=4 then '<span style="color:Black; font-weight:bold">Self Balalnce</span>'                                            
   else   ''                    
   end as 'PaymentMode'                                            
   ,HB.LeaderTitle+' '+HB.LeaderFirstName+' '+HB.LeaderLastName  as 'TravellerName'                                                                    
                                                                     
   ,HB.BookingReference as   ConfirmationNumber   --*                                                                    
   ,HB.VoucherNumber as VoucherID                                                      
   ,HB.VoucherDate as VoucherDate                                                              
   ,HB.AgentRefNo as AgentReferenceNo                                                                    
                      
  ,HB.HotelConfNumber as HotelConfirmationAdded             
  ,HB.PayAtHotel as PayAtHotel            
                                                
   ,'' as LastModifiedDate                                                                    
   ,CancelDate as CancellationDate  --*                                                                    
,'' as 'Action',                                                                    
   HB.HotelName,                                                                   
case when (HB.ExpirationDate is null) then '2018-03-12 00:00:00.000' else HB.ExpirationDate End as ExpirationDate                           
---                        
, case ReconStatus when 'N' then 'Red' when 'Y' then 'LimeGreen' else 'Black' end as 'ReconStatus'                        
--                        
from Hotel_BookMaster HB  WITH (NOLOCK)                                                            
  left join mUser MU WITH (NOLOCK) on HB.MainAgentID=MU.ID                                                                  
                                                              
  left join Hotel_Pax_master HP WITH (NOLOCK) on HB.pkId=HP.book_fk_id                                                                     
  left join Hotel_Status_History SH WITH (NOLOCK) on HB.pkId=SH.FKHotelBookingId                                                             
  left join B2BRegistration BR WITH (NOLOCK) on HB.RiyaAgentID=BR.FKUserID                                                                     
  join AgentLogin AGL WITH (NOLOCK) on HB.RiyaAgentID=AGL.UserID                                                                                                                      
  left join Hotel_Status_Master HM WITH (NOLOCK) on SH.FkStatusId=HM.Id                                                                    
  left join  mBranch MB WITH (NOLOCK) on MB.BranchCode=BR.BranchCode                                                                     
 where                                                                     
                               
  HB.RequestForCancelled='Yes'          
 and SH.IsActive=1        
  and HB.BookingReference is not null                       
  order by pkId desc                                                                    
  end                                                             
         
         
   if(@Action=2)        
   begin        
   Update Hotel_BookMaster set RequestForCancelled='No' where pkId=@Id      
       
   begin      
  insert into Hotel_UpdatedHistory         
  (fkbookid,FieldName ,FieldValue,InsertedDate,UpdatedType,InsertedBy)        
  select @Id,'Canx reconcilled',@Id,GETDATE(),'Pending Cancellation Request',@ModifiedBy from Hotel_BookMaster where pkId = @Id            
      SELECT SCOPE_IDENTITY();                                  
      
   end     
    
        
   end        
END