                    
                  
          
            
          
  --Created by Shailesh                  
                 
    --exec GetSightSeeing_Report '08-oct-2023','29-oct-2023','','0'                
                
 -- GetSightSeeing_Report '','', @BookingID='TNA0001909',@SearchBy='2'                
                
CREATE PROCEDURE [dbo].[GetSightSeeing_Report]                                    
@StartDate varchar(20) = '',                                        
@EndDate varchar(20)='',                                   
@BookingID varchar(200)='',                    
@SearchBy varchar(40)=''              
as                                          
 begin                              
 declare @paxcount int = (select count(*) from ss.SS_PaxDetails where BookingId=@BookingID )                 
                    
  if(@SearchBy='0')                  
  begin                  
  select                
                 
 BM.BookingRefId as 'BookingReference',                                                    
 BM.BookingStatus as 'CurrentStatus',                                                    
                                       
 BR.AgencyName + ISNULL(+'-'+MU.FullName,'') as 'AgencyName',                
                                                   
 ( PD.Titel +' '+ PD.Name+ ' '+PD.Surname) as 'TravellerName'                
 --,case when BM.creationDate='1753-01-01 00:00:00.000' then '2023-01-01 00:00:00.000' else ISNULL(bm.creationDate,'') end as 'Booking Date'                  
                
 --,BM.TripStartDate as 'Activity Date'                
 --,case when BM.CancellationDeadline='1753-01-01 00:00:00.000' then '2023-01-01 00:00:00.000' else ISNULL(bm.CancellationDeadline,'') end as 'DeadLineDate'                  
  -- Booking Date
,FORMAT(
    CASE 
        WHEN BM.creationDate = '1753-01-01 00:00:00.000' THEN '2023-01-01 00:00:00.000'
        ELSE BM.creationDate 
    END, 
    'dd MMM yyyy hh:mm tt'
) AS [Booking Date]

-- Activity Date
,FORMAT(BM.TripStartDate, 'dd MMM yyyy hh:mm tt') AS [Activity Date]

-- Deadline Date
,FORMAT(
    CASE 
        WHEN BM.CancellationDeadline = '1753-01-01 00:00:00.000' THEN '2023-01-01 00:00:00.000'
        ELSE BM.CancellationDeadline 
    END, 
    'dd MMM yyyy hh:mm tt'
) AS [DeadLineDate]

  
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
   ,BM.BookingRate as 'Agent Booking Amount'                
   ,BM.GstAmountonServiceCharges as 'Service Charges(including GST)'                
   ,isnull(BM.Markup,0.00) as 'Markup'                
   ,isnull(BM.ROEValue,1) as 'ROE( Supplier to Agent Currency)'                
   ,case when BM.BookingCurrency='INR' and BM.SupplierCurrency='INR' then (BM.BookingRate* 1)      
   when  BM.BookingCurrency ='AED'  then (BM.BookingRate* BM.FinalROE)      
   when  BM.BookingCurrency ='USD' and BM.SupplierCurrency='INR'  then (BM.BookingRate* BM.FinalROE)      
   else (BM.BookingRate)  end as 'Agent Rate in INR'                 
   ,PD.PancardNo as 'Pan Card No.'                
   ,PD.PanCardName as 'PanCard Name'                
   ,'' as 'Declaration'                
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
   else  isnull(BM.ROEValue,1) end as 'ROE(Supplier to Billing Currency)'       
         
   ,case when BM.BookingCurrency='AED' then  CONCAT(BM.BookingCurrency,' ',BM.SupplierRate * isnull(BM.finalroe,0))       
  when BM.BookingCurrency='USD' and BM.SupplierCurrency='INR' then CONCAT('INR',' ',BM.SupplierRate)      
  else  CONCAT(BM.BookingCurrency,' ',BM.SupplierRate * isnull(BM.ROEValue,1))      
 end as 'Supplier rate in INR/AED'      
       
   ,isnull(BM.suppliercharges,0.00) as 'Supplier Service Charges'                
   ,'NA' as 'VCC Bank Charges'                
   ,'NA' as 'VCC Card Type'                
   , CASE                 
    WHEN BM.PaymentMode = 3 THEN                 
       CONCAT(BM.BookingCurrency, ' ', BMC.TotalCommission)       
    -- CONCAT(BM.BookingCurrency, ' ', CONVERT(varchar, BM.BookingRate))                
    ELSE                 
        'NA'                
