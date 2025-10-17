          
CREATE procedure SP_APIBookingAuthentication  --'','2023053012422121-9e381bde-b8a4-400b-926e-82556025c841' ,'','','S2023053012435263-0d77c779-e80a-4bdf-a1f5-fbda9c976d03','46OR67'                                    
@AgentID varchar(255) = ''                                        
,@TrackID varchar(MAX) = ''                                        
,@FlightKey varchar(MAX) = ''                                        
,@SessionToken varchar(MAX) = ''                                        
,@SellKey varchar(MAX) = ''                                     
,@GDSPNR varchar(50) = ''                        
,@Departure varchar(50) = ''                        
,@Arrival varchar(50) = ''                        
,@DepartureDate varchar(100) = ''                        
,@ArrivalDate varchar(100) = ''                        
,@RequestType varchar(50) = ''                      
,@Environment varchar(100) = ''                    
,@ErrorMessage varchar(MAX) = ''                  
,@isHoldBooking bit = 0                
,@IPAddress varchar(100) = ''              
,@ServerInsertedDate varchar(255) = ''              
                        
as                                          
begin                                          
                                          
 if(@RequestType = 'avaibility')                                          
 begin                                            
  insert into APIBookingAuthentication (AgentID,TrackID,InsertedDate,Departure,Arrival,DepartureDate,ArrivalDate,UpdatedDate,Environment,ErrorMessage,IPAddress,ServerInsertedDate,RequestType)                                        
  Values (@AgentID,@TrackID,GETDATE(),@Departure,@Arrival,@DepartureDate,@ArrivalDate,GETDATE(),@Environment,@ErrorMessage,@IPAddress,@ServerInsertedDate,@RequestType)                                        
 end                                            
 else if(@RequestType = 'airsell')                                        
 begin                                        
  update APIBookingAuthentication set FlightKey = @FlightKey,SessionToken = @SessionToken,UpdatedDate = GETDATE(),ErrorMessage = @ErrorMessage,RequestType = @RequestType  where TrackID = @TrackID               
                
  DECLARE @Id bigint;            
  select @Id = ID from APIBookingAuthentication WITH (NOLOCK) where TrackID = @TrackID            
  insert into APIBookingAuthentication_Internal (APIBookingRefID,SellKey,FlightKey,SessionToken)             
  Values (@Id,@SellKey,@FlightKey,@SessionToken)            
 end                                        
 else if(@RequestType = 'bookingticket')                                        
 begin                                        
  update APIBookingAuthentication set FlightKey = @FlightKey,SessionToken = @SessionToken,SellKey = @SellKey,GDSPNR = @GDSPNR,UpdatedDate = GETDATE(),ErrorMessage = @ErrorMessage,IPAddress = @IPAddress,RequestType = @RequestType where TrackID = @TrackID  
  
    
      
 end                    
 else if(@RequestType = 'holdbookingticket')                                        
 begin                                        
  update APIBookingAuthentication set GDSPNR = @GDSPNR,UpdatedDate = GETDATE(),ErrorMessage = @ErrorMessage,IsHoldBooking = @isHoldBooking,RequestType = @RequestType where TrackID = @TrackID                                        
 end      
 else if(@RequestType = 'cancellationbooking' OR @RequestType = 'cancellationretrieve' OR @RequestType = 'changeclass' OR @RequestType = 'changeclassgetfare')                                        
 begin                                        
  update APIBookingAuthentication set UpdatedDate = GETDATE(),ErrorMessage = @ErrorMessage,RequestType = @RequestType where TrackID = @TrackID                                                              
 end      
 else if(@RequestType = 'retrievepnr')                                          
 begin      
  insert into APIBookingAuthentication (AgentID,TrackID,InsertedDate,Departure,Arrival,DepartureDate,ArrivalDate,UpdatedDate,Environment,ErrorMessage,IPAddress,ServerInsertedDate,RequestType,SessionToken,GDSPNR,FlightKey)         
  Values (@AgentID,@TrackID,GETDATE(),@Departure,@Arrival,@DepartureDate,@ArrivalDate,GETDATE(),@Environment,@ErrorMessage,@IPAddress,@ServerInsertedDate,@RequestType,@SessionToken,@GDSPNR,@FlightKey)                                          
 end      
      
End      