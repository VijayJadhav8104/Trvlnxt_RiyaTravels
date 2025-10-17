
CREATE PROCEDURE [dbo].[getglobalsimdata]
	-- Add the parameters for the stored procedure here
	@country bigint
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@country!=0)
    begin
	SELECT * from globalsimInfo where Fkcountry_int=@country
	end
	--else
	--begin
	--select updateddt_dt  from globalsimInfo
	--end
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getglobalsimdata] TO [rt_read]
    AS [dbo];

