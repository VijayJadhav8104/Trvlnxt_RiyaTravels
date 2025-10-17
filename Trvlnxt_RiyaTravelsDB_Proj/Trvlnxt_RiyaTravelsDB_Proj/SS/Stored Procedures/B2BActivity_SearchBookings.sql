                               
                                  
                                              
                                              
                                                          
                                                          
                                                      
                         
CREATE PROCEDURE [SS].[B2BActivity_SearchBookings]                                                                                                                                              
                                                                                                                                               
 @Id int=0,                                                          
 @RiyaUserID nvarchar(200)='',                                                                                                                                              
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
 @ExcelFlag varchar(50)=''                                                                                                                    
                                                                                  
                                                                                 
AS                  
BEGIN             
If(@ExcelFlag='Gride' or @ExcelFlag='')                                         
                                         
 Begin                               
 select                                
 BM.BookingId,                                
 BM.BookingRefId,                    
 BM.BookingStatus as BookingStatus,                                                                  
 BM.AgentID,                                                    
 BR.AgencyName + ISNULL(+'-'+MU.FullName,'') as 'AgencyName',                                   
 PD.Titel,                    
 PD.Name,                                        
 PD.Surname,                                                                  
 ( PD.Titel +' '+ PD.Name+ ' '+PD.Surname) as TravelerName,                                                                  
 Case when bm.BookingStatus='Cancelled' and bm.AgentCanxCharges is not null then                                
 (Isnull(BM.BookingCurrency,'NA') + ' '+ CONVERT(varchar(200),BM.AgentCanxCharges)) else                                
 --(Isnull(BM.BookingCurrency,'NA') + ' '+ CONVERT(varchar(200),BM.AmountBeforePgCommission)) end as BookingAmount,  ----as discussed with gary change column on 27-10-23 instead of bookingrate                                                              
   
    
 (Isnull(BM.BookingCurrency,'NA') + ' '+ CONVERT(varchar(200),case when BM.AmountAfterPgCommision=0 then BM.BookingRate else BM.AmountAfterPgCommision end)) end as BookingAmount,          
 --convert(varchar,BM.creationDate) as BookingDate,  
 FORMAT(CAST(BM.creationDate AS datetime) , 'dd MMM yyyy HH:mm tt') as BookingDate,  
-- BM.TripStartDate as ServiceDate,  
FORMAT(CAST(BM.TripStartDate AS datetime) , 'dd MMM yyyy HH:mm tt') as ServiceDate,  
--Convert(varchar, ISNULL(BM.CancellationDeadline,'')) as DeadlineDate,  
FORMAT(CAST(BM.CancellationDeadline AS datetime) , 'dd MMM yyyy HH:mm tt') as DeadlineDate,  
 ISnull(BM.CityName,'NA') as Destination,                                                                  
 BA.ActivityName,                                                     
 BM.providerName as providerName,                                                                  
 BM.ProviderConfirmationNumber,                                                    
 Case                                                     
      when BM.PaymentMode=1 then '<span style="color:blue; font-weight:normal">Hold</span>'                                                                            
   when BM.PaymentMode=2 then '<span style="color:Black; font-weight:normal">Credit Limit</span>'                                                                                                              
   when  BM.PaymentMode=3 then '<span style="color:Black; font-weight:normal">Make Payment</span>'                                                                              
   when  BM.PaymentMode=4 then '<span style="color:Black; font-weight:normal">Self Balance</span>'                                                                                                              
   else   ''    end as 'PaymentMode',                                                    
   BA.ActivityOptionTime as 'ActivitystartTime',                                                    
   isnull(BA.GuidingLanguage,'') as 'TourLanguage',                                                    
                                                    
  --Pending Canx--                                                  
  case when  BM.Pendingcancellation is null then 0                                                  
  when BM.Pendingcancellation=0 then 0 else 1 end as 'RequestForCancelled'    
     
                                                                
                                                                  
                                                                    
                                                                   
 from                                                                  
 ss.SS_BookingMaster BM                                                  
 left join SS.SS_BookedActivities BA on BM.BookingId=BA.BookingId                                              
 join SS.SS_PaxDetails PD on BM.BookingId=PD.BookingId                                                                  
 left join B2BRegistration BR on BM.AgentID=BR.FKUserID                                                                                                                                               
 left join mUser MU on BM.MainAgentID=MU.ID                                                          
 left join Hotel_Status_Master HM on BM.BookingStatus=HM.Status                      
 left join Ss.SS_Status_History SH on BM.BookingId=SH.BookingId                                              
                          
 where                                         
 PD.LeadPax=1 and                                  
 --PD.PassportNumber is not null and                                                       
