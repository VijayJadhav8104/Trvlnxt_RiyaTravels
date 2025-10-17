 --EXEC [TR].[B2BTransfer_SearchBookings] 0,0,'','','','','','','TNC00000101','','','','','','','','','','','','','','','','','Excel'  -- **Only ExcelFlag is set**                            
CREATE PROCEDURE [TR].[B2BTransfer_SearchBookings]                                                                                                                                                                                                             
  
    
      
        
          
            
                                                                                                               
 @Id int=0,                                                                                    
 @RiyaUserID int=0,                                                                                                                                                                        
 @Branch nvarchar(200)='',                                                                                     
 @AgencyName nvarchar(200)='',                                                                                    
 @Agent nvarchar(200)='',                                                                                                                                                                        
 @TravelerName nvarchar(200)='',                                                                                                                                                                        
 @ServiceFromDate varchar(50)='',                                                                                                                                                                        
 @ServiceToDate varchar(50)='',                                                                                                                                                                        
 @BookingID nvarchar(200)='',                                                                                                                                                                        
 @BookingStatus  nvarchar(200)='',                                                                                                                                                                        
 @SupplierRefNo nvarchar(200)='',                                                                                                                                                                        
 @Supplier nvarchar(200)='',                                                                                                                                                                        
 @BookingFromDate varchar(50)='',                                                                                                                                                                        
 @BookingToDate varchar(50)='',                                            
 @DeadlineFromDate varchar(50)='',                                            
 @DeadlineToDate varchar(50)='',                                          
 @StatusFromDate varchar(50)='',                                                                              
 @StatusToDate varchar(50)='',                                           
 @VoucherFromDate varchar(50)='',                                                                 
 @VoucherToDate varchar(50)='',                                           
 @ConfirmationNumber nvarchar(200)='',                                                                                                                                                                      
 @Country nvarchar(200)='',                                                                                                                                                                        
 @City nvarchar(200)='',                            
 @PaymentMode nvarchar(200)='',                          
 @OBTCNo nvarchar(200)='',                          
 @ExcelFlag varchar(50)=''            
                                                     
             
AS                                    
BEGIN                                       
                                                                      
If(@ExcelFlag='Gride' or @ExcelFlag='')                                     
                                                              
 Begin                                                      
 select                         
 BM.BookingId,                                                          
 BM.BookingRefId,                                      
 LTRIM(UPPER(LEFT(BM.BookingStatus, 1)) + LOWER(SUBSTRING(BM.BookingStatus, 2, LEN(BM.BookingStatus) - 1)))  as BookingStatus,                                                                                               
 BM.AgentID,                                                                              
 BR.AgencyName + ISNULL(+'-'+MU.FullName,'') as 'AgencyName',                                                             
 PD.Titel,                                              
 PD.Name,                                                                  
 PD.Surname,                                                                                            
 ( Isnull(PD.Titel,'') +' '+ Isnull(PD.Name,'')+ ' '+Isnull(PD.Surname,'')) as TravelerName,                                                                                            
 Case when bm.BookingStatus='Cancelled' and bm.AgentCanxCharges is not null then                                                          
 (Isnull(BM.BookingCurrency,'NA') + ' '+ CONVERT(varchar(200),BM.AgentCanxCharges)) else                                                          
 --(Isnull(BM.BookingCurrency,'NA') + ' '+ CONVERT(varchar(200),BM.AmountBeforePgCommission)) end as BookingAmount,  ----as discussed with gary change column on 27-10-23 instead of bookingrate                                                               
                        
 (Isnull(BM.BookingCurrency,'NA') + ' '+ CONVERT(varchar(200),case when BM.AmountAfterPgCommision=0                            
 then BM.BookingRate else BM.AmountAfterPgCommision end)) end as BookingAmount,                      
 --as discussed with gary change column on 22-02-24 instead of BM.AmountBeforePgCommission                                  
 FORMAT(CAST(BM.creationDate AS datetime),'dd MMM yyyy hh:mm tt') as BookingDate,   FORMAT(CAST(BM.TripStartDate AS datetime),'dd MMM yyyy hh:mm tt') as ServiceDate,  FORMAT(CAST(BM.CancellationDeadline AS datetime),'dd MMM yyyy hh:mm tt') as DeadlineDate
  
    
