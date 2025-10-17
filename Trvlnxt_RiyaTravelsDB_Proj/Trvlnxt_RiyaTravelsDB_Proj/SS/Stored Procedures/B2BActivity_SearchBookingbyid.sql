--sp_helptext 'SS.B2BActivity_SearchBookingbyid' 855        
        
          
                            
                     --  EXEC [ss].[B2BActivity_SearchBookingbyid]   855          
                        --EXEC [ss].[B2BActivity_SearchBookingbyid]   1030          
                              
                              
CREATE PROCEDURE [SS].[B2BActivity_SearchBookingbyid]                                                                                                                                          
        
 @Id int=0        
                                                                   
AS                                                                                                                                          
BEGIN                                   
                                
 declare @paxcount int = (select count(*) from ss.SS_PaxDetails where BookingId=@Id)                                  
                               
 select                                                               
 BM.BookingId ,                                                              
 BM.BookingRefId,                                                              
 BM.BookingStatus as BookingStatus ,                                                              
 --BM.AgentID,                        
 BM.AgentID as 'SSAgentId',                          
                               
 ---Pax Details                              
 BM.PassengerEmail,                                                    
 BM.PassengerPhone,                                                
 MU.FullName as AgentName,                                                
 BR.AgencyName +'-'+BR.Icast  as 'AgencyName',                                            
 PD.Titel,                                                              
 PD.Name,                                                     
 BM.CorrelationId,                                                
 coalesce(BM.CancellationPolicyText,'') as 'CancellationPolicy',                                                    
 ISnull(BM.CityName,'NA') as 'CityName',                                                    
 isnull(BM.CountryCode,'NA') as 'CountryName',                                                    
 Isnull(CM.CountryName,'NA') as 'PaxNationality',                                                    
 Isnull(@paxcount,PD.totalPax)  as PaxCount,                                                    
ISNULL( PD.Surname,'NA') AS   Surname,                                                           
iSNULL((PD.Titel +' '+ PD.Name+ ' '+PD.Surname),'NA') as TravelerName,                                                 
isnull(PD.PancardNo,'NA')  as 'PancardNo',                                                
isnull(PD.PassportNumber,'NA') as 'PassportNumber',                                                
 (Isnull(BM.BookingCurrency,'NA') + ' '+  CONVERT(varchar(200),BM.BookingRate)) as BookingAmount,                                                          
 --BM.creationDate as BookingDate,
 FORMAT(CAST(BM.creationDate AS datetime), 'dd MMM yyyy HH:mm tt') as BookingDate,
-- BM.TripStartDate as ServiceInDate,
FORMAT(CAST(BM.TripStartDate AS datetime), 'dd MMM yyyy HH:mm tt') as ServiceInDate,
-- BM.TripEndDate as ServiceOutDate, 
FORMAT(CAST(BM.TripEndDate AS datetime), 'dd MMM yyyy HH:mm tt') as ServiceOutDate,

 ISnull(BM.OBTCNumber,'NA')  as OBTCNumber ,                                                                      
  --ISNULL(BM.CancellationDeadline,'') as DeadlineDate,
  FORMAT(CAST(BM.CancellationDeadline AS datetime), 'dd MMM yyyy HH:mm tt') as DeadlineDate,

 ISnull(BM.CityName,'NA') as Destination,                                                              
 case when Ba.ActivityOptionName is null then  BA.ActivityName else BA.ActivityName +' '+'<br/>' +'('+' '+ BA.ActivityOptionName+' '+')' END   as 'ActivityName' ,                                                                  
 Isnull(BR.BranchCode,'NA') as 'BranchName',           
 '-' as ProviderContactNo  ,     
                                                 
 ---Supplier--            
                               
 BM.providerName,                               
                              
 case when BM.ProviderConfirmationNumber is null then 'NA' when BM.ProviderConfirmationNumber='' then 'NA'                          
 else BM.ProviderConfirmationNumber end as ProviderConfirmationNumber,                              
                              
