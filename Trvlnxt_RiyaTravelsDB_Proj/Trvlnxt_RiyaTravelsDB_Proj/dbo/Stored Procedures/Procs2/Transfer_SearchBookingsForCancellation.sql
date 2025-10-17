  
  
  
--select * from Hotel_BookMaster where pkId=62895  
  
--update Hotel_BookMaster set RequestForCancelled='Yes' where pkId=62895  
  
      
      
      
        
                    
                    
create PROCEDURE [dbo].[Transfer_SearchBookingsForCancellation]                                                                  
 -- Add the parameters for the stored procedure here                                                                  
 @Id int=null,                                                                                                                              
 @Action int=0,  
 @ModifiedBy int=0  
AS                                                                  
BEGIN                                                                  
                                                                  
 begin       
  if(@Action=1)       
select distinct                                                          
 HB.BookingId,                                  
 case when HB.ExpirationDate<GETDATE()                     
 and SH.FkStatusId=3 THEN 1 ELSE 0 END As CancelExpeired,           
         
 case when  HB.RequestForCancelled is null then 'NO' else 'Yes' end as 'RequestForCancelled',        
                                                                
  HB.BookingRefId as book_Id                                             
   ,  HB.BookingRefId as 'OrderID'                   
                                                  
                                                                     
   , Case When HM.Status = 'Confirmed' Then '<span style="color:blue; ">Hold</span>'+' / '+                                                                                                                              
    Case when HB.PaymentMode=1 then '<span style="color:blue; ">Hold</span>'                                                                                      
   when HB.PaymentMode=2 then '<span style="color:Black; ">Credit Limit</span>'                                                                                                                     
   when  HB.PaymentMode=3 then '<span style="color:Black;">Make Payment</span>'                                                                                                                      
   when  HB.PaymentMode=4 then '<span style="color:Black; ">Self Balalnce</span>'                                                              
   else   ''                                                                                            
   end                                                          
                                                                                                                         
   else HM.Status +' / '+ Case when HB.PaymentMode=1 then '<span style="color:blue;">Hold</span>'                                                                                                                      
   when HB.PaymentMode=2 then '<span style="color:Black; ">Credit Limit</span>'                                                                                                                      
   when  HB.PaymentMode=3 then '<span style="color:Black;">Make Payment</span>'                                                                                                                      
   when  HB.PaymentMode=4 then '<span style="color:Black; ">Self Balance</span>'                                                                    
   --when  HB.PaymentMode=5 then '<span style="color:Black; ">PayAtHotel</span>'                                                                                                                     
   else   'NA'                                                                                                                      
   end                                                                                                                                            
   End as CurrentStatus                                                                                          
     ,BR.AgencyName + ISNULL(+'-'+mu.FullName,'') as 'AgencyName'                                             
   ,HB.cityName as Destination                                                       
   ,  ISNULL(HB.BookingCurrency + ' ' + CAST(HB.AmountBeforePgCommission AS VARCHAR), 'NA') AS Amount                                                                 
   ,convert(varchar,HB.creationDate, 0) as BookingDate                                                                    
                                                                 
   ,HB.TripStartDate as ServiceDate   --*                                                                  
                                                                  
   ,convert(varchar,CancellationDeadLine,0) as DeadlineDate                                                                      
   --,HB.SupplierName                                                                  
   --,HB.SupplierReferenceNo                                               
  ,Case                                      
      when HB.PaymentMode=1 then '<span style="color:blue; font-weight:bold">Hold</span>'                                          
   when HB.PaymentMode=2 then '<span style="color:Black; font-weight:bold">Credit Limit</span>'                                          
   when  HB.PaymentMode=3 then '<span style="color:Black; font-weight:bold">Make Payment</span>'                                          
   when  HB.PaymentMode=4 then '<span style="color:Black; font-weight:bold">Self Balalnce</span>'                                          
   else   ''                  
   end as 'PaymentMode'                                          
   ,HP.Titel+' '+HP.Name+' '+HP.Surname  as 'TravellerName'                                                                  
                                                                   
   ,HB.ProviderConfirmationNumber as   ConfirmationNumber   --*                                                                  
   --,HB.VoucherNumber as VoucherID                                                    
   --,HB.VoucherDate as VoucherDate                                                            
   ,HB.ProviderConfirmationNumber as AgentReferenceNo                                                                  
                    
  --,HB.HotelConfNumber as HotelConfirmationAdded           
  --,HB.PayAtHotel as PayAtHotel          
                                              
   ,'' as LastModifiedDate                                                                  
   ,HB.CancellationDate as CancellationDate  --*                                                                  
,'' as 'Action'                                                                  
  -- HB.HotelName,                                                                 
,case when (HB.ExpirationDate is null) then '2018-03-12 00:00:00.000' else HB.ExpirationDate End as ExpirationDate                         
---                      
--, case ReconStatus when 'N' then 'Red' when 'Y' then 'LimeGreen' else 'Black' end as 'ReconStatus'                      
--                      
from TR.TR_BookingMaster HB                                                           
  left join mUser MU on HB.MainAgentID=MU.ID                                                                                                                          
  --left join Hotel_Pax_master HP on HB.BookingId=HP.book_fk_id
  left join tr.TR_PaxDetails HP on HB.BookingId=HP.BookingId
  left join tr.TR_Status_History SH on HB.BookingId=SH.BookingId                                                           
  left join B2BRegistration BR on HB.AgentID=BR.FKUserID                                                                   
  join AgentLogin AGL on HB.AgentID=AGL.UserID                                                                                                                    
  left join Hotel_Status_Master HM on SH.FkStatusId=HM.Id                                                                  
  left join  mBranch MB on MB.BranchCode=BR.BranchCode                                                                   
 where                                                                   
                             
  HB.RequestForCancelled='Yes'        
 and SH.IsActive=1      
  and HB.BookingRefId is not null                     
  order by hb.BookingId desc                                                                  
  end                                                           
       
       
   if(@Action=2)      
   begin      
   Update TR.TR_BookingMaster set RequestForCancelled='No' where BookingId=@Id    
     
   begin    
  insert into tr.TR_bookingUpdate_History       
  (fkbookid,FieldName ,FieldValue,InsertedDate,UpdatedType,InsertedBy)      
  select @Id,'Canx reconcilled',@Id,GETDATE(),'Pending Cancellation Request',@ModifiedBy from TR.TR_BookingMaster where  BookingId= @Id          
      SELECT SCOPE_IDENTITY();                                
    
   end   
  
      
   end      
END 

--select * from tr.TR_bookingUpdate_History