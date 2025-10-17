              
              
CREATE Procedure [SS].[Proc_SSUpdateBookingStatus]                    
 @BookingPkid int,                      
 @FkStatusId INT,                      
 @AgentId INT = null,                      
 @MainAgentid int=null,                      
 @MethodName varchar(500)=null,                
 @AddCanCharges int=0,          
 @CancelCharge float=0,          
 @SupplierCharge float=0,          
 @CancelRemark varchar(200)=null        
As                      
Begin                      
                  
declare @hstatus VARCHAR(50)=(select Status from Hotel_Status_Master where id=@FkStatusId);                  
                  
          
update Ss.SS_BookingMaster set BookingStatus=@hstatus, PostCancellationCharges=@AddCanCharges,AgentCanxCharges=@CancelCharge,          
SupplierCanxCharges=@SupplierCharge,CancellationRemark=@CancelRemark,CancelledBy=@AgentId,CancellationDate=GETDATE(),ModeOfCancellation='API_Console' where BookingId=@BookingPkid           
          
          
 UPDATE Ss.SS_Status_History                     
 SET IsActive = 0, ModifiedDate = GETDATE()                    
 WHERE BookingId = @BookingPkid and IsActive = 1                      
                      
 INSERT INTO Ss.SS_Status_History                      
 (BookingId, FkStatusId, CreateDate, CreatedBy, ModifiedDate, IsActive, MainAgentId, MethodName)                    
 Values                    
 (@BookingPkid, @FkStatusId, GETDATE(), @AgentId, null, 1, @MainAgentid, @MethodName)                      
                      
 SELECT BookingId, BookingRefId FROM SS.SS_BookingMaster                     
 WHERE BookingId = @BookingPkid             
           
 INSERT INTO ss.BookingUpdate_History            
(fkbookid, FieldName, FieldValue, InsertedDate, InsertedBy, UpdatedType)            
 SELECT @BookingPkid, 'Cancelled', 'API_Console', GETDATE(), @MainAgentid, 'CancellationStatus'            
    FROM Ss.SS_Status_History             
    WHERE BookingId = @BookingPkid     and IsActive=1                
           
          
End 