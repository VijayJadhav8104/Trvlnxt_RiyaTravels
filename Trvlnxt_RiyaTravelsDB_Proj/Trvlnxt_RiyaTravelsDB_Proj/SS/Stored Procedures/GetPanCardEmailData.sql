              
                          
--GetBookingConfirmedDetailEmailSent 15701                          
                          
CREATE PROCEDURE SS.GetPanCardEmailData                                                                                                                                   
                                                                                                                                                                                                                                       
 @pkid int                                                                                                             
                                                                                                          
                                                                                                                                
AS                                                                                                                                
BEGIN                                                                                                                                
   
 select  
BM.BookingId  
,BM.BookingRefId AS 'BookingReference'  
,bm.CorporatePANVerificatioStatus AS 'PanCardStatus'  
,SM.Status as CurrentStatus  
,(BR.AddrEmail+','+'tn.hotels@riya.travel')  as 'AgencyEmail',   
--,'developers@riya.travel'  as 'AgencyEmail'   
 'tnsupport.hotels@riya.travel'  as 'CcAddress'   
 --,'gary.fernandes@riya.travel'  as 'CcAddress'   
   
 ,'gary.fernandes@riya.travel,developers@riya.travel' as BccAddress   
 From SS.SS_BookingMaster BM  
 left join SS.Ss_Status_history SH  WITH (NOLOCK) on BM.BookingId=SH.BookingId                                                                                                                                      
  left join Hotel_Status_Master SM  WITH (NOLOCK) on SH.FkStatusId=SM.Id  
  left join B2BRegistration BR  WITH (NOLOCK) on BM.AgentID=BR.FKUserID    
  left join AgentLogin AL  WITH (NOLOCK) on BR.FKUserID=AL.UserID                                                                                          
  where    BM.BookingId = @pkid  and SH.IsActive=1    
                                                                             
END 