END AS  'PG Charges'                
   , case when BM.PaymentMode=3 then 'Yes' else 'No' end as 'PG Confirmation No / PG Type'                
                
                                                    
                                                    
                                                     
 from                                                    
 ss.SS_BookingMaster BM WITH (NOLOCK)                                                    
 left join SS.SS_BookedActivities BA WITH (NOLOCK) on BM.BookingId=BA.BookingId                                                    
 join SS.SS_PaxDetails PD WITH (NOLOCK) on BM.BookingId=PD.BookingId  and LeadPax=1                                                  
 left join B2BRegistration BR WITH (NOLOCK) on BM.AgentID=BR.FKUserID                                                                                                                                 
 left join mUser MU WITH (NOLOCK) on BM.MainAgentID=MU.ID                                            
-- left join Hotel_Status_Master HM on BM.BookingStatus=HM.Status                                
 left join Ss.SS_Status_History SH WITH (NOLOCK) on BM.BookingId=SH.BookingId      
 left join B2BMakepaymentCommission BMC WITH (NOLOCK) on BM.BookingId=BMC.FkBookId    
WHERE                     
 SH.IsActive=1                  
     and                  
(( cast(BM.creationDate as date) between @StartDate and  @EndDate )or (@StartDate is null and @EndDate is null))                          
                                 
order by BM.BookingId desc                      
                  
End                  
                  
 if(@SearchBy='1')                  
  begin                  
  select                
                 
 BM.BookingRefId as 'BookingReference',                                                    
 BM.BookingStatus as 'CurrentStatus',                                                    
                                       
 BR.AgencyName + ISNULL(+'-'+MU.FullName,'') as 'AgencyName',                
                                                   
 ( PD.Titel +' '+ PD.Name+ ' '+PD.Surname) as 'TravellerName'                
 --,case when BM.creationDate='1753-01-01 00:00:00.000' then '2023-01-01 00:00:00.000' else ISNULL(bm.creationDate,'') end as 'Booking Date'                  
                
 --,BM.TripStartDate as 'Activity Date'                
 --,case when BM.CancellationDeadline='1753-01-01 00:00:00.000' then '2023-01-01 00:00:00.000' else ISNULL(bm.CancellationDeadline,'') end as 'DeadLineDate'                  
  -- Booking Date
,FORMAT(
    CASE 
        WHEN BM.creationDate = '1753-01-01 00:00:00.000' THEN '2023-01-01 00:00:00.000'
        ELSE BM.creationDate 
    END, 
    'dd MMM yyyy hh:mm tt'
) AS [Booking Date]

-- Activity Date
,FORMAT(BM.TripStartDate, 'dd MMM yyyy hh:mm tt') AS [Activity Date]

-- Deadline Date
,FORMAT(
    CASE 
        WHEN BM.CancellationDeadline = '1753-01-01 00:00:00.000' THEN '2023-01-01 00:00:00.000'
        ELSE BM.CancellationDeadline 
    END, 
    'dd MMM yyyy hh:mm tt'
) AS [DeadLineDate]
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
   ,BM.BookingRate as 'Agent Booking Amount'                
   ,BM.GstAmountonServiceCharges as 'Service Charges(including GST)'                
   ,isnull(BM.Markup,0.00) as 'Markup'                
   ,isnull(BM.ROEValue,1) as 'ROE( Supplier to Agent Currency)'                
     ,case when BM.BookingCurrency='INR' and BM.SupplierCurrency='INR' then (BM.BookingRate* 1)      
   when  BM.BookingCurrency ='AED'  then (BM.BookingRate* BM.FinalROE)      
   when  BM.BookingCurrency ='USD' and BM.SupplierCurrency='INR'  then (BM.BookingRate* BM.FinalROE)      
   else (BM.BookingRate)  end as 'Agent Rate in INR'                 
   ,PD.PancardNo as 'Pan Card No.'                
   ,PD.PanCardName as 'PanCard Name'                
   ,'' as 'Declaration'                
   ,PD.PassportNumber as 'Passport No.'                
   ,case when pd.PassportNumber is null   then 'NA' else Isnull(CONVERT(varchar(20),PD.PassportIssueDate),'NA')  end as 'Date Of Issue'            
   ,case when pd.PassportNumber is null then 'NA' else ISNULL(Convert( varchar(20), PD.DateOfBirth),'NA') end as 'Date Of Birth'            
   ,case when pd.PassportNumber is null then 'NA' else ISNULL(convert(varchar(20),PD.PassportExpirationDate),'NA') end as 'Date Of Expire'              
   ,BM.providerName as 'Supplier Name'                
   ,BM.ProviderConfirmationNumber as 'Supplier Refrence No.'                
   ,BM.SupplierCurrency as 'Supplier Currency'                
   ,BM.SupplierRate as 'Supplier Booking Amount'                
   --,case when BM.BookingCurrency='AED'  Then isnull(BM.finalroe,1) else  isnull(BM.ROEValue,1) end as 'ROE(Supplier to Billing Currency)'       
   ,case when BM.BookingCurrency='AED'  Then isnull(BM.finalroe,1)      
   When BM.BookingCurrency='USD' and BM.SupplierCurrency='INR' then 1      
   else  isnull(BM.ROEValue,1) end as 'ROE(Supplier to Billing Currency)'       
   ,case when BM.BookingCurrency='AED' then  CONCAT(BM.BookingCurrency,' ',BM.SupplierRate * isnull(BM.finalroe,0))       
  when BM.BookingCurrency='USD' and BM.SupplierCurrency='INR' then CONCAT('INR',' ',BM.SupplierRate)      
  else  CONCAT(BM.BookingCurrency,' ',BM.SupplierRate * isnull(BM.ROEValue,1))      
 end as 'Supplier rate in INR/AED'                 
   ,isnull(BM.suppliercharges,0.00) as 'Supplier Service Charges'                
   ,'NA' as 'VCC Bank Charges'                
   ,'NA' as 'VCC Card Type'                
   , CASE                 
    WHEN BM.PaymentMode = 3 THEN                 
        CONCAT(BM.BookingCurrency, ' ', BMC.TotalCommission)       
  --CONCAT(BM.BookingCurrency, ' ', CONVERT(varchar, BM.BookingRate))                
    ELSE                 
        'NA'                
