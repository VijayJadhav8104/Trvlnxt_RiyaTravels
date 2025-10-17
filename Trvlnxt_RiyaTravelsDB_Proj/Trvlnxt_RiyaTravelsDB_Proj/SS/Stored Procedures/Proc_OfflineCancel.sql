          
          
              
              
CREATE Procedure [SS].[Proc_OfflineCancel]                              
@Pkid int=0,                
@AgentCharges decimal(10,2)=0.00,                
@SupplierCharges decimal(10,2)=0.00,    
@SuppAgntCnclChrgs decimal(10,2)=0.00,    
@CancellationRemark varchar(max)='',                
@ModifiedBy int=0,                
@AgentID int =0                
                
As                                
Begin                                
                            
                               
update SS.SS_BookingMaster set BookingStatus='Cancelled',AgentCanxCharges=@AgentCharges,                
SupplierCanxCharges=@SupplierCharges,SupplierCanxAgentChrge=@SuppAgntCnclChrgs,CancellationRemark=@CancellationRemark ,ModeOfCancellation='Offline', CancelledBy=@ModifiedBy ,
CancellationDate=getdate(),modifiedDate=getdate()
where BookingId=@Pkid                            
                               
 UPDATE SS.SS_Status_History                               
 SET IsActive = 0, ModifiedDate = GETDATE()                              
 WHERE BookingId = @Pkid and IsActive = 1                                
                                
        --select * from Ss.SS_Status_History  where  BookingId=84         order by BookingId desc
 INSERT INTO Ss.SS_Status_History                                
 (BookingId, FkStatusId, CreateDate, CreatedBy, ModifiedDate, IsActive, MainAgentId, MethodName)                              
 Values                              
 --(@Pkid, 7, GETDATE(),(select  CreatedBy from Ss.SS_Status_History where BookingId=@Pkid and IsActive=1) , GETDATE(), 1,@ModifiedBy, 'Manually_OfflineCancel')                                
   (@Pkid, 7, GETDATE(),(select top 1 CreatedBy from Ss.SS_Status_History where BookingId=@Pkid order by CreateDate desc) , GETDATE(), 1,@ModifiedBy, 'Manually_OfflineCancel')                                
                    
 SELECT BookingId FROM SS.SS_BookingMaster                               
 WHERE BookingId = @Pkid                                
                        
 INSERT INTO SS.BookingUpdate_History                  
(FkBookid, FieldName, FieldValue, InsertedDate, InsertedBy, UpdatedType)                  
 Values ( @Pkid, 'Cancelled', 'Offline_Cancel', GETDATE(), @ModifiedBy, 'Cancel_Console' )                 
  
  select BookingId from  Ss.SS_Status_History                  
    WHERE BookingId = @Pkid and IsActive=1                      
                        
End 