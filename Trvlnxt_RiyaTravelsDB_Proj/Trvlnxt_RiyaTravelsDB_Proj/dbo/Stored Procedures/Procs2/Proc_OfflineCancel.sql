      
      
          
          
CREATE Procedure [dbo].[Proc_OfflineCancel]                          
@Pkid int=0,            
@AgentCharges decimal(10,2)=0.00,            
@SupplierCharges decimal(10,2)=0.00,            
@CancellationRemark varchar(max)='',            
@ModifiedBy int=0,            
@AgentID int =0            
            
As                            
Begin                            
                        
                           
update Hotel_BookMaster set CurrentStatus='Cancelled',agentCancellationCharges=@AgentCharges,            
SupplierCancellationCharges=@SupplierCharges,Post_addCancellationRemarks=@CancellationRemark,CancelledBy=@ModifiedBy,ModeOfCancellation='Offline_Cancel',CancellationDate=GETDATE()           
where pkId=@Pkid                        
                           
 UPDATE Hotel_Status_History                           
 SET IsActive = 0, ModifiedDate = GETDATE()                          
 WHERE FKHotelBookingId = @Pkid and IsActive = 1                            
                            
 INSERT INTO Hotel_Status_History                            
 (FKHotelBookingId, FkStatusId, CreateDate, CreatedBy, ModifiedDate, IsActive, MainAgentId, MethodName)                          
 Values                          
 (@Pkid, 7, GETDATE(),(select  CreatedBy from Hotel_Status_History where FKHotelBookingId=@Pkid and IsActive=1) , GETDATE(), 1,@ModifiedBy, 'Manually_OfflineCancel')                            
                  
 SELECT pkId FROM Hotel_BookMaster                           
 WHERE pkId = @Pkid                            
                    
 INSERT INTO Hotel_UpdatedHistory              
(fkbookid, FieldName, FieldValue, InsertedDate, InsertedBy, UpdatedType)              
 Values ( @Pkid, 'Cancelled', 'Offline_Cancel', GETDATE(), @ModifiedBy, 'CancellationStatus' )             
    select FKHotelBookingId from  Hotel_Status_History              
    WHERE FKHotelBookingId = @Pkid and IsActive=1                  
                    
End 