END AS  'PG Charges'                
   , case when BM.PaymentMode=3 then 'Yes' else 'No' end as 'PG Confirmation No / PG Type'                
                
                                                    
                                                    
                                                     
 from                                                    
 ss.SS_BookingMaster BM WITH (NOLOCK)                                                     
 left join SS.SS_BookedActivities BA WITH (NOLOCK) on BM.BookingId=BA.BookingId                                                    
 join SS.SS_PaxDetails PD WITH (NOLOCK) on BM.BookingId=PD.BookingId  and LeadPax=1                      
 left join B2BRegistration BR WITH (NOLOCK) on BM.AgentID=BR.FKUserID                                                                                                                                 
 left join mUser MU WITH (NOLOCK) on BM.MainAgentID=MU.ID                                            
-- left join Hotel_Status_Master HM on BM.BookingStatus=HM.Status                                
 left join Ss.SS_Status_History SH WITH (NOLOCK) on BM.BookingId=SH.BookingId      
  left join B2BMakepaymentCommission BMC WITH (NOLOCK) on BM.BookingId=BMC.FkBookId    
    
WHERE                     
 SH.IsActive=1                  
     and                  
(( cast(BM.creationDate as date) between @StartDate and  @EndDate )or (@StartDate is null and @EndDate is null))                          
                                 
order by BM.BookingId desc                         
                  
End                  
                
if(@SearchBy='2')                  
  begin                  
 select                
                 
 BM.BookingRefId as 'BookingReference',                                                    
 BM.BookingStatus as 'CurrentStatus',                                     
                                       
 BR.AgencyName + ISNULL(+'-'+MU.FullName,'') as 'AgencyName',                
                                                   
 ( PD.Titel +' '+ PD.Name+ ' '+PD.Surname) as 'TravellerName'                
--,case when BM.creationDate='1753-01-01 00:00:00.000' then '2023-01-01 00:00:00.000' else ISNULL(bm.creationDate,'') end as 'Booking Date'                  
                
 --,BM.TripStartDate as 'Activity Date'                
 --,case when BM.CancellationDeadline='1753-01-01 00:00:00.000' then '2023-01-01 00:00:00.000' else ISNULL(bm.CancellationDeadline,'') end as 'DeadLineDate'                  
  -- Booking Date
,FORMAT(
    CASE 
        WHEN BM.creationDate = '1753-01-01 00:00:00.000' THEN '2023-01-01 00:00:00.000'
        ELSE BM.creationDate 
    END, 
    'dd MMM yyyy hh:mm tt'
) AS [Booking Date]

-- Activity Date
,FORMAT(BM.TripStartDate, 'dd MMM yyyy hh:mm tt') AS [Activity Date]

