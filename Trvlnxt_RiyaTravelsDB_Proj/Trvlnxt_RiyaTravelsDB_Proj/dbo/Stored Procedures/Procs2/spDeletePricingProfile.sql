-- =============================================
-- Author:		Gajanan Kadam
-- Create date: 31-05-2018
-- Description: this sp is used for delete 
-- =============================================
CREATE PROCEDURE [dbo].[spDeletePricingProfile]
	-- Add the parameters for the stored procedure here
	
	@ID int
AS
BEGIN
	update HotelDiscountDetails set IsActive=1 where Id=@ID
	SELECT 1
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spDeletePricingProfile] TO [rt_read]
    AS [dbo];

