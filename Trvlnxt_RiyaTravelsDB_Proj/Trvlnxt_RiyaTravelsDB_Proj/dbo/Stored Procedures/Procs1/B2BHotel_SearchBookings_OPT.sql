CREATE PROCEDURE [dbo].[B2BHotel_SearchBookings_OPT]       
      
@Id int=0,      
@Consultant nvarchar(200)='',                                       
 @Branch nvarchar(200)='',                                       
 @Agent nvarchar(200)='',                       
 @TravelerName nvarchar(200)='',                        
@ServiceFromDate varchar(50)='',                      
@ServiceToDate varchar(50)='',                        
@BookingID nvarchar(max)='',                               
@BookingStatus  nvarchar(200)='',                        
@SupplierRefNo nvarchar(200)='',                                            
 @Supplier nvarchar(200)='',                                                                                                        
 @BookingFromDate varchar(50)='',                                                                            
 @BookingToDate varchar(50)='',                                                     
 @VoucherFromDate varchar(50)='',                                                                          
 @VoucherToDate varchar(50)='',                                                                                           
 @AgentReferenceNo nvarchar(200)='',                                                                                           
 @StatusFromDate varchar(50)='',                                                                        
 @StatusToDate varchar(50)='',                                                                                                                    
 @VoucherID nvarchar(200)='',                                                              
 @ConfirmationNumber nvarchar(200)='',                                                                                                
 @ModifiedFromDate varchar(50)='',                                                                                                    
 @ModifiedToDate varchar(50)='',                                                                                                                                                                     
 @CancellationFromDate varchar(50)='',      
 @CancellationToDate varchar(50)='',                                                                                                                                                                              
 @Country nvarchar(200)='',               
 @City nvarchar(200)='',                          
 @ExcelFlag varchar(50)='' ,                                          
 @PaymentMode varchar(50)='',                                                                                                                                                                                                
 @OBTC  varchar(50)='',                                                                                                                                                          
 @payathotel varchar(50)=null,                                                                          
 @CheckoutDateFrom varchar(50)='',                       
 @CheckoutDateTo varchar(50)=''                                                                       
                                                                          
AS                                                                                                                                                                                                                              
BEGIN  
if(@BookingFromDate='' AND @BookingToDate='')                                                                                                                                                                                           
begin                                                                                                                                                                                               
                                                                                                                                                                                              
set @BookingFromDate='01/06/2024'                                                                                                                                                                                              
set @BookingToDate=GETDATE()                                           
                                                    
end                                                                      
                                                                                            
   If(@ExcelFlag='Gride' or @ExcelFlag='')                                                                                                                         
 begin                                                
     ;WITH PaymentStatus  AS (
    SELECT 
        pkId,
        CASE 
            WHEN B2BPaymentMode = 1 THEN 'Hold'
            WHEN B2BPaymentMode = 2 THEN 'Credit Limit'
            WHEN B2BPaymentMode = 3 THEN 'Make Payment'
            WHEN B2BPaymentMode = 4 THEN 'Self Balance'
            ELSE 'NA'
        END AS PaymentMode
    FROM Hotel_BookMaster	
)
SELECT TOP 400  
    HB.pkId, 
    HB.BookingReference AS book_Id,
    HB.orderId AS OrderID,
    HM.Status + ' / ' + PaymentMode AS CurrentStatus,           



   -- BR.AgencyName + ISNULL(+'-'+mu.FullName,'') end as 'AgencyName'               
       case when HB.B2BPaymentMode=4 and HB.SuBMainAgentID!=0 then           
    BR.AgencyName + ISNULL(+'-'+mu.FullName,'') + ' '+ '('+ Mus.FullName + ')'          
    else  BR.AgencyName + ISNULL(+'-'+mu.FullName,'') end as 'AgencyName'                                                                                                         
                                                                                                                                            
   ,HB.cityName as Destination                                                                                                                     
  --, CASE                                                                                                                                
  --WHEN SH.MethodName= 'Manually_OfflineCancel' or SH.MethodName= 'H' or SH.MethodName='HotelBookingCancel' or SH.MethodName='Manually Updated'  and SH.IsActive=1  THEN  CONCAT(HB.CurrencyCode,' ',Convert(nvarchar,isnull(HB.agentCancellationCharges,0)))  
                              
  --  ELSE (HB.CurrencyCode +' '+ HB.DisplayDiscountRate )                                                                                                                                                                                        
  --  END AS Amount                                                                                                                                                                                  
                                                  
,CASE  
    WHEN SH.MethodName IN ('Manually_OfflineCancel', 'H', 'HotelBookingCancel', 'Manually Updated')  
         AND SH.IsActive = 1  
    THEN HB.CurrencyCode + ' ' + FORMAT(COALESCE(HB.agentCancellationCharges, 0), 'N2')  
    ELSE HB.CurrencyCode + ' ' + FORMAT(CAST(HB.DisplayDiscountRate AS DECIMAL(18,2)), 'N2')  
END AS Amount
                                                                           
                                                            
 ,convert(varchar,HB.inserteddate, 0) as BookingDate                                                                                                                                                                                 
                                                                                        
 -- ,HB.CheckInDate as ServiceDate                                                                                 
 --,convert(varchar,HB.CheckInDate,105)+' '+HB.CheckInTime as ServiceDate                                                                                 
 --,FORMAT(HB.CheckInDate,'MMM dd yyyy')+' '+HB.CheckInTime as ServiceDate                                                              
,CASE                              
    WHEN hb.ServiceTimeModified = 1 THEN                                                       
        FORMAT(HB.CheckInDate, 'MMM dd yyyy') + ' ' + SUBSTRING(HB.ModifiedCheckInTime, 1, 8)               
    ELSE                                                                     
        FORMAT(HB.CheckInDate,'MMM dd yyyy')+' '+ HB.CheckInTime                                                                    
