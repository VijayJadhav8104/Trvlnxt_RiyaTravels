            
            
                
                
CREATE Procedure Hotel.ServiceTimeModify                                
@Pkid int=0,                              
@ModifiedBy int=0,  
@ModifiedCheckInTime varchar(20)='',  
@ModifiedCheckOutTime varchar(20)=''  
                 
                  
As                                  
       
Begin    
begin TRANSACTION trans          
        
 BEGIN TRY    
update Hotel_BookMaster set ModifiedCheckInTime=@ModifiedCheckInTime,  
 ModifiedCheckOutTime=@ModifiedCheckOutTime,  
 ServiceTimeModified=1,ServiceTimeModifiedBy=@ModifiedBy   
   
where pkId=@Pkid                              
   
 INSERT INTO Hotel_UpdatedHistory                    
(fkbookid, FieldName, FieldValue, InsertedDate, InsertedBy, UpdatedType)                    
 Values   
 ( @Pkid, 'ServiceTime_Modified', 'Console_ServiceTimeModified', GETDATE(), @ModifiedBy, 'ServiceTime_Modified' )                   
       
    COMMIT TRANSACTION trans    
   END TRY    
      
    
   BEGIN CATCH    
    
      ROLLBACK TRANSACTION trans    
    
  END CATCH      
    
End 