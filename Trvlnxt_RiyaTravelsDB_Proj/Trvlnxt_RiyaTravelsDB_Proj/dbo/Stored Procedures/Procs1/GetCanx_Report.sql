    
    
      
        
  --Created by Aman W         
  -- for Hotel cancellation on 04 oct 2023        
          
CREATE PROCEDURE GetCanx_Report                          
                          
@StartDate varchar(20) = null,                              
@EndDate varchar(20)=null,                         
@BookingID varchar(40)=null,          
@SearchBy varchar(40)='0'          
as                                
 begin                          
          
  if(@SearchBy='0')        
  begin        
SELECT         
   HB.BookingReference        
  ,HB.CurrentStatus        
  ,BR.AgencyName + ISNULL(+'-'+mu.FullName,'') as 'AgencyName'        
  ,HB.LeaderTitle+' '+HB.LeaderFirstName+' '+HB.LeaderLastName  as 'TravellerName'         
--  ,HB.CheckInDate        
 -- ,HB.CheckOutDate 
 ,FORMAT(CAST(HB.CheckInDate AS datetime),'dd MMM yyyy hh:mm tt') as CheckInDate    
 ,FORMAT(CAST(HB.CheckOutDate AS datetime),'dd MMM yyyy hh:mm tt') as CheckOutDate    
 ,HB.cityName        
  ,HB.HotelName        
  ,HB.SupplierName        
  ,HB.providerConfirmationNumber 
  --,HB.CancellationDeadLine
  ,format(HB.CancellationDate , 'dd MMM yyyy hh:mm tt')  as CancellationDate      
  ,HB.SupplierRate        
  ,HB.ROEValue as 'ROE'        
  ,HB.FinalROE as 'ROE_INR'        
  ,HB.SupplierCharges        
  ,Isnull(HB.SupplierCancellationCharges,0.00) as SupplierCancellationCharges        
  ,HB.AgentCommission        
  ,HB.HotelTDS        
  ,HB.AgentRate        
  ,Isnull(HB.agentCancellationCharges,0.00) as agentCancellationCharges        
  ,HB.ModeOfCancellation        
  ,Isnull(MU.FullName,BR.AgencyName) as 'CancelledBy'        
FROM Hotel_BookMaster HB WITH (NOLOCK)                         
left join B2BRegistration BR WITH (NOLOCK) on HB.CancelledBy=BR.FKUserID        
left join mUser MU WITH (NOLOCK) on HB.CancelledBy=MU.ID         
left join Hotel_Status_History  SH WITH (NOLOCK) on HB.pkId=SH.FKHotelBookingId         
                    
WHERE           
 SH.FkStatusId=7 and SH.IsActive=1        
     and        
(( cast(HB.CancellationDate as date) between @StartDate and  @EndDate )or (@StartDate is null and @EndDate is null))                
                       
order by HB.inserteddate desc            
        
End        
        
if(@SearchBy='1')        
        
begin        
SELECT         
   HB.BookingReference        
  ,HB.CurrentStatus        
  ,BR.AgencyName + ISNULL(+'-'+mu.FullName,'') as 'AgencyName'        
  ,HB.LeaderTitle+' '+HB.LeaderFirstName+' '+HB.LeaderLastName  as 'TravellerName'         
 --  ,HB.CheckInDate        
 -- ,HB.CheckOutDate 
 ,FORMAT(CAST(HB.CheckInDate AS datetime),'dd MMM yyyy hh:mm tt') as CheckInDate    
 ,FORMAT(CAST(HB.CheckOutDate AS datetime),'dd MMM yyyy hh:mm tt') as CheckOutDate  
  ,HB.cityName        
  ,HB.HotelName        
  ,HB.SupplierName        
  ,HB.providerConfirmationNumber        
   --,HB.CancellationDeadLine
  ,format(HB.CancellationDate , 'dd MMM yyyy hh:mm tt')  as CancellationDate  ,HB.CancellationDate        
  ,HB.SupplierRate        
  ,HB.ROEValue as 'ROE'        
  ,HB.FinalROE as 'ROE_INR'        
  ,HB.SupplierCharges        
  ,Isnull(HB.SupplierCancellationCharges,0.00) as SupplierCancellationCharges        
  ,HB.AgentCommission        
  ,HB.HotelTDS        
  ,HB.AgentRate        
  ,Isnull(HB.agentCancellationCharges,0.00) as agentCancellationCharges        
  ,HB.ModeOfCancellation        
  ,MU.FullName as 'CancelledBy'        
FROM Hotel_BookMaster HB WITH (NOLOCK)                         
left join B2BRegistration BR WITH (NOLOCK) on HB.RiyaAgentID=BR.FKUserID        
left join mUser MU WITH (NOLOCK) on HB.MainAgentID=MU.ID         
left join Hotel_Status_History SH WITH (NOLOCK) on HB.pkId=SH.FKHotelBookingId         
                    
