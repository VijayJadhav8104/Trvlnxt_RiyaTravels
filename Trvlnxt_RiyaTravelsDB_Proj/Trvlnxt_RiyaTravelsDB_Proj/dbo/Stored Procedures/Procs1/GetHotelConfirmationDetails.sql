                
--GetHotelConfirmationDetails 7224                
CREATE Proc GetHotelConfirmationDetails                
@Id int=null                
                
As                
begin                
                
   Select HotelConfNumber                
          --,CONVERT(varchar,inserteddate,0) as 'BookingDate'                
    ,CONVERT(varchar,GETDATE(),0) as 'BookingDate'                
    ,HotelStaffName                
   ,SpecialRemark                 
     ,ConfirmationRemark          
  ,ServiceTimeVerified          
  ,ServiceTimeModified          
  ,ModifiedCheckInTime          
  ,ModifiedCheckOutTime       
  ---Confirmation --    
  ,PassengerConfirmation      
  ,RoomTypeConfirmation      
  ,MealPlanConfirmation   
  ,ExtrabedConfirmation  
  ,PaymentConfirmation  
  ,ConfByEmailConfirmation  
  --,PassangerConfirmationRemark      
  --- Reconfirmation ----    
   --,PassangerReConfirmation    
   --,RoomReConfirmation    
   --,MealReConfirmation    
   ,PassengerDetailsReconfirmationRemark as PassangerDetailsReConfirmationRemark    
    
    from Hotel_BookMaster WITH(NOLOCK)                
    where pkid=@id                
 end             
            

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetHotelConfirmationDetails] TO [rt_read]
    AS [dbo];

