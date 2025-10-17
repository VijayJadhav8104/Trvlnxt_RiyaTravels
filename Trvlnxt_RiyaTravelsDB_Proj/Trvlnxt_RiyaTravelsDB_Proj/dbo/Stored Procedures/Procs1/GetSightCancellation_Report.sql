                
              
  --Created by Shailesh              
             
    --exec GetSightCancellation_Report '01-sep-2023','09-sep-2023','0'            
            
 --GetSightCancellation_Report null,null,'','0'            
            
CREATE PROCEDURE GetSightCancellation_Report                               
@StartDate varchar(20) = null,                                    
@EndDate varchar(20)=null,                               
@BookingID varchar(40)=null,                
@SearchBy varchar(40)='0'           
          
as                                      
 begin                          
                
  if(@SearchBy='0')              
  begin              
 select                                                 
 --BM.BookingId,                                                
             
 BM.BookingRefId as 'Booking Id',                                                
 BM.BookingStatus as 'Booking Status',                                                
                                   
 BR.AgencyName + ISNULL(+'-'+MU.FullName,'') as 'AgencyName',            
                                               
 ( PD.Titel +' '+ PD.Name+ ' '+PD.Surname) as 'TravellerName'            
 --,case when BM.creationDate='1753-01-01 00:00:00.000' then '2023-01-01 00:00:00.000' else ISNULL(bm.creationDate,'NA') end as 'Booking Date'              
            
 --,BM.TripStartDate as 'Activity Date'            
 ----,ISNULL(BM.CancellationDeadline,'') as 'DeadLineDate'            
 --,case when BM.CancellationDeadline='1753-01-01 00:00:00.000' then '2023-01-01 00:00:00.000' else ISNULL(bm.CancellationDeadline,'NA') end as 'DeadLineDate'              
 
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
    ,BM.providerName as 'Supplier Name'            
   ,BM.ProviderConfirmationNumber as 'Supplier Refrence No.'          
           
   ,isnull(BM.BookingRate,0.00) as 'Agent Booking Amount'            
   ,BM.BookingCurrency as 'Agent Currency'          
   ,BM.CancellationDate as 'Cancellation Date'          
   ,isnull(BM.SupplierRate,0.00) as 'Supplier Rate'          
    ,BM.SupplierCurrency as 'Supplier Currency'           
 ,isnull(BM.ROEValue,1) as 'ROE'          
 ,bm.finalroe as 'Final Roe'          
  ,isnull(bm.SupplierCanxCharges,0.00)  as 'Supplier Cancellation Charges (Local Currency)'          
  ,isnull(BM.SupplierCanxAgentChrge,0.00) as 'Supplier Cancellation Charges (Agent Currency)'          
  ,isnull(AgentCanxCharges,0.00) as 'Agent Cancellation Charges (Agent Currency)'          
  ,BM.ModeOfCancellation as 'Mode Of Cancellation'          
  ,MU.FullName as 'Cancelled By'                  
                                                
                                                 
                                                 
 from                                                
 ss.SS_BookingMaster BM WITH (NOLOCK)                                                
 left join SS.SS_BookedActivities BA WITH (NOLOCK) on BM.BookingId=BA.BookingId                                                
 join SS.SS_PaxDetails PD WITH (NOLOCK) on BM.BookingId=PD.BookingId   and LeadPax=1                                               
 left join B2BRegistration BR WITH (NOLOCK) on BM.AgentID=BR.FKUserID                                                                                                                             
 left join mUser MU WITH (NOLOCK) on BM.MainAgentID=MU.ID                                        
 --left join Hotel_Status_Master HM on BM.BookingStatus=HM.Status                            
 left join Ss.SS_Status_History SH WITH (NOLOCK) on BM.BookingId=SH.BookingId                            
WHERE             
BM.BookingStatus='Cancelled' and    
 SH.IsActive=1              
     and              
(( cast(BM.creationDate as date) between @StartDate and  @EndDate )or (@StartDate is null and @EndDate is null))                      
                             
order by BM.creationDate desc                  
              
End       
              
 if(@SearchBy='1')              
            
  begin              