,                                                                                           
 ISnull(BM.PickupLocation,'NA') as Destination,                      
 (BM.PickupLocation+ ' ==> ' +BM.DropOffLocation) AS TransferName,                      
 --BA.CarName,                                                                               
 BM.providerName as providerName,                                                                                            
 BM.ProviderConfirmationNumber,                                                                              
 Case                                                                               
      when BM.PaymentMode=1 then '<span style="color:blue; font-weight:normal">Hold</span>'                                                                                                      
   when BM.PaymentMode=2 then '<span style="color:Black; font-weight:normal">Credit limit</span>'                                                                                                                                        
   when  BM.PaymentMode=3 then '<span style="color:Black; font-weight:normal">Make payment</span>'                                                                                                        
   when  BM.PaymentMode=4 then '<span style="color:Black; font-weight:normal">Self balance</span>'             
   else   ''    end as 'PaymentMode'                                                    
                             
 from                                                       
 TR.TR_BookingMaster BM WITH (NOLOCk)                                           
 left join TR.TR_BookedCars BA WITH (NOLOCk) on BM.BookingId=BA.BookingId                                                                        
 join TR.TR_PaxDetails PD WITH (NOLOCk) on BM.BookingId=PD.BookingId                                                                                           
 left join B2BRegistration BR WITH (NOLOCk) on BM.AgentID=BR.FKUserID                                                                                             
 left join mUser MU WITH (NOLOCk) on BM.MainAgentID=MU.ID                                                         
 left join Hotel_Status_Master HM WITH (NOLOCk) on BM.BookingStatus=HM.Status                                                
 left join TR.TR_Status_History SH WITH (NOLOCk) on BM.BookingId=SH.BookingId                                                                        
                                                    
 where                                                                   
-- PD.LeadPax=1 and                                                                  
(( @RiyaUserID ='') or (BM.MainAgentID IN  (select Data from sample_split(@RiyaUserID,','))))                               
                                                                                       
 and(( @Branch ='') or (BR.BranchCode IN  (select Data from sample_split(@Branch,','))))                                                                                          
                                                                                        
 and( (@Agent ='') or (BM.AgentID IN  (select Data from sample_split(@Agent,','))) )                                                                                        
                                                                  
and( (@AgencyName ='') or (BM.AgentID IN  (select Data from sample_split(@Agent,','))) )                        
                      
  --and(PD.Titel + ' ' + PD.Name + ' ' + PD.Surname LIKE '%' + @TravelerName + '%' OR @TravelerName = '')                                                
  and((( PD.Name)   like '%'+@TravelerName+'%'  or @TravelerName ='') or ( ( PD.Surname)   like '%'+@TravelerName+'%'  or @TravelerName ='') )                                                                                                                
                                                                     
  and( (@Supplier ='') or (BM.providerId IN  (select Data from sample_split(@Supplier,','))) )                                                                                          
                                                                                        
and( (@City ='') or (lower(isnull(BM.CityCode,BM.CityName)) IN  (select cast(Data as varchar) from sample_split(@City,','))))                                                                                            
                                            
and( (@Country ='') or (lower(BM.CountryCode)  IN  (select cast(Data as varchar) from sample_split(@Country,','))))                                                                                            
                                            
  --ServiceToDate                                                                                       
