          
          

          
CREATE PROCEDURE [SS].[ActivtyPndgCanx]                                                                                              
                                                                                               
 @Id int=0,          
  @Action int=0,  
 @ModifiedBy int=0                                                        
                                  
                                 
AS                                                                                              
BEGIN                                                                                              
    begin       
  if(@Action=1)                
 select                   
 BM.BookingId,                  
 BM.BookingRefId,                  
 UPPER(BM.BookingStatus) as BookingStatus,                  
 BM.AgentID,    
 BR.AgencyName + ISNULL(+'-'+MU.FullName,'') as 'AgencyName',                  
 PD.Titel,                  
 PD.Name,                  
 PD.Surname,                  
 ( PD.Titel +' '+ PD.Name+ ' '+PD.Surname) as TravelerName,                  
 (Isnull(BM.BookingCurrency,'NA') + ' '+  CONVERT(varchar(200),BM.BookingRate)) as BookingAmount,                  
 BM.creationDate as BookingDate,                  
 BM.TripStartDate as ServiceDate,                  
 ISNULL(BM.CancellationDeadline,'') as DeadlineDate,                  
 ISnull(BM.CityName,'NA') as Destination,                  
 BA.ActivityName,                  
 UPPER(BM.providerName) as providerName,                  
 BM.ProviderConfirmationNumber,    
 Case                                                               
      when BM.PaymentMode=1 then '<span style="color:blue; font-weight:normal">Hold</span>'                            
   when BM.PaymentMode=2 then '<span style="color:Black; font-weight:normal">Credit Limit</span>'                                                              
   when  BM.PaymentMode=3 then '<span style="color:Black; font-weight:normal">Make Payment</span>'                              
   when  BM.PaymentMode=4 then '<span style="color:Black; font-weight:normal">Self Balalnce</span>'                                                              
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
 left join ss.SS_Status_History SH on BM.BookingId=SH.BookingId
                  
 where   
 BM.Pendingcancellation=1 and
 PD.PassportNumber is not null   and  SH.IsActive=1   
              
 order by BookingId desc                  
  end
  
  if(@Action=2)      
   begin      
   Update SS.SS_BookingMaster set Pendingcancellation=0 where BookingId=@Id    
   end
END 
