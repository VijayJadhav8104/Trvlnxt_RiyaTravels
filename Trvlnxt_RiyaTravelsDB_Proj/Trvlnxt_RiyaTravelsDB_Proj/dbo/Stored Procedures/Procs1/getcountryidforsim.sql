
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getcountryidforsim] 
	-- Add the parameters for the stored procedure here
	@countryname varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if exists(select * from Globalsimcountrymaster where countryname_vc=@countryname)
	begin
	SELECT PKID_int from Globalsimcountrymaster where countryname_vc=@countryname
	end
	else
	begin
	insert into Globalsimcountrymaster(countryname_vc)values(@countryname)
	select MAX(PKID_int) from Globalsimcountrymaster 
	end



END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getcountryidforsim] TO [rt_read]
    AS [dbo];