and (Convert(varchar(12),BM.TripStartDate,102) between Convert(varchar(12),Convert(datetime,@ServiceFromDate,103),102) and                                                                                                                                     
  
    
      
        
          
     
              
                
                  
                    
                    
                        
                         
   case when @ServiceToDate <> '' then Convert(varchar(12),Convert(datetime,@ServiceToDate,103),102)                              
   else Convert(varchar(12),Convert(datetime,@ServiceFromDate,103),102) end or (@ServiceFromDate='' and @ServiceToDate=''))                                                                 
                               
   --BookingToDate                                               
   and (Convert(varchar(12),BM.creationDate,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                                                                                                    
   case when @BookingToDate <> '' then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)                              
   else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate=''))                                  
                                
                                         
                                              
    --DeadlienDate                     
  and (Convert(varchar(12),BM.CancellationDeadline,102) between Convert(varchar(12),Convert(datetime,@DeadlineFromDate,103),102) and                                                   
   case when @DeadlineFromDate <> '' then Convert(varchar(12),Convert(datetime,@DeadlineToDate,103),102)                              
   else Convert(varchar(12),Convert(datetime,@DeadlineFromDate,103),102) end                                            
   or (@DeadlineFromDate='' and @DeadlineToDate=''))                                        
                                                
    --VoucherToDate                                              
   and ( SH.FkStatusId=4 AND Convert(varchar(12),SH.CreateDate,102) between Convert(varchar(12),Convert(datetime,@VoucherFromDate,103),102) and                                                                                          
  case when @VoucherToDate <> '' then Convert(varchar(12),Convert(datetime,@VoucherToDate,103),102)                                          
  else Convert(varchar(12),Convert(datetime,@VoucherFromDate,103),102) end                                          
  or (@VoucherFromDate='' and @VoucherToDate=''))                                                                             
                                            
                                              
                                                                                                                                          
     --StatusToDate                                                                                                  
   and (Convert(varchar(12),SH.CreateDate,102) between Convert(varchar(12),Convert(datetime,@StatusFromDate,103),102)                                           
   and case when @StatusToDate <> '' then Convert(varchar(12),Convert(datetime, @StatusToDate,103),102)                                          
   else Convert(varchar(12),Convert(datetime,@StatusFromDate,103),102) end or (@StatusFromDate='' and @StatusToDate=''))                                                                                 
                                            
                                                                                       
  and( (@PaymentMode ='') or (BM.PaymentMode IN  (select Data from sample_split(@PaymentMode,','))) )                                                                                                        
  and( (@ConfirmationNumber ='') or (BM.ProviderConfirmationNumber IN  (select Data from sample_split(@ConfirmationNumber,','))) )                                                                                                        
 and( (@BookingID ='') or (BM.BookingRefId IN  (select Data from sample_split(@BookingID,','))) )                                                   
  and( (@BookingStatus ='') or (SH.FkStatusId IN  (select Data from sample_split(@BookingStatus,','))) )                                                                        
  and SH.IsActive=1                                                                      
 order by BookingId desc                                                                                            
                                                                         
End                                   
                                                                  
if(@ExcelFlag='Excel')                                                                   
                                                                  
Begin                                                                                             
 select                                                   
'Transfer' as [Service],                  
mcn.Value as 'UserType',                  
isnull(BR.EntityType,'NA') as 'Customer Type',                           
Isnull(BR.AgencyName,'NA')  as  'Customer Name',                   
 BM.BookingRefId as [Booking Id],                  
 --case when BR.country='India' then  mybranch.[Name] else mbs.[Name] end AS Branch ,                  
 BR.AgencyName as 'Agency  User',                  