END AS ServiceDate                              
                                                                                                                                                                                             
 ,convert(varchar,CancellationDeadLine,0) as DeadlineDate                                                                                                         
   --, case when lower(HB.SupplierName)='agodaint' then 'Agoda' else HB.SupplierName end as SupplierName    commneted as suggested by faizan sir and prity                                                                         
                                          
  , SM.SupplierName as SupplierName                                                                                      
                                                                                  
   , case when (HB.providerConfirmationNumber='' or HB.providerConfirmationNumber is null) then HB.SupplierReferenceNo else HB.providerConfirmationNumber end as 'SupplierReferenceNo'          -- add column on 11-04-23                                     
                                                                                         
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
  ,HB.HotelConfNumber as HotelConfirmationAdded ,                                                                                                        
  HB.PayAtHotel as PayAtHotel                                                                                                                                                           
                                 
   ,'' as LastModifiedDate                                                                                                                                                        
                                                                                    
   ,CancelDate as CancellationDate  --*                                                                                                                                                                        
                                                        
,'' as 'Action',                                                                                                                          
   HB.HotelName,                                                                                                                            
case when (HB.ExpirationDate is null) then ( cast('2024-06-01 17:41:00.000' as date)) else HB.ExpirationDate End as ExpirationDate                                                                             
---                                                                                     
,case hb.ReconStatus when 'Y'then 'YELLOWGREEN' WHEN 'N' THEN 'RED'ELSE  'Black' END as 'ReconStatus'                                                                  
--                                                                                    
from Hotel_BookMaster HB  WITH (NOLOCK)                                                                                                                                                 
  left join mUser MU WITH (NOLOCK) on HB.MainAgentID=MU.ID           
  left join mUser MUS WITH (NOLOCK) on HB.SuBMainAgentID=MUS.ID and HB.SuBMainAgentID!=0                                                                                          
 -- left join Hotel_Pax_master HP WITH (NOLOCK) on HB.pkId=HP.book_fk_id                                                                                                                           
  left join Hotel_Status_History SH WITH (NOLOCK) on HB.pkId=SH.FKHotelBookingId                                                                                                                                                                    
  left join B2BRegistration BR WITH (NOLOCK) on  HB.RiyaAgentID=BR.FKUserID                                                                                                                                   
  join AgentLogin AGL WITH (NOLOCK) on HB.RiyaAgentID=AGL.UserID                                                                                                                                                            
  --left join Hotel_Status_History HSH on HB.book_Id=HSH.FKHotelBookingId                                                                                                                               
  left join Hotel_Status_Master HM WITH (NOLOCK) on SH.FkStatusId=HM.Id                                                                                                                                                      
  left join  mBranch MB WITH (NOLOCK) on MB.BranchCode=BR.BranchCode                    
  Left Join Hotel_UpdatedHistory HH WITH (NOLOCK) on HB.pkId=HH.fkbookid                                                                            
  --LEFT join Hotel_Room_master RM WITH (NOLOCK) on HP.room_fk_id=RM.Room_Id                                                   
  LEFT join B2BHotelSupplierMaster SM WITH (NOLOCK) on HB.SupplierPkId=SM.Id               
                                                                                                   
 where                                                                                                                   
                                  
   ( ( @Consultant ='') or (HB.MainAgentID IN  (select Data from sample_split(@Consultant,','))) )                   
                                                  
  and( ( @Branch ='') or (BR.BranchCode IN  (select Data from sample_split(@Branch,','))) )                                                                                                                                     
    and( (@Agent ='') or (HB.RiyaAgentID IN  (select Data from sample_split(@Agent,','))) )                                        
 and(HB.LeaderTitle+' '+HB.LeaderFirstName like '%'+@TravelerName+'%'  or @TravelerName ='')                                                                                                                                                                  
       
 and( (@BookingID ='') or (HB.BookingReference IN  (select Data from sample_split(@BookingID,','))) )                                                                                                            
                                                                                                                                                                                                                              
   and( (@BookingStatus ='') or (SH.FkStatusId IN  (select Data from sample_split(@BookingStatus,','))) )                                                                                                                                            
                                                                                   
   and(HB.SupplierReferenceNo = @SupplierRefNo or @SupplierRefNo='')                                                                                                                                     
                                                                                                                                                                                                                                          
                                                    --and(HB.SupplierName =@Supplier  or @Supplier ='')                                                                                                   
    --  and( (@Supplier ='') or (HB.SupplierPkId IN  (Select Id from B2BHotelSupplierMaster where HB.SupplierUsername in( select Data from sample_split(@Supplier,',')))))  changes done filter on working                                                     
                 
    and( (@Supplier ='') or (HB.SupplierPkId IN  ( select Data from sample_split(@Supplier,','))))                                                                                                                                                             
           
   and(HB.riyaPNR = @AgentReferenceNo or @AgentReferenceNo='')  
   and(HB.VoucherNumber = @VoucherID   or @VoucherID='')                                                           
                            
   --and(HB.CountryName like '%'+@Country+'%'   or @Country='')                                                         
   and( (@Country ='') or (HB.CountryName IN  (select cast(Data as varchar) from sample_split(@Country,','))) ) --commented by sana                                                                              
                                                               
   --and( (@Country ='') or (HB.BookingCountryPkid IN  (select cast(Data as varchar) from sample_split(@Country,','))) )                                                                   
                                                          
   --and(HB.cityName like '%'+@City+'%'   or @City='')                                                                                                                                                                                                         
  
           
                           
   and( (@City ='') or (HB.cityName IN  (select cast(Data as varchar) from sample_split(@City,','))))                                                                                           
                                                   
   --and (                                                                                                                                               
   --  (@ConfirmationNumber = '1' and isnull(HotelConfNumber,'') != '')       
   --  OR                                                                                                                                                                         
   --  (@ConfirmationNumber = '0' and isnull(HotelConfNumber,'') = '')                                                                                                                                     
   --  OR                                                                                                        
   --  (@ConfirmationNumber = '')                                                                                                                                                                                                
   --)                                  
                                   
   and (                                                                       
     (@ConfirmationNumber = '1' and isnull(HotelConfNumber,'') != '')                                                                                                         
     OR                                                                       
     (@ConfirmationNumber = '0' and isnull(HotelConfNumber,'') = '')                                                                                                                      
     OR                                               
  (@ConfirmationNumber='ReconfirmYes' and HB.PassengerDetailsReconfirmationRemark is not null)                                              
  OR                                              
  (@ConfirmationNumber='ReconfirmNo' and  isnull(HotelConfNumber,'') != '')                                            
  OR                                              
     (@ConfirmationNumber = '')                                                                                                       
   )                                
                                                                                                             
   and (Convert(varchar(12),HB.CheckInDate,102) between Convert(varchar(12),Convert(datetime,@ServiceFromDate,103),102) and                                                                                         
  case when @ServiceToDate <> '' then Convert(varchar(12),Convert(datetime,@ServiceToDate,103),102)else Convert(varchar(12),Convert(datetime,@ServiceFromDate,103),102) end or (@ServiceFromDate='' and @ServiceToDate=''))                                    
  and (Convert(varchar(12),HB.inserteddate,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                                                          
                                          
                                                           
case when @BookingToDate <> '' then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate=''))                                      
                                                                     
  and (Convert(varchar(12),HB.VoucherDate,102) between Convert(varchar(12),Convert(datetime,@VoucherFromDate,103),102) and                                                                                  
                                                                                                                    
                                                                                                                      
   case when @VoucherToDate <> '' then Convert(varchar(12),Convert(datetime,@VoucherToDate,103),102)else Convert(varchar(12),Convert(datetime,@VoucherFromDate,103),102) end or (@VoucherFromDate='' and @VoucherToDate=''))                           
                               
    and (Convert(varchar(12),SH.CreateDate,102) between Convert(varchar(12),Convert(datetime,@StatusFromDate,103),102) and                                                                                                               
  case when @StatusToDate <> '' then Convert(varchar(12),Convert(datetime, @StatusToDate,103),102)else Convert(varchar(12),Convert(datetime,@StatusFromDate,103),102) end or (@StatusFromDate='' and @StatusToDate=''))                                        
                                 
  and (Convert(varchar(12),SH.ModifiedDate,102) between Convert(varchar(12),Convert(datetime,@ModifiedFromDate,103),102) and                                                                                                                                   
                                     
  case when @ModifiedToDate <> '' then Convert(varchar(12),Convert(datetime, @ModifiedToDate,103),102)else Convert(varchar(12),Convert(datetime,@ModifiedFromDate,103),102) end or (@ModifiedFromDate='' and @ModifiedToDate=''))                              
                                        
