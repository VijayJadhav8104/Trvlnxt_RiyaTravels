            
                        
--GetBookingConfirmedDetailEmailSent 15701                        
                        
CREATE PROCEDURE [TR].[TR_GetPanCardEmailData]                                                                                                                                 
                                                                                                                                                                                                                                     
 @pkid int                                                                                                           
                                                                                                        
                                                                                                                              
AS                                                                                                                              
BEGIN                                                                                                                              
                        
            
   select                                                                                                             
                                                                                                                                
   HB.BookingId,        
   HB.BookingRefId,         
   HB.CorporatePANVerificatioStatus as PanCardStatus,                                                                                        
   SM.Status as CurrentStatus,            
    (BR.AddrEmail+','+'tn.hotels@riya.travel')  as 'AgencyEmail',             
  'tnsupport.hotels@riya.travel'  as 'CcAddress',                  
  ('faizan.shaikh@riya.travel'+','+'harshit.gor@riya.travel'+','+'priti.kadam@riya.travel'+','+'gary.fernandes@riya.travel'+','+'developers@riya.travel ' ) as 'BccAddress'                 
              
                                                          
                                                                      
                                                                            
  from TR.TR_BookingMaster HB  WITH (NOLOCK)                                                           
                                                                                                  
  left join TR.TR_Status_History SH  WITH (NOLOCK) on HB.BookingId=SH.BookingId                                                                                                                                    
  left join Hotel_Status_Master SM  WITH (NOLOCK) on SH.FkStatusId=SM.Id                                                                                                                
  left join AgentLogin AL  WITH (NOLOCK) on HB.AgentID=AL.UserID                                                                                        
  left join B2BRegistration BR  WITH (NOLOCK) on HB.AgentID=BR.FKUserID                                                                                                                        
                                                                          
   where                                                                           
  HB.BookingId = @pkid  and SH.IsActive=1                                                                                                                         
                                                                           
END 