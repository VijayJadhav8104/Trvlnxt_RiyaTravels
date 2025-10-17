

--[UPDATE_Hotel_Ticket_Booking_Details] 1093,'47770','rejected','RT2047770'        
CREATE PROCEDURE [dbo].[UPDATE_Hotel_Ticket_Reject_Details]        
        
 @pkId BIGINT    null    
 ,@book_Id VARCHAR(150)    null    
 ,@book_message VARCHAR(500)  null      
 ,@book_Reference VARCHAR(100) null       
AS        
BEGIN        
 BEGIN TRY        
  BEGIN TRANSACTION        
        
  UPDATE Hotel_BookMaster        
  SET CurrentStatus = 'rejected',      
  book_message = @book_message        
   ,BookStatusSchedulerFlag = 1  
   ,CurrentDateSchedular = GetDate()  
  WHERE pkId = @pkId       
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
   ,5        
   ,GETDATE()        
   ,'0'        
   ,1  
   ,'HotelBookConfirmed'
   )        
    
   Select @@IDENTITY as result;    
        
  COMMIT TRANSACTION        
 END TRY        
 BEGIN CATCH        
  ROLLBACK TRANSACTION        
 END CATCH        
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UPDATE_Hotel_Ticket_Reject_Details] TO [rt_read]
    AS [dbo];