--and (Convert(varchar(12),hb.CancellationDeadLine,102) between Convert(varchar(12),Convert(datetime,@CancellationFromDate,103),102) and                                                                                                                       
                              
  --case when @CancellationToDate <> '' then Convert(varchar(12),Convert(datetime, @CancellationToDate,103),102)else Convert(varchar(12),Convert(datetime,@CancellationToDate,103),102) end or (@CancellationFromDate='' and @CancellationToDate=''))          
  
                   
                                 
-- BELOW OLD QUERY                                                                                                             
     --Hold Condition                                                                                                                                                               
                                                                                
                                                                                                                                                
    and   (CONVERT(datetime, isnull(ExpirationDate,Convert(Datetime,'2024-01-01 00:00:00.000')),3)between  CONVERT(datetime, COALESCE(@CancellationFromDate, Convert(Datetime,'2023-01-01 00:00:00.000')), 103) and   CONVERT(datetime, @CancellationToDate ,3 
  
                                     
)                                                          
  or (@CancellationFromDate='' and @CancellationToDate='')                                                                                                                        
  )                                                                           
                                                                                                        
    --Hold Condition                                               
                                            
   --checkout date filter                                                  
 and (Convert(varchar(12),HB.CheckOutDate,102) between Convert(varchar(12),Convert(datetime,@CheckoutDateFrom,103),102) and                              
case when @CheckoutDateTo <> '' then Convert(varchar(12),Convert(datetime,@CheckoutDateTo,103),102)else Convert(varchar(12),Convert(datetime,@CheckoutDateFrom,103),102) end or (@CheckoutDateFrom='' and @CheckoutDateTo=''))              
                              
                                                                                                                                         
  and ( ( @PaymentMode ='') or (HB.B2BPaymentMode IN  (select Data from sample_split(@PaymentMode,','))) )                                                                                                         
   and ((@OBTC='') or((@OBTC='With  OBTC' and HB.OBTCNo is not null) OR (@OBTC='Without  OBTC' and HB.OBTCNo is null) or (@OBTC='-- Select --')))                                                                                                              
 
   and MB.Division  like 'RTT%' and MB.BranchCode like 'BR%'                                                                                                                              
