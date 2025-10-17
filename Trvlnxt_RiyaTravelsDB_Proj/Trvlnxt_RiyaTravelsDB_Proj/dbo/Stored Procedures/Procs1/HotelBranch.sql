-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE HotelBranch
	-- Add the parameters for the stored procedure here
	@id int = 0
AS
BEGIN
	
	if(@id = 0)
	begin
		select * from B2BHotelBranch where IsActive=1
		order by Id desc
	end

	else
	begin
		select * from B2BHotelBranch where IsActive=1 and Id = @id
		order by Id desc
	end
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[HotelBranch] TO [rt_read]
    AS [dbo];

