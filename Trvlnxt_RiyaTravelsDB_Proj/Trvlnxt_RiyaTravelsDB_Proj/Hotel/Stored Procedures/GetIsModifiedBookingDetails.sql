-- =============================================      
-- Author:Prakash Suryawanshi      
-- Create date: 11-Feb-2025      
-- Description: Procedure is created for Get Modified Booking Details confirmation  
-- [Hotel].[GetIsModifiedBookingDetails] 67771  
  
-- =============================================    
CREATE PROCEDURE  [Hotel].[GetIsModifiedBookingDetails]  
 @bookingID nvarchar(500)   
AS      
BEGIN      
 SELECT   
  ID   
 FROM   
  [Hotel].[HotelBookingModifyDetails]    
 WHERE   
  book_fk_id=@bookingID   
  AND IsActive=1  
  
END  
  
  