                                                          
-- =============================================                                                            
-- Author:  <Ketan Hiranandani>                                                            
-- Create date: <06-Aug-2024>                                                            
-- Description: <To test pan card fetching in booking details after update booking details api call>                                                                    
-- =============================================                                                            
CREATE PROCEDURE [Hotel].[Api_GetBookingDetails]                                                           
 @BookingId varchar(90)=null                                                            
AS                                                            
BEGIN                                                            
                                                             
 select top 1 H.pkid, FkStatusId,H.orderId,RiyaAgentID as 'AgentId'                                                        
 ,ISNULL(DisplayDiscountRate,0) as 'DisplayDiscountRate'                                                         
 ,B2BPaymentMode as 'PaymentMode'    
 ,H.CheckOutDate as 'CheckoutDate'     
 ,H.CheckInDate as 'CheckinDate'                                                      
 ,H.ClientBookingId                                                    
 ,H.Nationalty AS Nationality                                        
 ,H.DestinationCountryCode                                  
 ,H.PayAtHotel                                
 ,P.IsLeadPax                                
 ,P.Pancard                                
 ,P.PanCardName as panCardName                              
 ,P.PassportNum as passportNo                            
 ,Replace(convert (varchar, P.IssueDate, 111),'/','-') as passportIssueDate                            
 ,Replace(convert (varchar, P.Expirydate, 111),'/','-') as passportExpDate                          
 ,Replace(convert (varchar, P.PassPortDOB, 111),'/','-') as passportDOB                    
 ,CASE H.IsPanCardRequired WHEN 1 THEN 'True' ELSE 'False' END AS IsPanCardRequired                  
 ,hs.Status AS 'BookingStatus'--added on 13122024                      
 ,H.HotelConfNumber AS 'HotelConfirmationNumber'              
 ,Cast(isnull(H.TotalRooms,0) as int) as 'TotalRooms'            
 ,H.providerConfirmationNumber            
 ,H.cancellationToken          
 ,H.ChannelId        
 ,H.searchApiId AS CorrelationId    
 ,Convert(datetime,H.CancellationDeadLine,103) AS CancellationDeadLine             
 ,H.SupplierName        
 ,H.CancellationPolicy        
 ,Rg.AgencyName        
 ,H.inserteddate AS 'BookingDate'   
 ,H.RequestForCancelled --added on 16092025 for pending cancellation
 ,H.HotelName,H.SupplierName,H.SupplierUsername,H.HotelPhone,H.HotelAddress1,H.cityName,H.HotelBookCountryName,H.HotelBookCountryCode--added on 07-10-2025
 from Hotel_BookMaster H                                                             
 left join Hotel_Status_History S on H.pkId=S.FKHotelBookingId                                                       
 left join Hotel_Pax_master P on p.book_fk_id=h.pkId and IsLeadPax=1                  
 left join Hotel_Status_Master hs ON hs.Id=S.FkStatusId--added on 13122024     
 left join B2BRegistration Rg ON rg.FKUserID=H.RiyaAgentID    
 where BookingReference=@BookingId and s.IsActive=1                                                   
 order by s.CreateDate desc                                                  
                                                            
END                                 
                            
--[Hotel].[Api_GetBookingDetails]  'TNHAPI00044989'                            
--[Hotel].[Api_GetBookingDetails]  'TNHAPI00044527' 