Isnull(BR.AddrContactNo,'NA') as AgentcntNumber,                                   
 Concat(BM.SupplierCurrency,' ',BM.SupplierRate) as SupplierRate,                                                
                                                
 ---Rate Information--                               
 BM.BookingRate,                                                
 BM.BookingCurrency,                       
 Concat(BM.BookingCurrency,' ',case when BM.AmountAfterPgCommision=0 then BM.BookingRate else BM.AmountAfterPgCommision end,'(',BM.SupplierCurrency,' ','-->',BM.BookingCurrency,'=',ISnull(BM.ROEValue,1),')',' ','Markup:',BM.Markup) as AgentRate,         
  
     
     
                                           
                              
 '--' as ServiceTax,                                 
                               
 case when BM.PaymentMode=3 then 'Yes' else 'No' end as PaymentGathway,                     
 CASE                               
    WHEN BM.PaymentMode = 3 THEN                               
        CONCAT(BM.BookingCurrency, ' ',convert(varchar,BM.AmountAfterPgCommision-BM.AmountBeforePgCommission))                              
    ELSE                               
        'NA'                              
END AS PaymentGathwayCharges                              
                              
                              
,  Isnull(BA.ActivityOptionTime,'-') as 'ActivitystartTime',                                            
   isnull(BA.GuidingLanguage,'-') as 'TourLanguage',                                            
   isnull(BM.ROEValue,1) as  ROEValue,                                 
  ISNULL(BM.RefName,'NA') as agentRefName,                                            
  ISnull(BM.Email,'NA') as 'SalesMgr' ,                                  
   'NA' as 'Consultant',                                  
  (Isnull(BM.BookingCurrency,'NA') + ' '+  CONVERT(varchar(200),BM.BookingRate)) as BookingAmount ,                                        
   BM.SupplierCanxCharges as 'SupplierCancellationChrgs',                        
  BM.SupplierCanxAgentChrge as 'SupplierCancAgntChrge',                        
  BM.AgentCanxCharges as 'AgentCancellationChrge',                               
  BM.CancellationRemark as 'CancellationRemark',                        
  BM.PostCancellationCharges as 'postCancellationCharges',                                    
  -------- Voucher---                                    
 ISNULL(BM.VoucherUrl,'https://uat.cloud.trvlnxt.com/sightseeing/consoleMail/VoucherCallFromConsole?orderid='+BM.BookingRefId+'&AgentId='+cast(BM.AgentID as varchar)+'&PkId='+cast(BM.BookingId as varchar)+'&isallowed=1') as 'VaiterVoucher',               
  
    
     
                      
ISNULL (SH.FkStatusId,0) as 'FKCurrentStatus',                        
isnull(BM.RoeValue,1) as 'ROE',                       
BM.PaymentMode as 'B2Bpaymentmode',                    
BM.MainAgentID as 'MainAgentid',                    
MC.ID as 'Agentcountry'   
-- panverification --  
,case when pd.LeadPax=1 then Isnull(PD.Titel+' '+Pd.[Name]+' '+PD.Surname,'NA')  end as LeadpaxName  
,case when pd.LeadPax=1 then Isnull(PD.PancardNo,'NA')  end as Pancard  
,case when pd.LeadPax=1 then Isnull(PD.PanCardName,'NA')  end as PanCardName  
                                              
                                    
                                                
                                                             
 from                                                              
 ss.SS_BookingMaster BM                                                              
 left join SS.SS_BookedActivities BA on BM.BookingId=BA.BookingId                                                      
left join SS.SS_PaxDetails PD on BM.BookingId=PD.BookingId                                                    
 left join B2BRegistration BR on BM.AgentID=BR.FKUserID                                                     
 left join Hotel_CountryMaster CM on PD.Nationality =CM.CountryCode                                                     
 left join mUser MU on BM.MainAgentID=MU.ID                                                      
 left join Hotel_Status_Master HM on BM.BookingStatus=HM.Status                                      
 left join Ss.SS_Status_History SH on BM.BookingId=SH.BookingId                     
 left join SS.mcountry MC on BM.BookingCurrency=MC.Currencycode               
-- left join B2BMakepaymentCommission BMC on BM.BookingId=BMC.FkBookId              
                                                              
 where                                                           
   (BM.BookingId = @Id or @Id=0)                                      
  and SH.IsActive=1                                    
      
select q.BookingId,Concat( p.Name,' ' ,p.Surname) as info,isnull(label,REPLACE(questioncode,'_','') )as 'Question'    
,case ISDATE(answer)when 1 then convert(varchar, cast(answer as date),103) else answer end as answer    
from ss.SS_QuestionAnswer q left join SS.SS_PaxDetails p       
on p.PKId=q.PaxID      
--on p.BookingId=q.BookingId     
    
where q.BookingId=@Id      
END 