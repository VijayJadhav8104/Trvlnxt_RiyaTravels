
  
                    
CREATE Procedure [dbo].B2BSightSeeingRejectStatus                                    
@BookingId int=0,                                  
@ModifiedBy int=0                      
       
As                                      
Begin        
begin TRANSACTION trans              
            
BEGIN TRY        
update ss.SS_BookingMaster set BookingStatus='Reject'                    
where BookingId=@BookingId       
      
                                     
 UPDATE Ss.SS_Status_History                                     
 SET IsActive = 0, ModifiedDate = GETDATE()                                    
 WHERE BookingId = @BookingId and IsActive = 1                                      
                                      
 INSERT INTO Ss.SS_Status_History                                      
 (BookingId, FkStatusId, CreateDate, CreatedBy, ModifiedDate, IsActive, MainAgentId, MethodName)                                    
 Values                                    
 (@BookingId, 5, GETDATE(),(select  CreatedBy from Ss.SS_Status_History where BookingId=@BookingId and IsActive=1) , GETDATE(), 1,@ModifiedBy, 'Console_Reject_feature')                                      
                                                         
 INSERT INTO Ss.BookingUpdate_History                        
(fkbookid, FieldName, FieldValue, InsertedDate, InsertedBy, UpdatedType)                        
 Values ( @BookingId, 'Reject', 'Console_Reject', GETDATE(), @ModifiedBy, 'RejectedStatus' )                       
    select BookingId from  Ss.SS_Status_History                        
    WHERE BookingId = @BookingId and IsActive=1                            
           
   COMMIT TRANSACTION trans        
   END TRY        
          
        
   BEGIN CATCH        
        
      ROLLBACK TRANSACTION trans        
        
  END CATCH          
        
End   