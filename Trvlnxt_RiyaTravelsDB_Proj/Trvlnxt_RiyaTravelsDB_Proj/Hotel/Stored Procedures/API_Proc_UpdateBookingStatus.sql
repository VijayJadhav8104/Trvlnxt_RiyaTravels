CREATE Procedure [Hotel].[API_Proc_UpdateBookingStatus]                              
 @BookingPkid VARCHAR(200),                                
 @FkStatusId INT,                                
 @AgentId INT = null,                                
 @MainAgentid int=null,                                
 @MethodName varchar(500)=null,                          
 @AddCanCharges int=0                          
As                                
Begin                                
declare @currentst nchar(20) =(select FkStatusId from Hotel_Status_History where FKHotelBookingId=@BookingPkid and IsActive=1)              
if (@currentst!='7')          
begin          
declare @hstatus VARCHAR(50)=(select Status from Hotel_Status_Master where id=@FkStatusId);                            
                                                   
update Hotel_BookMaster set CurrentStatus=@hstatus,AddCancelCharge=@AddCanCharges,ModeOfCancellation='API', CancelledBy=@AgentId,CancellationDate=getdate() where pkId=@BookingPkid                              
                               
 UPDATE Hotel_Status_History                               
 SET IsActive = 0, ModifiedDate = GETDATE()                              
 WHERE FKHotelBookingId = @BookingPkid and IsActive = 1                                
                                
 INSERT INTO Hotel_Status_History                                
 (FKHotelBookingId, FkStatusId, CreateDate, CreatedBy, ModifiedDate, IsActive, MainAgentId, MethodName)                              
 Values                              
 (@BookingPkid, @FkStatusId, GETDATE(), @AgentId, GETDATE(), 1, @MainAgentid, @MethodName)                                
                      
 SELECT pkId, BookingReference FROM Hotel_BookMaster                               
 WHERE pkId = @BookingPkid                                
                        
 INSERT INTO Hotel_UpdatedHistory                  
(fkbookid, FieldName, FieldValue, InsertedDate, InsertedBy, UpdatedType)                  
 SELECT @BookingPkid, @hstatus, 'API', GETDATE(), @MainAgentid, 'CancellationStatus'                  
    FROM Hotel_Status_History                  
    WHERE FKHotelBookingId = @BookingPkid     and IsActive=1                      
 end                       
End 