--and book_Id is not null                                                                                                                                                                                                    
   and SH.IsActive=1                                               
   and HB.RiyaAgentID is not null                                                                                                                                     
   and HB.B2BPaymentMode is not null                                                                                                                                                            
   --and HB.BookingReference is not null                                                                                          
  order by  HB.pkId desc                                                            
  end                                                                                                                         
                                                                                                                                                
 if(@ExcelFlag='Excel')                                                                                                                                                         
 begin                                                                                                                  
                                                                                                                         
 select distinct                                                                                                                                                            
    HB.pkId                                                                                                                
                                                                    
    ,'Hotel' as [Service]                                                             
    ,mcn.Value as 'UserType'                                                                                        
                   
 --,case when HB.MainAgentID!=0 and BR.Internal_Agency_Type=1  then  'Internal'  --add column on 13-04-23                                                     
 --when HB.MainAgentID =0 and BR.Internal_Agency_Type=1  then  'Internal'                                                                                        
 --when HB.MainAgentID!=0 and BR.Internal_Agency_Type=2  then 'Inter Company'                                      
 --when HB.MainAgentID =0 and BR.Internal_Agency_Type=2  then 'Inter Company'                                                
 -- when BR.country in ('CANADA','USA') or mybranch.Name like '%Dubai%' then 'Inter Company'                                                                        
 -- when Hb.B2BPaymentMode=5 then 'Inter Company'                                                                        
 -- when HB.MainAgentID=0 then  'Agent'                              
 --  else 'Agent'                                                                                              
 --  end as 'Customer Type'  --- This logic change on 10 jan 24 after prity mail.                                     
                    
 ,isnull(Br.EntityType,'NA') as 'Customer Type'                
                                                                        
    
  ,  Isnull(BR.EntityName,'NA')  as  'Customer Name'    
  
  
    ,HB.BookingReference as [Booking Id]                                                                                                                           
   -- ,mybranch.Name as Branch                                                                                                                            
   --,al.city as 'Branch'          
   ,case when BR.country='India' then  mybranch.[Name] else mbs.[Name] end AS Branch        
  ,BR.AgencyName as 'Agency  User'                                                                                      
  --,Br.Icast as 'Agent ID'    
   , CASE   
    WHEN br.country LIKE '%INDIA%'   
         AND ISNULL(LTRIM(RTRIM(BR.BillingID)), '') <> ''   
    THEN ISNULL(Br.Icast, 'NA') +' ' + ' /' +' ' + BR.BillingID   
    ELSE ISNULL(Br.Icast, 'NA')   
END AS 'Agent ID'  
            
          
  --,Case                                                                                      
  --  when HB.MainAgentID=0 then BR.AgencyName else Mu.FullName                                                                                                                
  -- end  as 'User Name'                 
   ,case when HB.B2BPaymentMode=4 and HB.SuBMainAgentID!=0 then           
     ISNULL(mu.FullName,'') + ' '+ '('+ Mus.FullName + ')'          
     when HB.MainAgentID=0 then BR.AgencyName                
    else  Mu.FullName end as 'User Name'                   
              
   ,HB.LeaderTitle+' '+HB.LeaderFirstName+' '+HB.LeaderLastName  as 'Leader Guest Name'                                                                                                                                                                       
  
             
                       
   ,FORMAT(CAST(HB.inserteddate AS datetime) , 'dd-MM-yyyy HH:mm') as  [Booking Date]                                                        
            ,format(cast(HB.CheckInDate as datetime),'dd-MM-yyyy ') as 'CheckIn Date'       -- add format of date on 24-4-23                                                                                                                                
                                                                                                                            
          --,FORMAT(CONCAT(CONVERT(datetime, HB.CheckInDate), ' ', HB.CheckInTime), 'dd-MM-yyyy HH:mm') AS 'CheckIn Date'                                                        
   -- ,FORMAT(CONVERT(datetime, HB.CheckInDate + ' ' + HB.CheckInTime), 'dd-MM-yyyy HH:mm') AS 'CheckIn Date'                     
                                                                                
                                                                                      
   ,format(cast(HB.CheckOutDate  as datetime),'dd-MM-yyyy') as 'Checkout Date'                                                                                                                        
   ,convert(varchar,CancellationDeadLine,0) as 'Cancellation Deadline'                                     
  ,Case When HM.Status = 'Confirmed' Then 'Hold'  WHEN HM.Status=NULL THEN 'NA' else HM.Status                             
                             
    End as 'Booking Status'                                                                                                                           
 ,Case                           
  when HB.B2BPaymentMode=1 then 'Hold'                                                                              
  when HB.B2BPaymentMode=2 then 'Credit Limit'                                                                                                                                                                    
  when HB.B2BPaymentMode=3 then 'Make Payment'                                                                                                                  
  when HB.B2BPaymentMode=4 then 'Self Balance'                                                                                                                                                             
  when HB.B2BPaymentMode=5 then 'PayAtHotel'                                                                                                                                                                        
  else 'NA'                                                                                                                        
  ENd as 'Mode Of Payment'                                                                                                                                                          
    ,HB.CurrencyCode as 'Booking Currency'                                                                                                                                                                                              
 -- ,HB.DisplayDiscountRate  as  'Booking Amount'                                                       
 ,TRY_CAST(HB.DisplayDiscountRate AS decimal(18, 4)) AS 'Booking Amount'  --as per suggested by priti on 17jun24                                                    
  ,HCC.EarningAmount as 'Agent Discount(Less TDS)'     --change column value as discussed with priti mam on 24-4-23                                                                                                                                  
              --remove hcc.tdsdeductedamount on 6-7-23 as discussed                                                                                                                             
 , HB.HotelDiscount as 'Hotel Discount'                                                                                    
 --,HB.TotalServiceCharges as 'Service Charges(including GST)'                                                                                                                            
 ,concat(HB.TotalServiceCharges, ' ','(', HB.GstAmountOnServiceChagres ,')') as 'Service Charges(including GST)'                                                                                                                                              
  
     
     
        
          
             
              
                 
 ,HB.MarkupAmount as 'Markup'     --add column on 31-8-23                                        
 ,case when hb.currencycode='INR' then hb.DisplayDiscountRate else (isnull(hb.DisplayDiscountRate,0) * isnull(hb.FinalROE,1)) end as 'selling rate in INR'                                                                                 
                                                   
  ,case when (HB.providerConfirmationNumber='' or HB.providerConfirmationNumber is null)                                            
  then HB.SupplierReferenceNo else HB.providerConfirmationNumber end as 'Supplier Ref. No'          -- add column on 11-04-23                                                                                                                                 
 
                                                                              
 ,SM.SupplierName  as 'Supplier'                                                                                   
 ,HB.SupplierCurrencyCode as 'Supplier Currency'                       
 ,HB.SupplierRate as 'Supplier Gross (Base currency)'                            
 --,isnull(HB.SupplierRate,0) * isnull(HB.SupplierINRROEValue,0) as 'Supplier Rate(INR)'           --add column on 18-8-23                                                                     
                                                                              
 --,hcc.SupplierCommission as 'Supplier Commission (Base Currency)'     commentd on 10-8-23                                                                                                                                                                    
  
   
       
        
          
           
             
 ,ISnull(HB.SINRCommissionAmount,0) as 'Supplier Commission (Base Currency)'    --add on 10-8-23                                                        
 ,isnull(HB.ROEValue,0) as 'Sell ROE'    --Commented on 7-8-23                                                                                                                                                                                    
 --,case when HB.SupplierCurrencyCode='INR' then 1 else HB.ROEValue end as 'Supplier ROE'                                                                                                                                                                      
  
    
      
        
          
 --,isnull(HB.STotalRate,0) * ISNULL(HB.ROEValue,1) as 'Supplier Net (INR)'       --commented on 10-8-23                                                                                                                                                       
  
    
      
        
          
            
              
                       
 ,(isnull(HB.SupplierRate,0)-ISNULL(HB.SINRCommissionAmount,0))*HB.ROEValue  as 'Sell Net'    --commented on 10-8-23                                                                                                                                           
  
    
     
 ,isnull(HB.SupplierINRROEValue,0) as 'Supplier BuyRoE'                                                                                                                                                                      
 ,isnull(HB.SupplierRate,0) * isnull(HB.SupplierINRROEValue,0) as 'BuyINR'                                                                     
 ,isnull(HB.SupplierCharges,0) as 'Supplier Service Charges'                                                                                                                                                                                              
 ,isnull(HB.VccValue,0) as 'VCC Bank Charges'                                                                                                                                 
 ,HCCD.CardType as 'VCC Card Type'                                                
 ,isnull(HB.SINRCommissionAmount,0) as 'Supplier Commission Net (INR)'                                                                                                                                                                                         
  
    
     
 ,isnull(HCC.EarningAmount,0) as 'Agent Part comm (INR)'                                                
 ,cast(ISNULL(HB.HotelTDS,0) as varchar) +'( '+ cast( isnull(HCC.TDS,0) as varchar)+'%)'  as 'TDS on Agent Comm'                                                                                                                                              
   
    
      
        
       
            
              
                                          
 ,'' as 'Riya Revenue'                                                                                          
                                                                    
 ,Cast(Isnull(MP.TotalCommission,0) as Varchar) +' ' +'('+Cast (ISnull (MP.ConvenienFeeInPercent,0.00) as varchar)+'%)' as 'PG Charges'                                                                                     
 ,MP.ModeOfPayment as ' PG Confirmation No / PG Type'                                                                                                                 
 --,Cast(Isnull(@totalcommission,0.00) as Varchar) +' ' +'('+Cast (ISnull (@convienfee,0.00) as varchar)+'%)' as 'PG Charges'                                                                                                                                  
  
    
      
        
          
            
                     
                                          
 --,@makepayment as ' PG Confirmation No / PG Type'                                               
                                                          
                                                
   ,HB.cityName as 'City'                                                                                 
 --  ,Case  when CHARINDEX(',',CountryName) >0  THEN right(CountryName, charindex(',', reverse(CountryName)) - 1)                                                                                                  
                                                                    
                                                                                         
 --else CountryName end  as 'Country'    --add on 01-9-23                                                     
                                                                                                                                                                
