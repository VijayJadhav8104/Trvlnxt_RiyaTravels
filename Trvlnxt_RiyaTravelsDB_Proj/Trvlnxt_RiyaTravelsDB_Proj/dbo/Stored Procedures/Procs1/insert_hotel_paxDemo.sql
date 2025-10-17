CREATE procedure [dbo].[insert_hotel_paxDemo]      
       @Salutation varchar(10),      
       @FirstName varchar(150),      
       @LastName varchar(150),      
       @PassengerType varchar(50),      
       @Age varchar(5)=null,         
       @book_fk_id bigint,      
       @room_fk_id bigint,      
       @PassportNum varchar(50)=null      
      ,@IssueDate varchar(30)=null      
      ,@Expirydate varchar(30)=null      
      ,@Nationality varchar(30)=null      
      ,@Email varchar(30)=null      
      ,@Contact varchar(30)=null      
      ,@ISDCode varchar(30)=null  
   ,@OrderId varchar(50)=null  
as      
begin      
INSERT INTO [dbo].[Hotel_Pax_master]      
           ([Salutation]      
           ,[FirstName]      
           ,[LastName]      
           ,[PassengerType]      
           ,[Age]      
           ,[book_fk_id]           
           ,[room_fk_id]      
           ,[inserteddate]      
           ,[PassportNum]      
           ,[IssueDate]      
           ,[Expirydate]      
           ,[Nationality]    
     ,[Email]    
     ,Contact    
     ,ISDCode     
     ,orderId  
   )      
     VALUES      
           (      
          @Salutation ,      
          @FirstName ,      
          @LastName ,      
          @PassengerType ,      
          @Age ,      
          @book_fk_id ,      
          @room_fk_id,      
          getdate(),      
          @PassportNum,       
          @IssueDate,       
          @Expirydate,       
          @Nationality,     
          @Email,  
    @Contact,  
    @ISDCode,  
    @OrderId  
   )      
      
    end      
      
      
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insert_hotel_paxDemo] TO [rt_read]
    AS [dbo];