--   CASE                               
--    WHEN br.country LIKE '%INDIA%'                               
--         AND ISNULL(LTRIM(RTRIM(BR.BillingID)), '') <> ''                               
--    THEN ISNULL(Br.Icast, 'NA') +' ' + ' /' +' ' + BR.BillingID                               
--    ELSE ISNULL(Br.Icast, 'NA')                               
--END AS 'Agent ID',            
CASE                  WHEN  ISNULL(LTRIM(RTRIM(BR.BillingID)), '') <> ''                  THEN ISNULL(Br.Icast, 'NA') +' ' + ' /' +' ' + BR.BillingID                  ELSE ISNULL(Br.Icast, 'NA')              END AS 'Agent ID' ,            
( Isnull(PD.Titel,'') +' '+ Isnull(PD.Name,'')+ ' '+Isnull(PD.Surname,'')) as TravelerName,                  
 FORMAT(CAST(BM.CreationDate AS datetime) , 'dd-MM-yyyy HH:mm tt') as  [Booking Date],                                                                                    
 format(cast(BM.TripStartDate as datetime),'dd-MM-yyyy tt') as 'Service Date',      
   FORMAT(CAST(BM.CancellationDeadline AS datetime),'dd MMM yyyy hh:mm tt') as 'Cancellation Deadline',      
 --convert(varchar,CancellationDeadLine,0) as 'Cancellation Deadline',                  
  BR.AgencyName + ISNULL(+'-'+MU.FullName,'') as 'AgencyName',                  
  (BM.PickupLocation+ ' TO ' +BM.DropOffLocation) AS TransferName,                  
  BA.CarName  as 'CarName',                                       
 BM.CityName as 'City',                                                  
 BM.CountryCode as 'Country',                  
LTRIM(UPPER(LEFT(BM.BookingStatus, 1)) + LOWER(SUBSTRING(BM.BookingStatus, 2, LEN(BM.BookingStatus) - 1)))  as  'CurrentStatus',                  
  Case                                                                         
      when BM.PaymentMode=1 then 'Hold'                                                                                                
   when BM.PaymentMode=2 then 'Credit Limit'                                                                                                                                  
   when  BM.PaymentMode=3 then 'Make Payment'                                                                                            
   when  BM.PaymentMode=4 then 'Self Balalnce'                                                                                                                                  
   else   ''    end as 'Mode Of Payment',                                                 
 BM.BookingCurrency as 'Booking Currency',                  
case when BM.AmountAfterPgCommision=0 then BM.BookingRate else BM.AmountAfterPgCommision end as 'Agent Booking Amount',                  
isnull(BM.GstAmountonServiceCharges,0.00) as 'Service Charges(including GST)',                   
isnull(BM.PricingProfile,0.00) as 'Markup',                  
--case when BM.BookingCurrency='INR' and BM.SupplierCurrency='INR' then (BM.AgentDiscountPrice* 1)                                        
  -- when  BM.BookingCurrency ='AED'  then (BM.BookingRate* BM.FinalROE)                                        
 --  when  BM.BookingCurrency ='USD' and BM.SupplierCurrency='INR'  then (BM.BookingRate* BM.FinalROE)                                        
   --else (BM.AgentDiscountPrice)  end as 'Agent Rate in INR',               
   ISNULL(NULLIF(AgentToInrFinalRoe, ''), 1) * AmountAfterPgCommision  as 'Agent Rate in INR',               
isnull(BM.InrToSupplierRoe,1) as 'ROE (supplier to INR Currency)',                  
BM.ProviderConfirmationNumber as 'Supplier Refrence No.',                   
BM.providerName as 'Supplier Name',                  
BM.SupplierCurrency as 'Supplier Currency',          
isnull(BM.SupplierRate,0.00) as 'Supplier Booking Amount',                  
isnull(BM.InrToSupplierFinalRoe,0.00) as 'Sell ROE',                  
isnull(BM.SupplierRate,0.00) AS 'Supplier rate in INR',                  
isnull(BM.ServiceCharges,0.00) AS 'Supplier Service Charges',                  
                  
 CASE                                                   
    WHEN BM.PaymentMode = 3 THEN                                                   
        CONCAT(BM.BookingCurrency, ' ',CONVERT(varchar, BM.AmountAfterPgCommision- BM.AmountBeforePgCommission))                                                  
    ELSE                                                   
        'NA'                                                  
END AS  'PG Charges',                                                  
 case when BM.PaymentMode=3 then 'Yes' else 'No' end as 'PG Confirmation No / PG Type',                    