(( @RiyaUserID ='') or (BM.MainAgentID IN  (select Data from sample_split(@RiyaUserID,','))))                                                               
                                                             
 and(( @Branch ='') or (BR.BranchCode IN  (select Data from sample_split(@Branch,','))))                                                                
                                                              
 and( (@Agent ='') or (BM.AgentID IN  (select Data from sample_split(@Agent,','))) )                                                              
                                        
and( (@AgencyName ='') or (BM.AgentID IN  (select Data from sample_split(@Agent,','))) )                                                           
                                                          
  and(PD.Titel+' '+PD.Name+' '+PD.Surname   like '%'+@TravelerName+'%'  or @TravelerName ='')                                                                                                                         
                                                             
  and( (@Supplier ='') or (BM.providerId IN  (select Data from sample_split(@Supplier,','))) )                                                                
                                                              
and( (@City ='') or (lower(isnull(BM.CityCode,BM.CityName)) IN  (select cast(Data as varchar) from sample_split(@City,','))))                                                                  
                  
and( (@Country ='') or (lower(BM.CountryCode)  IN  (select cast(Data as varchar) from sample_split(@Country,','))))                                                                  
                  
                                                               
and (Convert(varchar(12),BM.TripStartDate,102) between Convert(varchar(12),Convert(datetime,@ServiceFromDate,103),102) and                                                                                                                                     
 
     
     
   case when @ServiceToDate <> '' then Convert(varchar(12),Convert(datetime,@ServiceToDate,103),102)else Convert(varchar(12),Convert(datetime,@ServiceFromDate,103),102) end or (@ServiceFromDate='' and @ServiceToDate=''))                                   
  
    
     
         
         
            
              
                
                  
                     
                      
                        
                                                                    
   and (Convert(varchar(12),BM.creationDate,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                                                                                         
   case when @BookingToDate <> '' then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate=''))                                   
  
    
      
        
          
            
              
                
                  
                    
    --DeadlienDate                  
  and (Convert(varchar(12),BM.CancellationDeadline,102) between Convert(varchar(12),Convert(datetime,@DeadlineFromDate,103),102) and                         
   case when @DeadlineFromDate <> '' then Convert(varchar(12),Convert(datetime,@DeadlineToDate,103),102)else Convert(varchar(12),Convert(datetime,@DeadlineFromDate,103),102) end                  
   or (@DeadlineFromDate='' and @DeadlineToDate=''))                      
                      
                        
   and ( SH.FkStatusId=4 AND Convert(varchar(12),SH.CreateDate,102) between Convert(varchar(12),Convert(datetime,@VoucherFromDate,103),102) and                                                                
  case when @VoucherToDate <> '' then Convert(varchar(12),Convert(datetime,@VoucherToDate,103),102)                
  else Convert(varchar(12),Convert(datetime,@VoucherFromDate,103),102) end                
  or (@VoucherFromDate='' and @VoucherToDate=''))                                                   
                  
                    
                                                                                                                
                                                                             
   and (Convert(varchar(12),SH.CreateDate,102) between Convert(varchar(12),Convert(datetime,@StatusFromDate,103),102)                 
   and case when @StatusToDate <> '' then Convert(varchar(12),Convert(datetime, @StatusToDate,103),102)                
   else Convert(varchar(12),Convert(datetime,@StatusFromDate,103),102) end or (@StatusFromDate='' and @StatusToDate=''))                                                       
                  
                                                             
   and (                                                                                                                                          
    (@ConfirmationNumber = '1' and isnull(BM.ProviderConfirmationNumber,'') != '')                                                                                                                                          
     OR                                                                                           
     (@ConfirmationNumber = '0' and isnull(BM.ProviderConfirmationNumber,'') = '')                                                       
     OR                                                                                                                                          
     (@ConfirmationNumber = '')                                                                                         
   )                                                          
                                                        
 --and ((@BookingID='') or (BM.BookingRefId=@BookingID))                           
 and( (@BookingID ='') or (BM.BookingRefId IN  (select Data from sample_split(@BookingID,','))) )                         
  and( (@BookingStatus ='') or (SH.FkStatusId IN  (select Data from sample_split(@BookingStatus,','))) )                                              
  and SH.IsActive=1                                            
 order by BookingId desc                                                                  
                                                                