-- Deadline Date
,FORMAT(
    CASE 
        WHEN BM.CancellationDeadline = '1753-01-01 00:00:00.000' THEN '2023-01-01 00:00:00.000'
        ELSE BM.CancellationDeadline 
    END, 
    'dd MMM yyyy hh:mm tt'
) AS [DeadLineDate]         
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
   ,BM.BookingRate as 'Agent Booking Amount'                
   ,BM.GstAmountonServiceCharges as 'Service Charges(including GST)'                
   ,isnull(BM.Markup,0.00) as 'Markup'                
   ,isnull(BM.ROEValue,1) as 'ROE( Supplier to Agent Currency)'                
     ,case when BM.BookingCurrency='INR' and BM.SupplierCurrency='INR' then (BM.BookingRate* 1)      
   when  BM.BookingCurrency ='AED'  then (BM.BookingRate* BM.FinalROE)      
   when  BM.BookingCurrency ='USD' and BM.SupplierCurrency='INR'  then (BM.BookingRate* BM.FinalROE)      
   else (BM.BookingRate)  end as 'Agent Rate in INR'                
   ,PD.PancardNo as 'Pan Card No.'                
   ,PD.PanCardName as 'PanCard Name'                
   ,'' as 'Declaration'                
   ,PD.PassportNumber as 'Passport No.'                
   ,case when pd.PassportNumber is null   then 'NA' else Isnull(CONVERT(varchar(20),PD.PassportIssueDate),'NA')  end as 'Date Of Issue'            
   ,case when pd.PassportNumber is null then 'NA' else ISNULL(Convert( varchar(20), PD.DateOfBirth),'NA') end as 'Date Of Birth'            
   ,case when pd.PassportNumber is null then 'NA' else ISNULL(convert(varchar(20),PD.PassportExpirationDate),'NA') end as 'Date Of Expire'              
   ,BM.providerName as 'Supplier Name'                
   ,BM.ProviderConfirmationNumber as 'Supplier Refrence No.'                
   ,BM.SupplierCurrency as 'Supplier Currency'                
   ,BM.SupplierRate as 'Supplier Booking Amount'                
   --,case when BM.BookingCurrency='AED'  Then isnull(BM.finalroe,1) else  isnull(BM.ROEValue,1) end as 'ROE(Supplier to Billing Currency)'       
   ,case when BM.BookingCurrency='AED'  Then isnull(BM.finalroe,1)      
   When BM.BookingCurrency='USD' and BM.SupplierCurrency='INR' then 1      
   else  isnull(BM.ROEValue,1) end as 'ROE(Supplier to Billing Currency)'       
   --, Concat(BM.SupplierCurrency,' ',BM.SupplierRate) as 'Supplier rate in INR/AED'        
   ,case when BM.BookingCurrency='AED' then  CONCAT(BM.BookingCurrency,' ',BM.SupplierRate * isnull(BM.finalroe,0))       
  when BM.BookingCurrency='USD' and BM.SupplierCurrency='INR' then CONCAT('INR',' ',BM.SupplierRate)      
  else  CONCAT(BM.BookingCurrency,' ',BM.SupplierRate * isnull(BM.ROEValue,1))      
 end as 'Supplier rate in INR/AED'      
   ,isnull(BM.suppliercharges,0.00) as 'Supplier Service Charges'                
   ,'NA' as 'VCC Bank Charges'                
   ,'NA' as 'VCC Card Type'                
   , CASE                 
    WHEN BM.PaymentMode = 3 THEN       
 CONCAT(BM.BookingCurrency, ' ', BMC.TotalCommission)       
       -- CONCAT(BM.BookingCurrency, ' ', CONVERT(varchar, BM.BookingRate))                
    ELSE            
        'NA'                
END AS  'PG Charges'                
   , case when BM.PaymentMode=3 then 'Yes' else 'No' end as 'PG Confirmation No / PG Type'                
                
                                                    
                                                    
                                                     
 from                                                    
 ss.SS_BookingMaster BM WITH (NOLOCK)                                                     
 left join SS.SS_BookedActivities BA WITH (NOLOCK) on BM.BookingId=BA.BookingId                                                    
 join SS.SS_PaxDetails PD WITH (NOLOCK) on BM.BookingId=PD.BookingId  and LeadPax=1                                                  
 left join B2BRegistration BR WITH (NOLOCK) on BM.AgentID=BR.FKUserID                                                                                                                                 
 left join mUser MU WITH (NOLOCK) on BM.MainAgentID=MU.ID                                            
-- left join Hotel_Status_Master HM on BM.BookingStatus=HM.Status                                
 left join Ss.SS_Status_History SH WITH (NOLOCK) on BM.BookingId=SH.BookingId     
  left join B2BMakepaymentCommission BMC WITH (NOLOCK) on BM.BookingId=BMC.FkBookId    
    
WHERE                     
 SH.IsActive=1   
 and (( cast(BM.creationDate as date) between @StartDate and  @EndDate )or (@StartDate is null and @EndDate is null))
 and BM.BookingRefId=@BookingID	             
                       
                          
      
order by BM.BookingId desc                  
                    
                  
End                  
END 