--'' AS 'PG Charges',                  
 PD.PancardNo as 'Pan Card No.',                  
 PD.PanCardName as 'PanCard Name',                  
 'NA' as 'Declaration',                  
 PD.Nationality AS 'Nationality',                  
                  
 PD.PassportNumber as 'Passport No.',                                                  
case when pd.PassportNumber is null   then 'NA' else Isnull(CONVERT(varchar(20),PD.PassportIssueDate),'NA')  end as 'Date Of Issue',                                              
case when pd.PassportNumber is null then 'NA' else ISNULL(Convert( varchar(20), PD.DateOfBirth),'NA') end as 'Date Of Birth',                                              
case when pd.PassportNumber is null then 'NA' else ISNULL(convert(varchar(20),PD.PassportExpirationDate),'NA') end as 'Date Of Expire',                  
                  
   FORMAT(CAST(SH.CreateDate AS datetime),'dd MMM yyyy hh:mm tt') as creationDate  --'NA' as 'VCC Bank Charges',                                                  
 --'NA' as 'VCC Card Type'                                                                               
 from                     
TR.TR_BookingMaster BM WITH (NOLOCk)                                                                                            
 left join TR.TR_BookedCars BA WITH (NOLOCk) on BM.BookingId=BA.BookingId                                                                        
 join TR.TR_PaxDetails PD WITH (NOLOCk) on BM.BookingId=PD.BookingId                                                                                        
 left join B2BRegistration BR WITH (NOLOCk) on BM.AgentID=BR.FKUserID                                                                                                                
 left join mUser MU WITH (NOLOCk) on BM.MainAgentID=MU.ID                                                                                    
 left join Hotel_Status_Master HM WITH (NOLOCk) on BM.BookingStatus=HM.Status                                                
 left join TR.TR_Status_History SH WITH (NOLOCk) on BM.BookingId=SH.BookingId                                 
 left join B2BMakepaymentCommission BMC WITH (NOLOCk) on BM.BookingId=BMC.FkBookId                   
  join AgentLogin AGL WITH (NOLOCK) on BM.AgentID=AGL.UserID                                
 left join agentLogin al WITH (NOLOCK) ON BR.FKUserID=al.UserID                                                
  -- left join Hotel_Status_Master HM WITH (NOLOCK) on SH.FkStatusId=HM.Id                                                                       
  left join mCommon  mcn WITH (NOLOCK) on mcn.ID=AGL.userTypeID                   
                    
 -- left join mbranch mbs with(nolock) on BR.BranchCode=mbs.BranchCode and br.country=mbs.branch_country                                    
  LEFT JOIN (                                    
    SELECT                                     
        mbr.BranchCode,                                    
        MAX(mbr.[Name]) AS 'Name',                                    
        MAX(mbr.Division) AS 'Division',                                    
        MAX(mbr.id) AS maxid                                     
    FROM mBranch mbr                                    
    GROUP BY mbr.BranchCode                                    
) AS mybranch                                    
ON BR.BranchCode = mybranch.BranchCode                     where                                              
 --PD.LeadPax=1 and                              
                               
(( @RiyaUserID ='') or (BM.MainAgentID IN  (select Data from sample_split(@RiyaUserID,','))))                                                                                        
                                                                                        
 and(( @Branch ='') or (BR.BranchCode IN  (select Data from sample_split(@Branch,','))))                            
                                                                                           
 and( (@Agent ='') or (BM.AgentID IN  (select Data from sample_split(@Agent,','))) )                                                                              
                                                                   
and( (@AgencyName ='') or (BM.AgentID IN  (select Data from sample_split(@Agent,','))) )                                          
                      
  and((( PD.Name)   like '%'+@TravelerName+'%'  or @TravelerName ='') or ( ( PD.Surname)   like '%'+@TravelerName+'%'  or @TravelerName ='') )                                                                                                                
   
    
     
        
          
            
              
                
                   
                   
                                  
                      
  --and(PD.Titel+' '+PD.Name+' '+PD.Surname   like '%'+@TravelerName+'%'  or @TravelerName ='')                                                                            
                                                                                       
  and( (@Supplier ='') or (BM.providerId IN  (select Data from sample_split(@Supplier,','))) )                                                                                        
                                                                                        