,HB.CountryName as 'Country'                                                                                                                
                                                                                               
 -- ,Case  when CHARINDEX(',',cityName) >0  THEN right(cityName, charindex(',', reverse(cityName)) - 1)                                                                                                                                      
 --else 'NA' end  as 'Country'   --commented on 01-9-23                                                                                                                                                                                               
 ,HB.HotelName as 'Hotel Name'                                                                       
 ,(convert(int, isnull(TotalAdults,'0'))+convert(int, isnull(TotalChildren,'0')))  as 'No. of Passengers'                                                                                                             
  ,HB.SelectedNights as 'No. of Nights'                                                                                                                                                                          
  ,TotalRooms as 'No. of Rooms'                                                        
 ,(Cast( isnull (HB.SelectedNights, 1 )as int) * Cast( isnull (HB.TotalRooms, 1 )as int)) as 'Total Room Nights'                                                                                                                         
 ,ISNULL(HB.OBTCNo,'NA') as 'Old OBTC No'                          
 ,isnull(HB.MBPageOBTCNo,'NA') AS 'OBTC NO'                                
 --,HB.HotelConfNumber as 'Hotel Confirmation'                                                                                                                                                                                              
 --,HB.ConfirmationDate  as 'Date of confirmation'                                    
                                   
  ,HB.HotelConfNumber as 'Hotel Confirmation'                                            
 ,HB.ConfirmationDate  as 'Date of confirmation'                               
 ,  isnull(mcc.FullName,'NA')   as 'Confirmed by'                                 
                                  
 ,isnull(HP.Pancard,'NA') as 'PAN Card No'                                                              
 ,isnull(HP.PanCardName,'NA') as 'PanCard Name'                                                                                                                                                         
 ,ISnull(REPLACE(HB.PanCardURL, '/Documents/PancardDocument/', 'https://trvlnxt.com/newhotel/Documents/PancardDocument/'),'NA') AS Declaration                                            
 --,ISNULL(HB.PanCardURL,' ') as 'Declaration'                     
 ,HB.Nationalty as 'Nationality'                                                                                                              
 ,HP.PassportNum  as 'Passport No'                                                                                                    
 ,HP.IssueDate as 'Date of Issue'                                                                     
 ,HP.PassPortDOB as 'Date of Birth'                                                                                                        
 ,HP.Expirydate as 'Date of Expire'                                                                                                                                    
 ,HBGD.GstNumber as 'GST Number'                                                                                                
                                                                                                                                                
 ,'' as 'Undertaking Doclink'                                                                                     
                                                                                                                                                                  
 ,Case when HB.BookingReference like '%TNHAPI%'  then ' '                                                                                               
 when HB.B2BPaymentMode<>5 then ' '                                                                                       
 when HB.B2BPaymentMode=5 and  HB.orderId=tba.BookingRef then 'Received' else 'Pending'                                                                                                                                          
 end as 'Pay@hotel Commission Status'       --add join on 8-8-23                                                                                                                                                     
 ,HCC.[Actual Commission Received] as 'Pay@hotel Commission Received'                                                                                                       
 ,HCC.EarningAmount as 'Pay@hotel Commission Paid'    --add join on 8-8-23                                                                                                           
   ,HB.SupplierBookingUrl as 'Agoda URL'                                                                                                                                                             
  ,HB.SupplierBookingPaymentDate as 'BNPL DeadLine Date'                                                                                                                                                                  
                          
 ------ for report of Cancellation type ---                                                                                                                                                    
  ,ISnull(HB.SupplierCancellationCharges,0)  as 'Supplier Cancellation Amount'                                                       
  ,ISNULL(HB.agentCancellationCharges,0)  as 'Agent Cancellation Amount'                                    
  ,    ISNULL(CONVERT(varchar, HB.CancellationDate, 120), '-') AS 'Cancellation Date'                                                                                                                                                        
                                                                                                                                                        
