                    
                          
               --   [SS].[SightSeeingSearchdata]  100,'TNA0000088',33435     
                      
                      
CREATE PROCEDURE [SS].[SightSeeingSearchdata]                                                                                                                                  
                                                                                                                                   
                                          
 @PkId int=0,     
 @BookingRefId varchar,      
 @AgentId int=0      
      
AS                                                                                                                                  
BEGIN                           
                        
                       
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
 Isnull(BM.totalPax,0)  as PaxCount,                                            
ISNULL( PD.Surname,'NA') AS   Surname,                                                   
iSNULL((PD.Titel +' '+ PD.Name+ ' '+PD.Surname),'NA') as TravelerName,                                         
isnull(PD.PancardNo,'NA')  as 'PancardNo',                                        
isnull(PD.PassportNumber,'NA') as 'PassportNumber',                                        
 (Isnull(BM.BookingCurrency,'NA') + ' '+  CONVERT(varchar(200),BM.BookingRate)) as BookingAmount,                                                  
 BM.creationDate as BookingDate,                                                      
 BM.TripStartDate as ServiceInDate,                                             
 BM.TripEndDate as ServiceOutDate,                                            
 ISnull(BM.OBTCNumber,'NA')  as OBTCNumber ,                                                              
  ISNULL(BM.CancellationDeadline,'') as DeadlineDate,                                                                   
 ISnull(BM.CityName,'NA') as Destination,                                                      
 BA.ActivityName,                                                          
 Isnull(BR.BranchCode,'NA') as 'BranchName' ,                                         
                                         
 ---Supplier--                                        
                       
 BM.providerName,                       
                      
 case when BM.ProviderConfirmationNumber is null then 'NA' when BM.ProviderConfirmationNumber='' then 'NA'                       
 else BM.ProviderConfirmationNumber end as ProviderConfirmationNumber,                      
                      
Isnull(BR.AddrContactNo,'NA') as AgentcntNumber,                           
 Concat(BM.SupplierCurrency,' ',BM.SupplierRate) as SupplierRate,                                        
                 
 ---Rate Information--                                        
 BM.BookingRate,              
 BM.BookingCurrency,                                        
 Concat(BM.BookingCurrency,' ',BM.AmountBeforePgCommission,'(',BM.SupplierCurrency,' ','-->',BM.BookingCurrency,'=',ISnull(BM.ROEValue,1),')',' ','Markup:',BM.Markup,'%') as AgentRate,                                        
                      
 '--' as ServiceTax,                         
                       
 case when BM.PaymentMode=3 then 'Yes' else 'No' end as PaymentGathway,             
 CASE                       
    WHEN BM.PaymentMode = 3 THEN                       
        CONCAT(BM.BookingCurrency, ' ', CONVERT(varchar, BM.BookingRate))                      
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
 ISNULL(BM.VoucherUrl,'NA') as 'VaiterVoucher',                            
ISNULL (SH.FkStatusId,0) as 'FKCurrentStatus',                
isnull(BM.RoeValue,1) as 'ROE',               
BM.PaymentMode as 'PaymentMode',            
BM.MainAgentID as 'MainAgentid',            
MC.ID as 'Agentcountry', 
isnull(BM.SubMainAgntId,0) as SubMainAgntId,
Isnull(BM.ReversalStatus ,0) as ReversalStatus,
case when mc.ID=1 then 'IN' when Mc.ID=2 then 'US'
when MC.ID=3 then 'CA' when mc.ID=4 then 'AE' when mc.ID=6 then 'UK'
else 'NA' end as 'bookingCountry'

                                      
                            
                                        
                                                     
 from                                                      
 ss.SS_BookingMaster BM                                                       
 left join SS.SS_BookedActivities BA on BM.BookingId=BA.BookingId                                              
left join SS.SS_PaxDetails PD on BM.BookingId=PD.BookingId and LeadPax=1                                           
 left join B2BRegistration BR on BM.AgentID=BR.FKUserID                                             
 left join Hotel_CountryMaster CM on PD.Nationality =CM.CountryCode                                             
 left join mUser MU on BM.MainAgentID=MU.ID                                              
 left join Hotel_Status_Master HM on BM.BookingStatus=HM.Status                              
 left join Ss.SS_Status_History SH on BM.BookingId=SH.BookingId             
 left join SS.mcountry MC on BM.BookingCurrency=MC.Currencycode            
                                                      
 where                                                   
                                                                              
  (BM.BookingId = @pkid or @pkid=null or(BM.BookingRefId=@BookingRefId and @BookingRefId!='') or @BookingRefId=null) and SH.IsActive=1 and AgentID=@AgentId                                                                                                    
 
     
      
                          
END 