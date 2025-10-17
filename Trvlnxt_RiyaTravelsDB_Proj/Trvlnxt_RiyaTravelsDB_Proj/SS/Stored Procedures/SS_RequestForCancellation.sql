CREATE PROCEDURE SS.SS_RequestForCancellation                                                                      
 -- Add the parameters for the stored procedure here                                                                      
 @Id int=null,                                                                                                                                  
 @Action int=0,      
 @ModifiedBy int=0      
AS                                                                      
BEGIN                                                                      
                                                                      
 begin           
  if(@Action=1)           
select 'NA'                                                                      
  end                                                               
           
           
   if(@Action=2)          
   begin          
   Update SS.SS_BookingMaster set Pendingcancellation=0  where BookingId=@Id        
         
   begin        
  insert into  SS.BookingUpdate_History          
  (fkbookid,FieldName ,FieldValue,InsertedDate,UpdatedType,InsertedBy)          
  select @Id,'Canx reconcilled',@Id,GETDATE(),'Pending Cancellation Request',@ModifiedBy from SS.SS_BookingMaster where BookingId = @Id              
      SELECT SCOPE_IDENTITY();                                    
        
   end       
      
          
   end          
END

