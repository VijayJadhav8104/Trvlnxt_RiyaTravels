CREATE PROCEDURE [Hotel].[InsertHotelBookingValidation] 
  @ErrorMessage VARCHAR(1700) = NULL           
 ,@ClientBookingId VARCHAR(200) = NULL    
 ,@CorrelationId VARCHAR(150)=NULL    
AS      
BEGIN          
  INSERT INTO [Hotel].[HotelBookingValidation] (           
   ErrorMessage            
   ,ClientBookingId    
   ,CorrelationId    
   )      
  VALUES (           
    @ErrorMessage              
   ,@ClientBookingId    
   ,@CorrelationId    
   )            
END      

