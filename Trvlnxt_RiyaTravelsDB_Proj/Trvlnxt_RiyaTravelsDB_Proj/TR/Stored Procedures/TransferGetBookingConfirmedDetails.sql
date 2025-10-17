-- [TR].[TransferGetBookingConfirmedDetails] 'TNC0000236','236',21956                                
--use RiyaTravels                            
                            
--TR.TransferGetBookingConfirmedDetails  'TNC0000081', '86',  51379                            
                      
CREATE PROCEDURE [TR].[TransferGetBookingConfirmedDetails]                                          
 @BookingRefId VARCHAR(200) = NULL,                                                                                                                                                
 @pkid VARCHAR(200) = NULL ,                                                                                                                            
 @AgentId INT                                                                                                                                                                                                                                      
AS                                                                                                                                                
BEGIN                                   
                                
 IF(@pkid IS NULL OR @pkid ='')                                
 BEGIN                                 
  SET @pkid = (SELECT SSB.BookingId FROM TR.TR_BookingMaster SSB                                 
       WHERE SSB.BookingRefId = @BookingRefId)                                
 END                                
 print @pkid                                
                                
 SELECT SBM.Cust_Id as CustId, SBM.SupplierCurrency, SBM.SupplierRate, SBM.AgentId, SBM.MainAgentId, ISNULL(SBM.SubMainAgntId, 0) AS SubMainAgntId,                                 
  SBM.BookingId, SBM.BookingRefId, SBM.BookingRate, SBM.BookingCurrency,                                
  SBM.BookingStatus, SBM.TripStartDate, FORMAT(SBM.TripStartDate, 'dddd, dd MMMM, yyyy') as JourneyStartDate, FORMAT(SBM.TripStartDate, 'HH:mm') as TripStartTime,                 
  SBM.TripEndDate, ISNULL(SBM.CancellationDeadline, SBM.modifiedDate) as CancellationDate,                                 
  SBM.ProviderConfirmationNumber, SBM.CommissionPercent, SBM.CommissionAmount,                 
  SBM.AgentCurrencyCode ,                
  SBM.AgentDiscountPrice,                 
  SPD.Titel + ' ' + SPD.Name + ' ' + SPD.Surname AS PassengerName,                 
  SPD.Contact as PassengerPhone,                 
  SPD.Email as PassengerEmail,                 
  SPD.TotalPax AS Passesngers,                      
  SBM.CityName,                                 
  SBM.PaymentMode, ISNULL(SBM.ReversalStatus, 0) AS ReversalStatus,                                
  SBM.CorrelationId, SBM.AmountBeforePgCommission, SBM.AmountAfterPgCommision,                        
  ISNULL(SBM.OBTCNo,'') as OBTCNo ,SPD.Email,  SPD.Contact,                         
  SBM.ProviderConfirmationNumber,  SBM.SupplierCurrency, SBM.TotalAdult, SBM.TotalChildren, SBM.CategoryVehicleType,                      
  SBM.PickInfo, SBA.Luggage, SBA.TotalLuggage, SBA.Distance, SBM.Refundable, SBM.EstimatedTime, SBM.CancellationPolicyText, SBM.PickInfo,                      
  SBM.CancellationPolicyText as CancellationPolicy, SBM.PickInfo, SBM.ProviderConfirmationNumber,             
  SBM.ChildSeat,SBM.Children1Age,SBM.Children2Age,SBM.ChildAge,            
   SBM.FlightCode AS FlightCode,           
   SBM.FlightArrivalTime AS FlightArrivalTime,          
   SBM.SpecialRequests AS SpecialRequests,          
  BR.AgencyName, BR.AddrMobileNo AS AgentMobile,  BR.AddrEmail as AgentEmail,                                 
  AL.FirstName + ' ' + AL.LastName AS AgentName, AL.BookingCountry,                                
  AL.Address + ', ' + AL.City + ', ' + AL.Country as AgentAddress,                                                     
  AL.AgentLogoNew as AgentLogo,  
  SBM.FileNo as FileNo,
   SBM.InquiryNo as InquiryNo,
   SBM.OpsRemark as OpsRemark,
   SBM.AccRemark as AccountRemark,
  SBA.CarName, SBA.CarName,                               
  SBA.CarDesc, SBA.CarDetailJson, SBA.PricingPackageType,                                
  SBM.ProviderName, SBM.VoucherUrl, SBM.creationDate,                        
  SBA.CarName, SBA.CarDesc,SBA.CarCode, SBM.PickupLocation, SBM.DropOffLocation,                        
  BR.AgencyName, BR.AddrMobileNo, SBA.VehicleImage,ISNULL(BR.Icast,'') AS AgentIcast ,  
 ISNULL(SBM.mustCheckPickupTime,0) as mustCheckPickupTime ,REPLACE(SBM.CheckPickupURL,'www.','https://') as CheckPickupURL, ISNULL(SBM.hoursBeforeConsulting,0) AS hoursBeforeConsulting  ,SBM.SupplierEmergencyNumber,  
 SBM.Flight_direction  
                                   
 FROM TR.TR_BookingMaster SBM WITH(NOLOCK)                             
  INNER JOIN TR.TR_BookedCars SBA WITH(NOLOCK) ON SBM.BookingId = SBA.BookingId                                        
  INNER JOIN TR.TR_PaxDetails SPD WITH(NOLOCK) ON SBM.BookingId = SPD.BookingId                                  
  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON SBM.AgentID = AL.UserID                                      
  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON SBM.AgentID = BR.FKUserID                                                                                                                      
  LEFT JOIN mUser MU1 WITH(NOLOCK) ON SBM.AgentID = MU1.ID                                                                                    
  LEFT JOIN B2BHotel_Commission HComm WITH(NOLOCK) ON HComm.Fk_BookId = SBM.BookingId                                  
 WHERE                           
 SBM.BookingId = @pkid AND SBM.AgentID = @AgentId                                
 ORDER BY SBM.BookingId DESC                             
                                
 SELECT spd.titel as title, spd.name as firstName, spd.surname as lastName, spd.age, spd.type, spd.pancardNo as panCardNumber,                                  
  spd.PanCardName, spd.passportNumber, spd.nationality, spd.issuingCountry as issuingCountry                                
 FROM TR.TR_PaxDetails  spd WITH(NOLOCK)                              
 WHERE BookingId = @pkid                                
END 