End                                        
                                        
if(@ExcelFlag='Excel')                                         
                                        
Begin                                        
                                        
                                                                   
 select                        
                         
 BM.BookingRefId as 'BookingReference',                                                            
 BM.BookingStatus as 'CurrentStatus',                                                            
                                               
 BR.AgencyName + ISNULL(+'-'+MU.FullName,'') as 'AgencyName',     
    CASE                 
    WHEN  ISNULL(LTRIM(RTRIM(BR.BillingID)), '') <> ''     
    THEN ISNULL(Br.Icast, 'NA') +' ' + ' /' +' ' + BR.BillingID                 
    ELSE ISNULL(Br.Icast, 'NA')                 
END AS 'Agent ID' ,    
                                                           
 ( PD.Titel +' '+ PD.Name+ ' '+PD.Surname) as 'TravellerName'                        
 ,case when BM.creationDate='1753-01-01 00:00:00.000' then '2023-01-01 00:00:00.000' else ISNULL(bm.creationDate,'') end as 'Booking Date'                          
                        
,BM.TripStartDate as 'Activity Date'                        
 ,case when BM.CancellationDeadline='1753-01-01 00:00:00.000' then '2023-01-01 00:00:00.000' else ISNULL(bm.CancellationDeadline,'') end as 'DeadLineDate'                    
                        
 ,BA.ActivityName  as 'Activity Name'                        
 ,BM.totalPax as 'No. of Passangers'                        
 ,BM.CityName as 'City'                        
 ,BM.CountryCode as 'Country'                        
 , Case                                               
      when BM.PaymentMode=1 then 'Hold'                                                                      
   when BM.PaymentMode=2 then 'Credit Limit'                                                                                                        
   when  BM.PaymentMode=3 then 'Make Payment'                                                                  
   when  BM.PaymentMode=4 then 'Self Balalnce'                                                                                                        
   else   ''    end as 'Mode Of Payment'                        
   ,BM.BookingCurrency as 'Booking Currency'                        
   ,case when BM.AmountAfterPgCommision=0 then BM.BookingRate else BM.AmountAfterPgCommision end as 'Agent Booking Amount'                        
   ,BM.GstAmountonServiceCharges as 'Service Charges(including GST)'                        
   ,isnull(BM.Markup,0.00) as 'Markup'                        
   ,isnull(BM.ROEValue,1) as 'ROE( Supplier to Agent Currency)'                        
   ,case when BM.BookingCurrency='INR' and BM.SupplierCurrency='INR' then (BM.BookingRate* 1)              
   when  BM.BookingCurrency !='INR'  then (BM.BookingRate* BM.FinalROE)              
   when  BM.BookingCurrency ='USD' and BM.SupplierCurrency='INR'  then (BM.BookingRate* BM.FinalROE)              
   else (BM.BookingRate)  end as 'Agent Rate in INR'                         
   ,PD.PancardNo as 'Pan Card No.'                        
   ,PD.PanCardName as 'PanCard Name'                        
   ,'NA' as 'Declaration'                        
   ,PD.PassportNumber as 'Passport No.'                        
   ,case when pd.PassportNumber is null   then 'NA' else Isnull(CONVERT(varchar(20),PD.PassportIssueDate),'NA')  end as 'Date Of Issue'                    
   ,case when pd.PassportNumber is null then 'NA' else ISNULL(Convert( varchar(20), PD.DateOfBirth),'NA') end as 'Date Of Birth'                    
   ,case when pd.PassportNumber is null then 'NA' else ISNULL(convert(varchar(20),PD.PassportExpirationDate),'NA') end as 'Date Of Expire'                      
   ,BM.providerName as 'Supplier Name'                        
   ,BM.ProviderConfirmationNumber as 'Supplier Refrence No.'                        
   ,BM.SupplierCurrency as 'Supplier Currency'                        
   ,BM.SupplierRate as 'Supplier Booking Amount'                        
   ,case when BM.BookingCurrency='AED'  Then isnull(BM.finalroe,1)              
   When BM.BookingCurrency='USD' and BM.SupplierCurrency='INR' then 1              
   else  isnull(BM.FinalROE,1) end as 'ROE(Supplier to Billing Currency)'               
                 
   ,case when BM.BookingCurrency='AED' then  CONCAT(BM.BookingCurrency,' ',BM.SupplierRate * isnull(BM.finalroe,0))               
  when BM.BookingCurrency='USD' and BM.SupplierCurrency='INR' then CONCAT('INR',' ',BM.SupplierRate)              
  else  CONCAT(BM.BookingCurrency,' ',BM.SupplierRate * isnull(BM.ROEValue,1))              
 end as 'Supplier rate in INR/AED'              
               
   ,isnull(BM.suppliercharges,0.00) as 'Supplier Service Charges'                        
   ,'NA' as 'VCC Bank Charges'                        
   ,'NA' as 'VCC Card Type'                        
   , CASE                         
    WHEN BM.PaymentMode = 3 THEN                         
        CONCAT(BM.BookingCurrency, ' ',CONVERT(varchar, BM.AmountAfterPgCommision- BM.AmountBeforePgCommission))                        
    ELSE                         
        'NA'                        