,CASE                                                                                                                                                 
    WHEN HB.CancelledBy IS NULL THEN CONVERT(varchar(20), '-')                                                                            
    WHEN HB.CancelledBy != 0  THEN CONVERT(varchar(40), Mu.FullName)                                                              
    ELSE  Br.AgencyName                                                                                    
END AS Cancelled_By                                                                                                                                       
                                                                        
                                                                                                
                                                                                      
,ISNULL(HB.ModeOfCancellation,'-')    as   'Mode Of Cancellation'                                    
,HB.PaymentStatus as 'Payment Status'                                                                                                                                
,HB.PaymentRemark  as 'Payment Remark'                                                                       
                                                                      
,case when SH.FkStatusId=4 and prevSH.FkStatusId=3 then FORMAT(cast(SH.CreateDate as datetime),'dd-MMM-yyyy HH:mm:ss') else '' end AS 'Voucher Date'                                                 
                                                                        
 ,hb.DispositionStatus as 'Disposition Status'                                                                    
 ,hb.ResolutionStatus as 'Resolution Status'                                                                    
 ,Floor(HB.HotelRating)  as 'Hotel Star Category'                                  
                               
  ,case when HB.PassengerConfirmation='false'  then 'Not Verified'  when HB.PassengerConfirmation='true'  then 'Verified'                                      
       when HB.ConfByEmailConfirmation='true' then 'Others' else HB.PassengerConfirmation end as 'Passenger Confirmation'                                      
                                      
 ,case when HB.MealPlanConfirmation='false'  then 'Not Verified'  when HB.MealPlanConfirmation='true'  then 'Verified'                                      
       when HB.MealPlanConfirmation='true' then 'Others' else HB.MealPlanConfirmation end as 'MealPlan Confirmation'                                      
                                      
 ,case when HB.RoomTypeConfirmation='false'  then 'Not Verified'  when HB.RoomTypeConfirmation='true'  then 'Verified'                                      
       when HB.RoomTypeConfirmation='true' then 'Others' else HB.RoomTypeConfirmation end as 'Room Type Confirmation'               
                  
                                      
 ,case when HB.PaymentConfirmation='false'  then 'Not Verified'  when HB.PaymentConfirmation='true'  then 'Verified'                                      
       when HB.PaymentConfirmation='true' then 'Others' else HB.PaymentConfirmation end as 'Payment Confirmation'                  
                  
     ,case when HB.ExtrabedConfirmation='false'  then 'Not Verified'  when HB.ExtrabedConfirmation='true'  then 'Verified'                                      
       when HB.ExtrabedConfirmation='true' then 'Others' else HB.ExtrabedConfirmation end as 'Extra Bed Confirmation'               
                  
   ,case when HB.ConfByEmailConfirmation='1'  then 'Verified'  when   HB.ConfByEmailConfirmation='0' then 'Not Verified' else ''  end as 'Emails Confirmation'                                                             
  , HB.PassengerDetailsReconfirmationRemark  as 'Reconfirmation Remark'                
                
,case when HU.UpdatedType='Passenger Details ReConfirmation' then HU.InsertedDate  end as 'Date of Reconfirmation'              
              
 , mreconfirm.FullName  as 'ReconfirmedBy'                     
               
 ,br.SalesPersonName as 'Sales person'                   
               
              
   from Hotel_BookMaster HB  WITH (NOLOCK)                                              
 left join mUser MU WITH (NOLOCK) on MU.ID=HB.MainAgentID          
 left join mUser MUS WITH (NOLOCK) on HB.SuBMainAgentID=MUS.ID and HB.SuBMainAgentID!=0           
 left join Hotel_Pax_master HP WITH (NOLOCK) on HB.pkId=HP.book_fk_id    and IsLeadPax=1                         
 left join Hotel_Status_History SH WITH (NOLOCK) on HB.pkId=SH.FKHotelBookingId                                                                       
 LEFT JOIN  Hotel_Status_History prevSH WITH (NOLOCK) ON HB.pkId = prevSH.FKHotelBookingId AND prevSH.CreateDate < SH.CreateDate  and prevSH.FkStatusId=3                
 left join B2BRegistration BR WITH (NOLOCK) on HB.RiyaAgentID=BR.FKUserID                                        
 join AgentLogin AGL WITH (NOLOCK) on HB.RiyaAgentID=AGL.UserID                     
 left join agentLogin al WITH (NOLOCK) ON BR.FKUserID=al.UserID                    
   --left join B2BMakepaymentCommission MP WITH (NOLOCK) on HB.pkId=MP.FkBookId and ProductType='Hotel'                                      
   left join B2BMakepaymentCommission MP WITH (NOLOCK) on MP.Id=(select max(id) from B2BMakepaymentCommission where FkBookId=HB.pkId and ProductType='Hotel')                                    
   left join Hotel_Status_Master HM WITH (NOLOCK) on SH.FkStatusId=HM.Id                                           
   left join B2BHotelSupplierMaster SM WITH (NOLOCK) on HB.SupplierPkId=SM.Id                                                                                  
                                                                                                                                        
 --  left join(                                                                                                                                            
 -- select mbr.BranchCode,MAx(name) as 'Name',Max(Division) as 'Division',max(id) as maxid from mBranch as mbr  group by BranchCode                                                                                                                           
  
     
     
          
                           
 -- )  as mybranch                                                                                                                                                                                                
 --on  br.BranchCode=mybranch.BranchCode           
         
  left join mbranch mbs with(nolock) on BR.BranchCode=mbs.BranchCode and br.country=mbs.branch_country        
        
