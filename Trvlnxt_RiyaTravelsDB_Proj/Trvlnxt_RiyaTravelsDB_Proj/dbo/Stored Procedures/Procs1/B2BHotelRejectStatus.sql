--- Created By : Aman W ---  
---- Created Date : 30 Apr @024 --  
  
            
                
                
CREATE Procedure [dbo].B2BHotelRejectStatus                                
@Pkid int=0,                              
@ModifiedBy int=0                  
                 
                  
As                                  
       
Begin    
begin TRANSACTION trans          
        
 BEGIN TRY    
update Hotel_BookMaster set CurrentStatus='Reject'                
where pkId=@Pkid                              
                                 
 UPDATE Hotel_Status_History                                 
 SET IsActive = 0, ModifiedDate = GETDATE()                                
 WHERE FKHotelBookingId = @Pkid and IsActive = 1                                  
                                  
 INSERT INTO Hotel_Status_History                                  
 (FKHotelBookingId, FkStatusId, CreateDate, CreatedBy, ModifiedDate, IsActive, MainAgentId, MethodName)                                
 Values                                
 (@Pkid, 5, GETDATE(),(select  CreatedBy from Hotel_Status_History where FKHotelBookingId=@Pkid and IsActive=1) , GETDATE(), 1,@ModifiedBy, 'Console_Reject_feature')                                  
                        
 SELECT pkId FROM Hotel_BookMaster                                 
 WHERE pkId = @Pkid                                  
                          
 INSERT INTO Hotel_UpdatedHistory                    
(fkbookid, FieldName, FieldValue, InsertedDate, InsertedBy, UpdatedType)                    
 Values ( @Pkid, 'Reject', 'Console_Reject', GETDATE(), @ModifiedBy, 'RejectedStatus' )                   
    select FKHotelBookingId from  Hotel_Status_History                    
    WHERE FKHotelBookingId = @Pkid and IsActive=1                        
       
    COMMIT TRANSACTION trans    
   END TRY    
      
    
   BEGIN CATCH    
    
      ROLLBACK TRANSACTION trans    
    
  END CATCH      
    
End 