END AS  'PG Charges'                        
   , case when BM.PaymentMode=3 then 'Yes' else 'No' end as 'PG Confirmation No / PG Type'                        
   , BM.OBTCNumber as 'Fileobtc'    
   ,SH.CreateDate  as creationDate                   
   ,Isnull(PD.PassportNumber,'NA') as   PassportNumber              
                                                      
 from                                                    
 ss.SS_BookingMaster BM                                                     
 left join SS.SS_BookedActivities BA on BM.BookingId=BA.BookingId                                                    
 join SS.SS_PaxDetails PD on BM.BookingId=PD.BookingId                                                    
 left join B2BRegistration BR on BM.AgentID=BR.FKUserID                                                                                                                                 
 left join mUser MU on BM.MainAgentID=MU.ID                                            
 left join Hotel_Status_Master HM on BM.BookingStatus=HM.Status                                
 left join Ss.SS_Status_History SH on BM.BookingId=SH.BookingId       
 left join B2BMakepaymentCommission BMC on BM.BookingId=BMC.FkBookId      
 where                    
 PD.LeadPax=1 and                       
(( @RiyaUserID ='') or (BM.MainAgentID IN  (select Data from sample_split(@RiyaUserID,','))))                                                               
                                                              
 and(( @Branch ='') or (BR.BranchCode IN  (select Data from sample_split(@Branch,','))))                                                                     
                                                                 
 and( (@Agent ='') or (BM.AgentID IN  (select Data from sample_split(@Agent,','))) )                                                    
                                         