LEFT JOIN (        
    SELECT         
        mbr.BranchCode,        
        MAX(mbr.[Name]) AS 'Name',        
        MAX(mbr.Division) AS 'Division',        
        MAX(mbr.id) AS maxid         
    FROM mBranch mbr        
    GROUP BY mbr.BranchCode        
) AS mybranch        
ON Br.BranchCode = mybranch.BranchCode        
                    
   left join roe R WITH (NOLOCK) on HB.pkId = R.Id                                                 
   left join Hotel_ROE_Booking_History  Roe WITH (NOLOCK) on Roe.FkBookId=Hb.pkId                                           
   --left join B2BMakepaymentCommission MC on MC.FkBookId=HB.pkId                                                                                                                              
   left join Hotel_BookingGSTDetails HBGD WITH (NOLOCK) on HBGD.PKID=HB.pkId            -- add column on 31-03-23                                                                                                                                              
  
    
      
        
          
            
              
                        
   left join B2BHotel_Commission HCC WITH (NOLOCK) on HB.pkId=HCC.Fk_BookId              -- add on 05-04-23                                --add \on 12-04-23                                                                                                  
  
    
      
        
          
            
              
  left join mCommon  mcn WITH (NOLOCK) on mcn.ID=AGL.userTypeID                                                             
   Left join Hotel.tblApiCreditCardDeatils HCCD WITH (NOLOCK) on Hb.BookingReference= HCCD.BookingId                                                                   
   left join tblAgentBalance tba WITH (NOLOCK) on HB.orderId=tba.BookingRef           --add join on 8-8-23                      
   left join Hotel_UpdatedHistory HU on HU.fkbookid=HB.pkid and hu.FieldName in ('Passenger Details ReConfirmation')                                   
   left join Hotel_UpdatedHistory HUU on HB.pkId=HUU.fkbookid and huu.FieldName='ConfirmationNo. Added'                                
   left join mUser mua on hu.InsertedBy=mua.CreatedBy   and HU.FieldName in ('Passenger Details ReConfirmation')                                         
   left join muser mreconfirm on hb.PassengerDetailsReconfirmationBy =mreconfirm.ID                             
   left join mUser mcc on MCc.ID=(select Top 1 InsertedBy from Hotel_UpdatedHistory where fkbookid=HB.pkId order by 1 desc)               
   --left join agentLogin als WITH (NOLOCK) on HB.SubAgentId=als.UserID and HB.SubAgentId!=0              
                        
                              
 where                                                               
                                                                                               
 mybranch.Division  like 'RTT%' and mybranch.BranchCode like 'BR%' and  --PRANAY ***                                                                       
   --(HB.AgentId = @Consultant  or @Consultant ='')                                                                                                                                                       
                                                                                             
   --(HB.MainAgentID = @Consultant  or @Consultant ='')                                                                                                                                                               
   ( ( @Consultant ='') or (HB.MainAgentID IN  (select Data from sample_split(@Consultant,','))) )                                                                                    
                                                                                                                                                                                      
                                                                                                                                   
                                                                       
   --and(BR.BranchCode=@Branch or @Branch ='')                                                                                                                                                                                                       
   and( ( @Branch ='') or (BR.BranchCode IN  (select Data from sample_split(@Branch,','))) )                                                                                                                                    
                                                                                                                                                                                                             
   --and(HB.AgentId = @Agent or @Agent ='')  --akash                                                                
   -- and(HB.RiyaAgentID = @Agent or @Agent ='')                                                                                                          
      and( (@Agent ='') or (HB.RiyaAgentID IN  (select Data from sample_split(@Agent,','))) )                                                                                                
                                                    
                                                                                           
   and(HB.LeaderTitle+' '+HB.LeaderFirstName like '%'+@TravelerName+'%'  or @TravelerName ='')                                                                                                                                                                 
 
     
      
        
         
             
             
                         
 --  and(HB.BookingReference = @BookingID or @BookingID ='')                                                                                
  and( (@BookingID ='') or (HB.BookingReference IN  (select Data from sample_split(@BookingID,','))) )                                                                                               
                                                     
   --and(SH.FkStatusId = @BookingStatus or @BookingStatus='')                                                                                                     
                                                                
   and( (@BookingStatus ='') or (SH.FkStatusId IN  (select Data from sample_split(@BookingStatus,','))) )                                                                                     
                                                                
   --and(HB.SupplierReferenceNo = @SupplierRefNo or @SupplierRefNo='')                                                                                                                 
                                                                                                                   
   and( (@BookingID ='') or (HB.BookingReference IN  (select Data from sample_split(@BookingID,','))) )                                                                                                                       
                                                                                                      
