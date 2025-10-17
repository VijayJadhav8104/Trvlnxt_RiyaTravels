
-- =============================================
-- Author:		Akash
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Hotel.GetAllRateSoldOutKeys
	-- Add the parameters for the stored procedure here
     
AS
 BEGIN

     Select soldoutkey as keys   from hotel.tbl_RateblockKeys where IsActive=1
  
 END
