CREATE PROCEDURE [dbo].[UPDATE_Hotel_Ticket_Booking_Details]                      
                      
 @pkId BIGINT    null                  
 ,@book_Id VARCHAR(150)=    null                  
 ,@book_message VARCHAR(500)=  null                    
 ,@book_Reference VARCHAR(100)= null     
 ,@Vendor_Bookid varchar (20)= null    
 ,@AgentId varchar (20) = null
 , @SupplierRate varchar (20) = 0
 ,@AgentRate varchar (20)= 0
 ,@SupplierReferenceNo varchar (20)= null
 ,@QutechAgentId varchar (20)= null
AS                      
BEGIN                      
 BEGIN TRY                      
  BEGIN TRANSACTION                      
                      
  Declare @CheckStatus Varchar(20)=''       
    
    
 set @CheckStatus= (Select FkStatusId from  Hotel_Status_History where FKHotelBookingId=@pkId and IsActive=1)     
              
  UPDATE Hotel_BookMaster                      
  SET CurrentStatus = @book_message,                    
  book_message = @book_message                      
   ,BookStatusSchedulerFlag = 1                
   ,CurrentDateSchedular = GetDate()    
   ,book_Id = @Vendor_Bookid  
   ,BookingReference = @book_Reference  
   ,SupplierRate = @SupplierRate
   ,AgentRate = @AgentRate
   ,SupplierReferenceNo = @SupplierReferenceNo
   ,AgentId = @QutechAgentId
  WHERE pkId = @pkId     
    
     
                      
  DECLARE @id INT                      
                      
  IF @book_message = 'On_Request'                      
  BEGIN                      
   SET @id = 1                      
  END                      
  ELSE IF @book_message = 'failed'                      
  BEGIN                      
   SET @id = 11                      
  END          
  ELSE IF @book_message = 'Confirmed'                      
  BEGIN                      
   SET @id = 3                      
  END           
  ELSE IF @book_message = 'Sold Out'                      
  BEGIN                      
   SET @id = 2                      
  END                      
  ELSE IF @book_message = 'Vouchered'                      
  BEGIN                      
   SET @id = 4                      
  END     
   ELSE IF @book_message = 'Cancelled'                      
  BEGIN                      
   SET @id = 7                    
  END    
   ELSE IF @book_message = 'Not Found'                
  BEGIN                
   SET @id = 13                
  END   
  ELSE                      
  BEGIN                      
   SET @id = 5                      
  END                      
              
  if(@CheckStatus != @id)               
  BEGIN              
            
              
  UPDATE Hotel_Status_History                      
  SET IsActive = 0                      
  WHERE FKHotelBookingId = @pkId     
     
                        
            
      INSERT INTO Hotel_Status_History (               
   FKHotelBookingId                      
   ,FkStatusId                      
   ,ModifiedDate                      
   ,ModifiedBy                      
   ,IsActive  
   ,MethodName  
   )                      
  VALUES (                      
   @pkId                      
   ,@id                      
   ,GETDATE()                      
   ,'0'                      
   ,1  
   ,'StatusUpdateShedular'  
   )                      
    END              
   Select @@IDENTITY as result;                  
   Update SchedularBookingUpdated set EndDate=GETDATE()              
  COMMIT TRANSACTION                      
 END TRY                      
 BEGIN CATCH                      
  ROLLBACK TRANSACTION                      
 END CATCH                      
END  



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UPDATE_Hotel_Ticket_Booking_Details] TO [rt_read]
    AS [dbo];