and( (@AgencyName ='') or (BM.AgentID IN  (select Data from sample_split(@Agent,','))) )                                                           
                                                          
  and(PD.Titel+' '+PD.Name+' '+PD.Surname   like '%'+@TravelerName+'%'  or @TravelerName ='')                                                  
                                                             
  and( (@Supplier ='') or (BM.providerId IN  (select Data from sample_split(@Supplier,','))) )                                                                
                                                              
and( (@City ='') or (isnull(BM.CityCode,BM.CityName) IN  (select cast(Data as varchar) from sample_split(@City,','))))                                                                  
                  
and( (@Country ='') or (BM.CountryCode IN  (select cast(Data as varchar) from sample_split(@Country,','))))                                                                  
                                            
                                                               
and (Convert(varchar(12),BM.TripStartDate,102) between Convert(varchar(12),Convert(datetime,@ServiceFromDate,103),102) and                                                                                                                                     
 
    
      
   case when @ServiceToDate <> '' then Convert(varchar(12),Convert(datetime,@ServiceToDate,103),102)else Convert(varchar(12),Convert(datetime,@ServiceFromDate,103),102) end or (@ServiceFromDate='' and @ServiceToDate=''))                                   
  
    
     
        
          
            
      
                                                                                   
   and (Convert(varchar(12),BM.creationDate,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                                                                                                                                   
  
    
      
       
   case when @BookingToDate <> '' then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate=''))                                   
  
    
      
        
          
           
              
                
                   
                   
      --DeadlienDate                  
  and (Convert(varchar(12),BM.CancellationDeadline,102) between Convert(varchar(12),Convert(datetime,@DeadlineFromDate,103),102) and                                                                   
   case when @DeadlineFromDate <> '' then Convert(varchar(12),Convert(datetime,@DeadlineToDate,103),102)else Convert(varchar(12),Convert(datetime,@DeadlineFromDate,103),102) end                  
   or (@DeadlineFromDate='' and @DeadlineToDate=''))                      
                       
                    
  and ( SH.FkStatusId=4 AND Convert(varchar(12),SH.CreateDate,102) between Convert(varchar(12),Convert(datetime,@VoucherFromDate,103),102) and                                                                
  case when @VoucherToDate <> '' then Convert(varchar(12),Convert(datetime,@VoucherToDate,103),102)                
  else Convert(varchar(12),Convert(datetime,@VoucherFromDate,103),102) end                
  or (@VoucherFromDate='' and @VoucherToDate=''))                                                   
                  
                    
                                                                                                                          
                                                                                                                                                                                       
   and (Convert(varchar(12),SH.CreateDate,102) between Convert(varchar(12),Convert(datetime,@StatusFromDate,103),102)                 
   and case when @StatusToDate <> '' then Convert(varchar(12),Convert(datetime, @StatusToDate,103),102)                
   else Convert(varchar(12),Convert(datetime,@StatusFromDate,103),102) end or (@StatusFromDate='' and @StatusToDate=''))                                                       
                  
                                                  
                                                             
   and (                                                                                                                             
    (@ConfirmationNumber = '1' and isnull(BM.ProviderConfirmationNumber,'') != '')                                                                                                                                          
     OR                                                                                           
     (@ConfirmationNumber = '0' and isnull(BM.ProviderConfirmationNumber,'') = '')                                                       
     OR                                                                                                                                          
     (@ConfirmationNumber = '')                                                                   
   )                                    
                        
  and ((@BookingStatus='') or (SH.FkStatusId IN  (select Data from sample_split(@BookingStatus,','))))                                 
-- and ((@BookingID='') or (BM.BookingRefId=@BookingID))                                                            
  and( (@BookingID ='') or (BM.BookingRefId IN  (select Data from sample_split(@BookingID,','))) )                        
                           
                                              
  and SH.IsActive=1                
 order by BM.BookingId desc                                          
                                        
 End                                        
                                        
END 