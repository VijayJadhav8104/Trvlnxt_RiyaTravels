

CREATE proc UpdatePaxName    
@id int=null,    
@Title varchar(20)=null,    
@Fname varchar(20)=null,    
@Lname varchar(20)=null, 
@Pkid int =null,  
@Userid int =null  
    
as    
BEGIN   
   Declare @Orderid Varchar(60);  
  
   Set @Orderid=(Select top 1  Orderid From Hotel_Pax_master where id=@id)  
   If(@Orderid !='')  
   begin   
   Update Hotel_BookMaster set  
   LeaderTitle=@Title,  
   LeaderFirstName=@Fname,    
   LeaderLastName=@Lname    
   Where orderid=@Orderid   
   end   
   Update Hotel_Pax_master set     
   Salutation=@Title,    
   FirstName=@Fname,    
   LastName=@Lname    
   Where id=@id  
   

                               
 begin  
  insert into Hotel_UpdatedHistory     
  (fkbookid,FieldName ,FieldValue,InsertedDate,UpdatedType,InsertedBy)    
  select @Pkid,'Pax Modified',(CONCAT(Salutation ,' ',FirstName,' ',LastName)),GETDATE(),'Pax',@Userid from Hotel_Pax_master where book_fk_id = @Pkid        
      SELECT SCOPE_IDENTITY();                              
  
   end  

END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdatePaxName] TO [rt_read]
    AS [dbo];

