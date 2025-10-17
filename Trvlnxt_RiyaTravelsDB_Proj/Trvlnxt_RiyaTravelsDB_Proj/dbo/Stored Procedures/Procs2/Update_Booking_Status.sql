
CREATE PROCEDURE Update_Booking_Status               
@pkID int= Null              
              
AS              
BEGIN              
              
 select  HR.Response,HB.B2BPaymentMode,HB.MainAgentID,HB.RiyaAgentID,HB.riyaPNR,HB.SupplierUsername,HB.SupplierPassword,AR.apidata from Hotel_BookMaster  HB           
 LEFT JOIN [AllAppLogs].[Dbo].HotelAPI_RequestResponsetbl HR ON HB.pkId  = HR.BookingPkId   
 LEFT JOIN [AllAppLogs].[Dbo].APIDataStoreHotel AR ON  HB.orderId collate SQL_Latin1_General_CP1_CI_AS = AR.APIOrderID collate SQL_Latin1_General_CP1_CI_AS 
 where  HB.pkId   = @pkID          
           
 --UPDATE Hotel_Status_History                
 -- SET IsActive = 0                
 -- WHERE FKHotelBookingId = @PKID                
                
  --INSERT INTO Hotel_Status_History (                
  -- FKHotelBookingId                
  -- ,FkStatusId                
  -- ,ModifiedDate                
  -- ,ModifiedBy                
  -- ,IsActive                
  -- )                
  --VALUES (                
  -- @PKID                
  -- ,5               
  -- ,GETDATE()                
  -- ,'0'                
  -- ,1                
  -- )                
   ---------------------------------------------                  
              
                
 COMMIT TRAN           
  END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Update_Booking_Status] TO [rt_read]
    AS [dbo];

