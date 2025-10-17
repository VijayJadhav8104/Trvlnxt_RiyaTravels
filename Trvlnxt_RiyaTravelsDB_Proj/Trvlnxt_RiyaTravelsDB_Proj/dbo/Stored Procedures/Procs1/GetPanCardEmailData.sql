        
                    
--GetBookingConfirmedDetailEmailSent 15701                    
                    
CREATE PROCEDURE GetPanCardEmailData                                                                                                                             
                                                                                                                                                                                                                                 
 @pkid int                                                                                                       
                                                                                                    
                                                                                                                          
AS                                                                                                                          
BEGIN                                                                                                                          
                    
        
   select                                                                                                         
                                                                                                                            
   HB.pkId,    
   HB.BookingReference,     
   HB.CorporatePANVerificatioStatus as PanCardStatus,                                                                                    
   SM.Status as CurrentStatus,        
    (BR.AddrEmail+','+'tn.hotels@riya.travel')  as 'AgencyEmail',         
  'tnsupport.hotels@riya.travel'  as 'CcAddress',              
  ('faizan.shaikh@riya.travel'+','+'harshit.gor@riya.travel'+','+'priti.kadam@riya.travel'+','+'minal.soni@riya.travel'+','+'gary.fernandes@riya.travel'+','+'developers@riya.travel ' ) as 'BccAddress'             
          
                                                      
                                                                  
                                                                        
  from Hotel_BookMaster HB  WITH (NOLOCK)                                                       
                                                                                              
  left join Hotel_Status_History SH  WITH (NOLOCK) on HB.pkId=SH.FKHotelBookingId                                                                                                                                
  left join Hotel_Status_Master SM  WITH (NOLOCK) on SH.FkStatusId=SM.Id                                                                                                            
  left join AgentLogin AL  WITH (NOLOCK) on HB.RiyaAgentID=AL.UserID                                                                                    
  left join B2BRegistration BR  WITH (NOLOCK) on HB.RiyaAgentID=BR.FKUserID                                                                                                                    
                                                                      
   where                                                                       
  HB.pkId = @pkid  and SH.IsActive=1                                                                                                                     
                                                                       
END 