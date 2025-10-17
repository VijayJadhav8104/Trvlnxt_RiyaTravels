CREATE Procedure [Hotel].[Api_Proc_UpdateBookingDetails]                                    
@BookingPkid varchar(200),                                    
@BookingStatus varchar(200),                                    
@B2BPaymentMode int,                                    
@AgentId int=null,                                    
@MainAgentid int=null,                                    
@MethodName varchar(200)=null,                                    
@providerConfirmationNumber varchar(200) = NULL,                                    
@cancellationToken varchar(200)= NULL,                              
@HotelConfirmationNo varchar(300)=null,                              
@FailureReason varchar(1000)=null,      
@SupplierUrl varchar(max)=null      
             
As                                    
Begin                                    
 Declare @FkStatusId int                                    
 update Hotel_BookMaster Set                                     
 CurrentStatus=@BookingStatus,book_message='Success',providerConfirmationNumber=@providerConfirmationNumber,cancellationToken=@cancellationToken,B2BPaymentMode=@B2BPaymentMode,                
 --HotelConfNumber=@HotelConfirmationNo,                              
 --ConfirmationNumber=@HotelConfirmationNo,                
 FailureReason=@FailureReason,SupplierReferenceNo=@providerConfirmationNumber,SupplierBookingUrl=@SupplierUrl                        
 Where pkId=@BookingPkid                                    
                                    
 update Hotel_Status_History Set                                     
 IsActive=0 Where FKHotelBookingId=@BookingPkid and IsActive=1                                    
                                    
  IF @BookingStatus = 'On_Request'                                                          
  BEGIN                                                          
   SET @FkStatusId = 1                                                          
  END                                                          
  ELSE IF @BookingStatus = 'failed'                                                          
  BEGIN                                                          
   SET @FkStatusId = 11                                                          
  END                                              
  ELSE IF @BookingStatus = 'Confirmed'                                                          
  BEGIN                                                          
   SET @FkStatusId = 3                                                          
  END                                               
  ELSE IF @BookingStatus = 'Sold Out'                                                          
  BEGIN                                                          
   SET @FkStatusId = 2                                                          
  END                                                          
  ELSE IF @BookingStatus = 'Vouchered'                                                          
  BEGIN                                                          
   SET @FkStatusId = 4                                                          
  END                                         
   ELSE IF @BookingStatus = 'Cancelled'                                                          
  BEGIN                                                          
   SET @FkStatusId = 7                                                        
  END                                        
   ELSE IF @BookingStatus = 'Not Found'                                                    
  BEGIN                                                    
   SET @FkStatusId = 13                                                    
  END                                     
   ELSE IF @BookingStatus = 'InProcess'                                                    
  BEGIN                                                    
   SET @FkStatusId = 9                                                    
  END            
  --ELSE                                                          
  --BEGIN                                                          
  -- SET @FkStatusId = 5                                                          
  --END
	ELSE IF @BookingStatus = 'pending'                                                      
  BEGIN                                     
   SET @FkStatusId = 10                                                     
  END                   
  ELSE                                                            
  BEGIN                    
   SET @FkStatusId = 10                                                           
  END 
                                   
 Insert into Hotel_Status_History                                    
 (FKHotelBookingId,FkStatusId,CreateDate,CreatedBy,ModifiedDate,IsActive,MainAgentId,MethodName                                    
 )Values(@BookingPkid,@FkStatusId,GETDATE(),@AgentId,GETDATE(),1,@MainAgentid,@MethodName)                                    
                                    
 select pkId,BookingReference From Hotel_BookMaster Where pkId=@BookingPkid                            
End 