      
      
          
          
CREATE Procedure [TR].[Proc_OfflineCancel]                          
@Pkid int=0,            
@AgentCharges decimal(10,2)=0.00,            
@SupplierCharges decimal(10,2)=0.00,  
@SuppAgntCnclChrgs decimal(10,2)=0.00,  
@CancellationRemark varchar(max)='',            
@ModifiedBy int=0,            
@AgentID int =0            
            
As                            
Begin                            
                        
                           
update TR.TR_BookingMaster set BookingStatus='Cancelled',AgentCanxCharges=@AgentCharges,            
SupplierCanxCharges=@SupplierCharges,SupplierCanxAgentChrge=@SuppAgntCnclChrgs, CancellationRemark=@CancellationRemark            
where BookingId=@Pkid                        
                           
 UPDATE TR.TR_Status_History                           
 SET IsActive = 0, ModifiedDate = GETDATE()                          
 WHERE BookingId = @Pkid and IsActive = 1                            
                            
select * from TR.TR_Status_History    
    
 INSERT INTO TR.TR_Status_History                            
 (BookingId, FkStatusId, CreateDate, CreatedBy, ModifiedDate, IsActive, MainAgentId, MethodName)                          
 Values                          
 (@Pkid, 7, GETDATE(),(select  CreatedBy from TR.TR_Status_History where BookingId=@Pkid and IsActive=1) , GETDATE(), 1,@ModifiedBy, 'Manually_OfflineCancel')                            
                  
 SELECT BookingId FROM TR.TR_BookingMaster                            
 WHERE BookingId = @Pkid                            
                    
 INSERT INTO TR.TR_bookingUpdate_History              
(FkBookid, FieldName, FieldValue, InsertedDate, InsertedBy, UpdatedType)              
 Values ( @Pkid, 'Cancelled', 'Offline_Cancel', GETDATE(), @ModifiedBy, 'Cancel_Console' )             
    select BookingId from TR.TR_Status_History              
    WHERE BookingId = @Pkid and IsActive=1                  
                    
End 
