CREATE PROCEDURE [TR].[TR_Update_TransferBookMasterBookingStatus_1]            
             
@BookingId INT ,            
@BookingStatus VARCHAR(50),            
@ActivityBookingStatus VARCHAR(50)=null,            
@ProviderConfirmationNumber VARCHAR(50),            
@providerCancellationNumber VARCHAR(50)=null,              
@VoucherUrl varchar(max) = NULL,            
@AgentId INT = NULL,            
@MainAgentid INT = NULL,            
@MethodName VARCHAR(50) = NULL ,        
@PickUpInfo varchar (MAX) = NULL ,      
@Distance numeric(10,3) = NULL,      
@EstimatedTime varchar(50)  =null,    
@CancellationDate datetime =null,    
@EndTime datetime =null,
@mustCheckPickupTime BIT=0,
@CheckPickup_url  NVARCHAR(200) =null,
@hoursBeforeConsulting INT=0,
@SupplierEmergencyNumber  NVARCHAR(20)=null,
@Flight_direction VARCHAR(50) =null,
@PickupDateTime_Frm_Response DATETIME =null
    
AS            
BEGIN            
            
			DECLARE @FkStatusId INT              
            
			UPDATE BM             
					SET BookingStatus = @BookingStatus, modifiedDate = GETDATE(),            
					ProviderConfirmationNumber = @ProviderConfirmationNumber,            
					ProviderCancellationNumber = @providerCancellationNumber,         
					--pickinfo = @PickUpInfo,        
					VoucherUrl = CASE WHEN isnull(@VoucherUrl,'') = '' THEN BM.VoucherUrl ELSE @VoucherUrl END,            
					CancellationDate = CASE WHEN @BookingStatus = 'Cancelled' THEN GETDATE() ELSE CancellationDate END  ,      
					CancellationDeadline=  @CancellationDate,    
					TripEndDate= @EndTime,    
					EstimatedTime =@EstimatedTime,      
					Distance = @Distance,
					mustCheckPickupTime=@mustCheckPickupTime,
					CheckPickupURL=@CheckPickup_url,
					hoursBeforeConsulting=@hoursBeforeConsulting,
					SupplierEmergencyNumber=@SupplierEmergencyNumber,
					Flight_direction=@Flight_direction,
					PickupDateTime_Frm_Response=@PickupDateTime_Frm_Response
			FROM 
					[TR].[TR_BookingMaster] BM            
			WHERE 
					BookingId = @BookingId       
					

			UPDATE [TR].TR_BookedCars            
					SET @BookingStatus = @ActivityBookingStatus,      
						Distance = @Distance      
			WHERE 
					BookingId = @BookingId             
            
                        
			UPDATE [TR].[TR_Status_History]             
					SET IsActive = 0             
			WHERE 
					BookingId = @BookingId and IsActive=1              
            
                           
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
                
		 INSERT INTO [TR].[TR_Status_History]                 
		  (BookingId, FkStatusId, CreateDate, CreatedBy, ModifiedDate, IsActive, MainAgentId, MethodName)            
		 VALUES            
		  (@BookingId, @FkStatusId, GETDATE(), @AgentId, GETDATE(), 1, @MainAgentid, @MethodName)               
            
		 SELECT @BookingId            
END 