--and( (@Supplier ='') or (HB.SupplierName IN  (select Data from sample_split(@Supplier,','))) )                                                                                                                                                               
  
    
     
         
          
           
               
                
  and( (@Supplier ='') or (HB.SupplierPkId IN  ( select Data from sample_split(@Supplier,','))))                                                                                                                                                               
  
    
      
        
          
                                                                                                                                                                        
   and(HB.riyaPNR = @AgentReferenceNo or @AgentReferenceNo='')                                                                                                    
                                                                                                               
                                                                       
   and(HB.VoucherNumber = @VoucherID   or @VoucherID='')                                                                                                                                                                                             
                                                                                                                                          
   --and(HB.CountryName like '%'+@Country+'%'   or @Country='')                                           
   --and( (@Country ='') or (HB.CountryName IN  (select cast(Data as varchar) from sample_split(@Country,','))) ) --commented by sana                                                                                                                          
 
     
      
        
          
            
              
  and( (@Country ='') or  (HB.CountryName) IN  (select cast(Data as varchar) from sample_split(@Country,',')))          -- changed column from countrypkid to countryname  by aman                                                                             
  
    
      
        
          
            
             
                
 --and(HB.cityName like '%'+@City+'%'  or @City='')                                                                                                                 
   and( (@City ='') or (HB.cityName IN  (select cast(Data as varchar) from sample_split(@City,','))))                                                     
                  
                                                                                                                                            
   --and (                   
   --  (@ConfirmationNumber = '1' and isnull(HotelConfNumber,'') != '')                                                                                                                             
   --  OR                                                                                                                                                                                            
   --  (@ConfirmationNumber = '0' and isnull(HotelConfNumber,'') = '')                               
                      
   --  OR                                                                                                                                                
   --  (@ConfirmationNumber = '')                                                                                           
   --)                                   
                                   
    and (                                                                       
     (@ConfirmationNumber = '1' and isnull(HotelConfNumber,'') != '')                                                                                                                                                           
     OR                                                          
     (@ConfirmationNumber = '0' and isnull(HotelConfNumber,'') = '')                                                                                                                      
     OR                                              
  (@ConfirmationNumber='ReconfirmYes' and HB.PassengerDetailsReconfirmationRemark is not null)                                              
  OR                                              
  (@ConfirmationNumber='ReconfirmNo' and HB.PassengerDetailsReconfirmationRemark is null)                                              
  OR                                              
     (@ConfirmationNumber = '')                                                                                                       
   )                                            
                                                                                                             
   and (Convert(varchar(12),HB.CheckInDate,102) between Convert(varchar(12),Convert(datetime,@ServiceFromDate,103),102) and                                                                                                       
    
     
         
          
           
               
case when @ServiceToDate <> '' then Convert(varchar(12),Convert(datetime,@ServiceToDate,103),102)else Convert(varchar(12),Convert(datetime,@ServiceFromDate,103),102) end or (@ServiceFromDate='' and @ServiceToDate=''))                                     
   
    
      
        
          
           
  and (Convert(varchar(12),HB.inserteddate,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                                                                                      
      
        
          
            
                
case when @BookingToDate <> '' then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate=''))                                      
 
     
      
        
          
           
 and (Convert(varchar(12),HB.inserteddate,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                                                                                                                                     
  
    
      
        
          
            
              
case when @BookingToDate <> '' then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate=''))                                      
  
    
      
        
          
           
  and (Convert(varchar(12),HB.VoucherDate,102) between Convert(varchar(12),Convert(datetime,@VoucherFromDate,103),102) and                                                                                                    
   case when @VoucherToDate <> '' then Convert(varchar(12),Convert(datetime,@VoucherToDate,103),102)else Convert(varchar(12),Convert(datetime,@VoucherFromDate,103),102) end or (@VoucherFromDate='' and @VoucherToDate=''))                                   
  
    
      
        
          
            
              
 and (Convert(varchar(12),SH.CreateDate,102) between Convert(varchar(12),Convert(datetime,@StatusFromDate,103),102) and                                                                                                                        
   case when @StatusToDate <> '' then Convert(varchar(12),Convert(datetime, @StatusToDate,103),102)else Convert(varchar(12),Convert(datetime,@StatusFromDate,103),102) end or (@StatusFromDate='' and @StatusToDate=''))                                       
  
    
      
        
          
            
              
 and (Convert(varchar(12),SH.ModifiedDate,102) between Convert(varchar(12),Convert(datetime,@ModifiedFromDate,103),102) and                                                                     
    case when @ModifiedToDate <> '' then Convert(varchar(12),Convert(datetime, @ModifiedToDate,103),102)else Convert(varchar(12),Convert(datetime,@ModifiedFromDate,103),102) end or (@ModifiedFromDate='' and @ModifiedToDate=''))                            
  
    
      
        
          
            
              
 --checkout date filter                                                                                                                                             
 and (Convert(varchar(12),HB.CheckOutDate,102) between Convert(varchar(12),Convert(datetime,@CheckoutDateFrom,103),102) and                                                                                                                                   
                                                            
case when @CheckoutDateTo <> '' then Convert(varchar(12),Convert(datetime,@CheckoutDateTo,103),102)else Convert(varchar(12),Convert(datetime,@CheckoutDateFrom,103),102) end or (@CheckoutDateFrom='' and @CheckoutDateTo=''))                                 
  
    
      
        
          
           
               
and ( ( @PaymentMode ='') or (HB.B2BPaymentMode IN  (select Data from sample_split(@PaymentMode,','))) )                                                                                                        
    and ((@OBTC='') or((@OBTC='With  OBTC' and HB.OBTCNo is not null) OR (@OBTC='Without  OBTC' and HB.OBTCNo is null) or (@OBTC='-- Select --')))                                                                                                             
               
 --and book_Id is not null                       
   and SH.IsActive=1                                                                                                   
        
 and HB.RiyaAgentID is not null                                                                                          
   and HB.B2BPaymentMode is not null                                                                                                          
   --and HB.BookingReference is not null                                                               
   and (HB.payhotelpaymentstatus=@payathotel or @payathotel is null)                                       
 order by HB.pkId desc                                      
                                                                                   
  end                                                                                                                                                                                                                                            
END 