WHERE           
  SH.FkStatusId=7 and SH.IsActive=1        
     and        
(( cast(HB.inserteddate as date) between @StartDate and  @EndDate )or (@StartDate is null and @EndDate is null))                
                       
order by HB.inserteddate desc         
end        
        
if(@SearchBy='2')        
begin        
SELECT         
   HB.BookingReference        
  ,HB.CurrentStatus        
  ,BR.AgencyName + ISNULL(+'-'+mu.FullName,'') as 'AgencyName'        
  ,HB.LeaderTitle+' '+HB.LeaderFirstName+' '+HB.LeaderLastName  as 'TravellerName'         
 --  ,HB.CheckInDate        
 -- ,HB.CheckOutDate 
 ,FORMAT(CAST(HB.CheckInDate AS datetime),'dd MMM yyyy hh:mm tt') as CheckInDate    
 ,FORMAT(CAST(HB.CheckOutDate AS datetime),'dd MMM yyyy hh:mm tt') as CheckOutDate         
  ,HB.cityName        
  ,HB.HotelName        
  ,HB.SupplierName        
  ,HB.providerConfirmationNumber        
   --,HB.CancellationDeadLine
  ,format(HB.CancellationDate , 'dd MMM yyyy hh:mm tt')  as CancellationDate    
  ,HB.SupplierRate        
  ,HB.ROEValue as 'ROE'        
  ,HB.FinalROE as 'ROE_INR'        
  ,HB.SupplierCharges        
  ,Isnull(HB.SupplierCancellationCharges,0.00) as SupplierCancellationCharges        
  ,HB.AgentCommission        
  ,HB.HotelTDS        
  ,HB.AgentRate        
  ,Isnull(HB.agentCancellationCharges,0.00) as agentCancellationCharges        
  ,HB.ModeOfCancellation        
  ,MU.FullName as 'CancelledBy'        
FROM Hotel_BookMaster HB WITH (NOLOCK)                         
left join B2BRegistration BR WITH (NOLOCK) on HB.RiyaAgentID=BR.FKUserID        
left join mUser MU WITH (NOLOCK) on HB.MainAgentID=MU.ID         
left join Hotel_Status_History SH WITH (NOLOCK) on HB.pkId=SH.FKHotelBookingId         
                    
WHERE           
 SH.FkStatusId=7 and SH.IsActive=1        
   and        
          
HB.BookingReference=@BookingID         
                       
order by HB.inserteddate desc          
end        
        
ELSE        
        
SELECT         
   HB.BookingReference        
  ,HB.CurrentStatus        
  ,BR.AgencyName + ISNULL(+'-'+mu.FullName,'') as 'AgencyName'        
  ,HB.LeaderTitle+' '+HB.LeaderFirstName+' '+HB.LeaderLastName  as 'TravellerName'         
  --  ,HB.CheckInDate        
 -- ,HB.CheckOutDate 
 ,FORMAT(CAST(HB.CheckInDate AS datetime),'dd MMM yyyy hh:mm tt') as CheckInDate    
 ,FORMAT(CAST(HB.CheckOutDate AS datetime),'dd MMM yyyy hh:mm tt') as CheckOutDate         
  ,HB.cityName        
  ,HB.HotelName        
  ,HB.SupplierName        
  ,HB.providerConfirmationNumber        
   --,HB.CancellationDeadLine
  ,format(HB.CancellationDate , 'dd MMM yyyy hh:mm tt')  as CancellationDate      
  ,HB.SupplierRate        
  ,HB.ROEValue as 'ROE'        
  ,HB.FinalROE as 'ROE_INR'        
  ,HB.SupplierCharges        
  ,Isnull(HB.SupplierCancellationCharges,0.00) as SupplierCancellationCharges        
  ,HB.AgentCommission        
  ,HB.HotelTDS        
  ,HB.AgentRate        
  ,Isnull(HB.agentCancellationCharges,0.00) as agentCancellationCharges        
  ,HB.ModeOfCancellation        
  ,MU.FullName as 'CancelledBy'        
FROM Hotel_BookMaster HB WITH (NOLOCK)                         
left join B2BRegistration BR WITH (NOLOCK) on HB.RiyaAgentID=BR.FKUserID        
left join mUser MU WITH (NOLOCK) on HB.MainAgentID=MU.ID         
left join Hotel_Status_History SH WITH (NOLOCK) on HB.pkId=SH.FKHotelBookingId         
                    
WHERE           
 SH.FkStatusId=7 and SH.IsActive=1        
order by HB.inserteddate desc        
        
END        
          
          