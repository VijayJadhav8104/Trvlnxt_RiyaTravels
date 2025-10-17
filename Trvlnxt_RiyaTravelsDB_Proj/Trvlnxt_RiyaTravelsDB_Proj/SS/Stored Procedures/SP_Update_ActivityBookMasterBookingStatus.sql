CREATE PROCEDURE [SS].[SP_Update_ActivityBookMasterBookingStatus]    
     
 @BookingId INT ,    
 @BookingStatus VARCHAR(50),    
 @ActivityBookingStatus VARCHAR(50)=null,    
 @ProviderConfirmationNumber VARCHAR(50),    
 @providerCancellationNumber VARCHAR(50),    
 @ClientBookingId INT,    
 @VoucherUrl varchar(max) = NULL,    
 @AgentId INT = NULL,    
 @MainAgentid INT = NULL,    
 @MethodName VARCHAR(50) = NULL    
AS    
BEGIN    
    
 DECLARE @FkStatusId INT      
    
 UPDATE BM     
 SET BookingStatus = @BookingStatus, modifiedDate = GETDATE(),    
  ProviderConfirmationNumber = @ProviderConfirmationNumber,    
  ProviderCancellationNumber = @providerCancellationNumber,    
  ClientBookingId = @ClientBookingId, 
  
  BM.ModeOfCancellation = CASE WHEN @BookingStatus = 'Cancelled' THEN 'API' END,     
  BM.CancelledBy = @AgentId,  
  VoucherUrl = CASE WHEN isnull(@VoucherUrl,'') = '' THEN BM.VoucherUrl ELSE @VoucherUrl END,    
  CancellationDate = CASE WHEN @BookingStatus = 'Cancelled' THEN GETDATE() ELSE CancellationDate END    
 FROM [SS].[SS_BookingMaster] BM    
 WHERE BookingId = @BookingId     
    
 UPDATE [SS].SS_BookedActivities    
 SET ActivityStatus = @ActivityBookingStatus    
 WHERE BookingId = @BookingId     
    
    
                
 UPDATE [SS].[SS_Status_History]     
 SET IsActive = 0     
 WHERE BookingId = @BookingId and IsActive=1      
    
                   
 IF LOWER(@BookingStatus) = 'on_request'                                                  
 BEGIN                                                  
  SET @FkStatusId = 1                                                  
 END                                                  
 ELSE IF LOWER(@BookingStatus) = 'failed'                                                  
 BEGIN                                                  
  SET @FkStatusId = 11                                                  
 END                                      
 ELSE IF LOWER(@BookingStatus) = 'confirmed'                                                  
 BEGIN                                                  
  SET @FkStatusId = 3                                                  
 END                                       
 ELSE IF LOWER(@BookingStatus) = 'sold out'                                                  
 BEGIN                                                  
  SET @FkStatusId = 2                                                  
 END                                                  
 ELSE IF LOWER(@BookingStatus) = 'vouchered'                                                  
 BEGIN                                                  
  SET @FkStatusId = 4                                                  
 END                                 
 ELSE IF LOWER(@BookingStatus) = 'cancelled'                                                  
 BEGIN                                                  
  SET @FkStatusId = 7                                                
 END                                
 ELSE IF LOWER(@BookingStatus) = 'not found'                                            
 BEGIN                                            
  SET @FkStatusId = 13                                            
 END                             
 ELSE IF LOWER(@BookingStatus) = 'inprocess'                                            
 BEGIN                                            
  SET @FkStatusId = 9                                            
 END                              
 ELSE                                                  
 BEGIN                                                  
  SET @FkStatusId = 5                                                  
 END         
        
 INSERT INTO [SS].[SS_Status_History]                            
  (BookingId, FkStatusId, CreateDate, CreatedBy, ModifiedDate, IsActive, MainAgentId, MethodName)    
 VALUES    
  (@BookingId, @FkStatusId, GETDATE(), @AgentId, GETDATE(), 1, @MainAgentid, @MethodName)       
    
 SELECT @BookingId    
END 