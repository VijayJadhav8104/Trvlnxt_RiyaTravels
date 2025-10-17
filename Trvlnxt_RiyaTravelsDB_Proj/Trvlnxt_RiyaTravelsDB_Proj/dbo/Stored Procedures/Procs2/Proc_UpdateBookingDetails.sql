                
CREATE Procedure Proc_UpdateBookingDetails                                    
@BookingPkid varchar(200),                                    
@BookingStatus varchar(200),                                    
@B2BPaymentMode int,                                    
@AgentId int=null,                                    
@MainAgentid int=null,                                    
@MethodName varchar(200)=null,                                    
@providerConfirmationNumber varchar(200) = NULL,                                    
@cancellationToken varchar(200)= NULL,                              
@HotelConfirmationNo varchar(300)=null,                              
@FailureReason varchar(1000)=null                            
As                                    
Begin                                    
 Declare @FkStatusId int                                    
 update Hotel_BookMaster Set                                     
 CurrentStatus=@BookingStatus,book_message='Success',providerConfirmationNumber=@providerConfirmationNumber,cancellationToken=@cancellationToken,      
 --HotelConfNumber=@HotelConfirmationNo,                              
 --ConfirmationNumber=@HotelConfirmationNo,      
 FailureReason=@FailureReason,SupplierReferenceNo=@providerConfirmationNumber                          
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
   ELSE IF @BookingStatus = 'pending'                                                    
  BEGIN                                   
   SET @FkStatusId = 10                                                   
  END                 
  ELSE                                                          
  BEGIN                  
   SET @FkStatusId = 10                                                         
  END              
                                    
 Insert into Hotel_Status_History                                    
 (FKHotelBookingId,FkStatusId,CreateDate,CreatedBy,ModifiedDate,IsActive,MainAgentId,MethodName)                  
 Values(@BookingPkid,@FkStatusId,GETDATE(),@AgentId,GETDATE(),1,@MainAgentid,@MethodName)     
   
 --Begin try    
 --if(@FkStatusId=3 OR @FkStatusId=4)    
 --Begin    
 --update smp    
 --set smp.VirtualBalance=isnull(smp.VirtualBalance,0)-bm.expected_prize    
 --from B2BHotelSupplierMaster as smp    
 --inner join Hotel_BookMaster bm on smp.Id=bm.SupplierPkId    
 --where bm.pkId=@BookingPkid    
 --END    
 --END try    
 --Begin catch    
       
 --END Catch    
                                    
 select pkId From Hotel_BookMaster Where pkId=@BookingPkid         
     
    
          
 -- Begin                  
 --   INSERT INTO Hotel_UpdatedHistory                  
 --   (fkbookid, FieldName, FieldValue, InsertedDate, InsertedBy, UpdatedType) Values                 
 --   ( @BookingPkid, @BookingStatus, @BookingStatus, GETDATE(), coalesce(@MainAgentid,@AgentId), 'Sp_Proc_UpdateBookingDetails' )                 
 --  select FKHotelBookingId   FROM Hotel_Status_History                  
 --   WHERE FKHotelBookingId = @BookingPkid and IsActive=1          
         
 --end                   
                
End             