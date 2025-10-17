
            
            
                
                
Create Procedure Hotel.ServiceTimeVerifyUpate                                
@Pkid int=0,                              
@ModifiedBy int=0                  
                 
                  
As                                  
       
Begin    
begin TRANSACTION trans          
        
 BEGIN TRY    
update Hotel_BookMaster set ServiceTimeVerified=1,ServiceTimeVerifiedBy=@ModifiedBy              
where pkId=@Pkid                              
   
 INSERT INTO Hotel_UpdatedHistory                    
(fkbookid, FieldName, FieldValue, InsertedDate, InsertedBy, UpdatedType)                    
 Values   
 ( @Pkid, 'ServiceTime_Verified', 'Console_ServiceTimeVerified', GETDATE(), @ModifiedBy, 'ServiceTime_Verified' )                   
       
    COMMIT TRANSACTION trans    
   END TRY    
      
    
   BEGIN CATCH    
    
      ROLLBACK TRANSACTION trans    
    
  END CATCH      
    
End 