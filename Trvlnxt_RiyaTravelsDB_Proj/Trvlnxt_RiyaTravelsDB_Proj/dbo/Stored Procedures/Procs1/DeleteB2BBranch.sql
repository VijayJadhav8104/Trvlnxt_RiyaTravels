-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE DeleteB2BBranch 
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	
	update B2BHotelBranch set IsActive=0 where Id=@id
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeleteB2BBranch] TO [rt_read]
    AS [dbo];

