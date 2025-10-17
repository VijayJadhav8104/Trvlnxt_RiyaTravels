-- =============================================    
-- Author:Akash Singh  
-- Create date: 20-Jan-2022  
-- Description: Procedure is created for Get Booking Info    
-- [dbo].[GetBookingSupplier_procedure] 'RT1004281'    
-- [dbo].[GetBookingSupplier_procedure] '4225'    
-- =============================================    
CREATE PROCEDURE [dbo].[GetHotelBookingInfo_procedure]    
 -- Add the parameters for the stored procedure here    
 @bookingid varchar(50)=null    
AS    
BEGIN    
  select top 1 * from Hotel_BookMaster where ltrim(rtrim(BookingReference))=ltrim(rtrim(@bookingid))   
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetHotelBookingInfo_procedure] TO [rt_read]
    AS [dbo];