select                                                 
 --BM.BookingId,                                                
             
 BM.BookingRefId as 'Booking Id',                                                
 BM.BookingStatus as 'Booking Status',                                                
                                   
 BR.AgencyName + ISNULL(+'-'+MU.FullName,'') as 'AgencyName',            
                                               
 ( PD.Titel +' '+ PD.Name+ ' '+PD.Surname) as 'TravellerName'            
  --,case when BM.creationDate='1753-01-01 00:00:00.000' then '2023-01-01 00:00:00.000' else ISNULL(bm.creationDate,'NA') end as 'Booking Date'              
            
 --,BM.TripStartDate as 'Activity Date'            
 ----,ISNULL(BM.CancellationDeadline,'') as 'DeadLineDate'            
 --,case when BM.CancellationDeadline='1753-01-01 00:00:00.000' then '2023-01-01 00:00:00.000' else ISNULL(bm.CancellationDeadline,'NA') end as 'DeadLineDate'              
 
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
    ,BM.providerName as 'Supplier Name'            
   ,BM.ProviderConfirmationNumber as 'Supplier Refrence No.'          
           
   ,isnull(BM.BookingRate,0.00) as 'Agent Booking Amount'            
   ,BM.BookingCurrency as 'Agent Currency'          
   ,BM.CancellationDate as 'Cancellation Date'          
   ,isnull(BM.SupplierRate,0.00) as 'Supplier Rate'          
    ,BM.SupplierCurrency as 'Supplier Currency'           
 ,isnull(BM.ROEValue,1) as 'ROE'          
 ,bm.finalroe as 'ROE Inr'          
  ,isnull(bm.SupplierCanxCharges,0.00)  as 'Supplier Cancellation Charges (Local Currency)'          
  ,isnull(BM.SupplierCanxAgentChrge,0.00) as 'Supplier Cancellation Charges (Agent Currency)'          
  ,isnull(AgentCanxCharges,0.00) as 'Agent Cancellation Charges (Agent Currency)'          
  ,BM.ModeOfCancellation as 'Mode Of Cancellation'          
  ,MU.FullName as 'Cancelled By'                  
                                                
                                                 
                                                 
 from                                                
 ss.SS_BookingMaster BM WITH (NOLOCK)                                                
 left join SS.SS_BookedActivities BA WITH (NOLOCK) on BM.BookingId=BA.BookingId                                                
 join SS.SS_PaxDetails PD WITH (NOLOCK) on BM.BookingId=PD.BookingId  and pd.LeadPax=1                                                 
 left join B2BRegistration BR WITH (NOLOCK) on BM.AgentID=BR.FKUserID                                                                                                                             
 left join mUser MU WITH (NOLOCK) on BM.MainAgentID=MU.ID                                        
 --left join Hotel_Status_Master HM on BM.BookingStatus=HM.Status                            
 left join Ss.SS_Status_History SH WITH (NOLOCK) on BM.BookingId=SH.BookingId                            
WHERE             
BM.BookingStatus='Cancelled' and    
 SH.IsActive=1              
     and              
(( cast(BM.CancellationDate as date) between @StartDate and  @EndDate )or (@StartDate is null and @EndDate is null))                      
                             
order by BM.creationDate desc                  
              
End             
            
if(@SearchBy='2')             
  begin              
select                                                 
 --BM.BookingId,                                                
             
 BM.BookingRefId as 'Booking Id',                                                
 BM.BookingStatus as 'Booking Status',                                                
                                   
 BR.AgencyName + ISNULL(+'-'+MU.FullName,'') as 'AgencyName',            
                                               
 ( PD.Titel +' '+ PD.Name+ ' '+PD.Surname) as 'TravellerName'            
 --BM.creationDate as 'Booking Date'            
 --,case when BM.creationDate='1753-01-01 00:00:00.000' then '2023-01-01 00:00:00.000' else ISNULL(bm.creationDate,'NA') end as 'Booking Date'              
            
 --,BM.TripStartDate as 'Activity Date'            
 ----,ISNULL(BM.CancellationDeadline,'') as 'DeadLineDate'            
 --,case when BM.CancellationDeadline='1753-01-01 00:00:00.000' then '2023-01-01 00:00:00.000' else ISNULL(bm.CancellationDeadline,'NA') end as 'DeadLineDate'              
 
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
    ,BM.providerName as 'Supplier Name'            
   ,BM.ProviderConfirmationNumber as 'Supplier Refrence No.'          
           
   ,isnull(BM.BookingRate,0.00) as 'Agent Booking Amount'            
   ,BM.BookingCurrency as 'Agent Currency'          
   ,BM.CancellationDate as 'Cancellation Date'          
   ,isnull(BM.SupplierRate,0.00) as 'Supplier Rate'          
    ,BM.SupplierCurrency as 'Supplier Currency'           
 ,isnull(BM.ROEValue,1) as 'ROE'          
 ,bm.finalroe as 'ROE Inr'          
  ,isnull(bm.SupplierCanxCharges,0.00)  as 'Supplier Cancellation Charges (Local Currency)'          
  ,isnull(BM.SupplierCanxAgentChrge,0.00) as 'Supplier Cancellation Charges (Agent Currency)'          
  ,isnull(AgentCanxCharges,0.00) as 'Agent Cancellation Charges (Agent Currency)'          
  ,BM.ModeOfCancellation as 'Mode Of Cancellation'          
  ,MU.FullName as 'Cancelled By'                  
                                                
                                                 
                                                 
 from                                                
 ss.SS_BookingMaster BM WITH (NOLOCK)                                                
 left join SS.SS_BookedActivities BA WITH (NOLOCK) on BM.BookingId=BA.BookingId                                                
 join SS.SS_PaxDetails PD  WITH (NOLOCK) on BM.BookingId=PD.BookingId  and pd.LeadPax=1                                             
 left join B2BRegistration BR WITH (NOLOCK) on BM.AgentID=BR.FKUserID                                                                                                                             
 left join mUser MU WITH (NOLOCK) on BM.MainAgentID=MU.ID                                        
 --left join Hotel_Status_Master HM on BM.BookingStatus=HM.Status                            
 left join Ss.SS_Status_History SH WITH (NOLOCK) on BM.BookingId=SH.BookingId                            
WHERE             
BM.BookingStatus='Cancelled' and    
 SH.IsActive=1              
     and      
      
  BM.BookingRefId=@BookingID    
--(( cast(BM.creationDate as date) between @StartDate and  @EndDate )or (@StartDate is null and @EndDate is null))                      
                             
--order by BM.creationDate desc                         
--order by BM.creationDate desc                  
              
End              
END 