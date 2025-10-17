-- [SS].[SightSeeingGetBookingConfirmedDetails] 'TNA0002021','',47310                                
                                
CREATE PROCEDURE [SS].[SightSeeingGetBookingConfirmedDetails]                                          
 @BookingRefId VARCHAR(200) = NULL,                                                                                                                                                
 @pkid INT = NULL ,                                                                                                                            
 @AgentId INT                                                                                                                                                                                                                                      
AS                                                                                                                                                
BEGIN                                   
                                
 IF(@pkid IS NULL OR @pkid ='')                                
 BEGIN                                 
  SET @pkid = (SELECT SSB.BookingId FROM SS.SS_BookingMaster SSB                                 
       WHERE SSB.BookingRefId = @BookingRefId)                                
 END                                
 print @pkid                                
                                
 SELECT SBM.AgentID, SBM.MainAgentID, ISNULL(SBM.SubMainAgntId, 0) AS SubMainAgntId,                                 
  SBM.BookingId, SBM.BookingRefId, SBM.BookingRate, SBM.BookingCurrency,                                
  SBM.BookingStatus, SBM.TripStartDate, SBM.TripEndDate,                           
  --SBM.CancellationDeadline 'A',                          
  ISNULL(SBM.CancellationDeadline, SBM.SupplierCancellationDate) as CancellationDate,                                 
  SBM.ProviderConfirmationNumber,                  
 Concat(SBM.Titel,'. ', SBM.Name,' ',SBM.Surname) AS PassengerName, SBM.CityName,                                 
  SBM.PassengerEmail, SBM.PassengerPhone, SBM.PaymentMode, ISNULL(SBM.ReversalStatus, 0) AS ReversalStatus,                                
  SBM.CorrelationId, SBM.AmountBeforePgCommission, SBM.AmountAfterPgCommision,SBM.OBTCNumber,SBM.CancellationPolicyText as CancellationPolicyText,                               
                                  
  BR.AgencyName, BR.AddrMobileNo AS AgentMobile,  BR.AddrEmail as AgentEmail,                                 
  AL.FirstName + ' ' + AL.LastName AS AgentName, AL.BookingCountry,                                
  AL.Address + ', ' + AL.City + ', ' + AL.Country as AgentAddress,                                                     
  AL.AgentLogoNew as AgentLogo,  ISNULL(BR.Icast,'') AS AgentIcast,                                
                                   
  SBA.ActivityName, SBA.ActivityOptionName, SBA.ActivityOptionCode, SBA.GuidingLanguage, SBA.GuidingLanguageCode,                                
  SBA.ActivityOptionTime, SBA.ActivityDesc, SBA.ActivityDetailJson,                                
  SBM.providerName, SBM.VoucherUrl, SBM.creationDate, SBM.Email ,                               
    SBA.ProviderInfo as providerInformation,                    
 sbm.providerId,                
 Sbm.FileNo as FileNo,                
 sbm.OpsRemark as OpsRemark,                
 sbm.AccRemark as AccountRemark,                
 sbm.InquiryNo as InquiryNo,                
 sbm.OBTCNumber as OBTCNo,              
 sbm.RefName as RefName,              
 sbm.TotalAdult as TotalAdult,            
 sbm.TotalChildren as TotalChildren,            
 sbm.BookingSource as BookingSource,            
 sbm.providerName,          
 sbm.providerContactNumber,         
 sbm.LocalProviderName,    
 sbm.CorporatePANVerificatioStatus as CorporatePANVerificatioStatus,  
  case                                                                                                                              
   when SBM.SubMainAgntId > 0                                                                                                       
   THEN                                                                      
   AL.FirstName                                                                                                     
   ELSE                                                                                                                      
   MU.FullName end as 'User'                                                                                                                                  
   ,MU1.FullName as 'SubUser'               
                  
 FROM SS.SS_BookingMaster SBM WITH(NOLOCK)                
  LEFT JOIN mUser MU WITH(NOLOCK) ON SBM.AgentID = MU.ID              
  Left JOIN SS.SS_BookedActivities SBA WITH(NOLOCK) ON SBM.BookingId = SBA.BookingId                                        
  --LEFT JOIN SS.SS_PaxDetails SPD WITH(NOLOCK) ON SBM.BookingId = SPD.BookingId                                  
  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON SBM.AgentID = AL.UserID                                                                                                
  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON SBM.AgentID = BR.FKUserID                                                                                                                                
  LEFT JOIN mUser MU1 WITH(NOLOCK) ON SBM.AgentID = MU1.ID                                                                                    
  LEFT JOIN B2BHotel_Commission HComm WITH(NOLOCK) ON HComm.Fk_BookId = SBM.BookingId    
  LEFT JOIN SS.SS_BookedActivities BA ON SBM.BookingId = BA.BookingId    
 WHERE SBM.BookingId = @pkid AND SBM.AgentID = @AgentId                               
 ORDER BY SBM.BookingId DESC                                
                                
                                
 SELECT cfd.valueType, cfd.Value, cfd.estimatedValue, cfd.startDate AS [start],                                
  cfd.endDate AS [end]                                
 FROM ss.SS_CancellationFeeDetail cfd  WITH(NOLOCK)                                
 WHERE cfd.BookingPkId = @pkid                                
                                
 SELECT spd.titel as title, spd.name as firstName, spd.surname as lastName, spd.age, spd.type, spd.pancardNo as panCardNumber,                                  
  spd.passportNumber, spd.nationality, spd.issuingCountry as issuingCountry, spd.LeadPax as leadPax                               
 FROM SS.SS_PaxDetails  spd WITH(NOLOCK)                                
 WHERE BookingId = @pkid       
     
 SELECT BA.questioncode as questionCode ,BA.answer as answer from SS.SS_QuestionAnswer BA  WITH(NOLOCK)    
  WHERE BookingId = @pkid     
END 