and( (@City ='') or (isnull(BM.CityCode,BM.CityName) IN  (select cast(Data as varchar) from sample_split(@City,','))))                                                                                            
                                            
and( (@Country ='') or (BM.CountryCode IN  (select cast(Data as varchar) from sample_split(@Country,','))))                                                                                    
                                                                      
   --ServiceToDate                                                                                      
 and (Convert(varchar(12),BM.TripStartDate,102) between Convert(varchar(12),Convert(datetime,@ServiceFromDate,103),102) and                           
   case when @ServiceToDate <> '' then Convert(varchar(12),Convert(datetime,@ServiceToDate,103),102)                          
   else Convert(varchar(12),Convert(datetime,@ServiceFromDate,103),102) end or (@ServiceFromDate='' and @ServiceToDate=''))                           
                          
   --BookingToDate                          
   and (Convert(varchar(12),BM.creationDate,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                                                          
  case when @BookingToDate <> '' then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)                          
   else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate=''))                                                             
                                        
      --DeadlienDate                                            
  and (Convert(varchar(12),BM.CancellationDeadline,102) between Convert(varchar(12),Convert(datetime,@DeadlineFromDate,103),102) and                                                                                             
   case when @DeadlineFromDate <> '' then Convert(varchar(12),Convert(datetime,@DeadlineToDate,103),102)else Convert(varchar(12),Convert(datetime,@DeadlineFromDate,103),102) end                           or (@DeadlineFromDate='' and @DeadlineToDate=''))  
  
    
      
        
          
           
              
                
                   
                    
                                              
                     
      -- VoucherToDate                                       
  and ( SH.FkStatusId=4 AND Convert(varchar(12),SH.CreateDate,102) between Convert(varchar(12),Convert(datetime,@VoucherFromDate,103),102) and                                                                                          
  case when @VoucherToDate <> '' then Convert(varchar(12),Convert(datetime,@VoucherToDate,103),102)                                          
  else Convert(varchar(12),Convert(datetime,@VoucherFromDate,103),102) end                                          
  or (@VoucherFromDate='' and @VoucherToDate=''))                           
                            
   --StatusToDate                                                                                                                                                                                                             
   and (Convert(varchar(12),SH.CreateDate,102) between Convert(varchar(12),Convert(datetime,@StatusFromDate,103),102)                                           
   and case when @StatusToDate <> '' then Convert(varchar(12),Convert(datetime, @StatusToDate,103),102)                                          
   else Convert(varchar(12),Convert(datetime,@StatusFromDate,103),102) end or (@StatusFromDate='' and @StatusToDate=''))                                                                                 
                                                                                   
  and( (@PaymentMode ='') or (BM.PaymentMode IN  (select Data from sample_split(@PaymentMode,','))) )                                                                                                        
and( (@ConfirmationNumber ='') or (BM.ProviderConfirmationNumber IN  (select Data from sample_split(@ConfirmationNumber,','))) )                 
  and ((@BookingStatus='') or (SH.FkStatusId IN  (select Data from sample_split(@BookingStatus,','))))                                                           
-- and ((@BookingID='') or (BM.BookingRefId=@BookingID))                                                                                      
  and( (@BookingID ='') or (BM.BookingRefId IN  (select Data from sample_split(@BookingID,','))) )                                                  
                                                     
                                                                        
  and SH.IsActive=1                        
 order by BM.BookingId desc                                                                    
                                                                  
 End                                                                  
                                                                  
END                    
                  
--EXEC [TR].[B2BTransfer_SearchBookings] 0,0,'','','','','','','TNC0000002','','','','','','','','','','','','','','','','','Excel'  -- **Only ExcelFlag is set**