
CREATE PROCEDURE [dbo].[sp_CheckIP]
		@Ip varchar(100)
AS
BEGIN
	SET NOCOUNT ON;

	-- Insert statements for procedure here
	--select COUNT(pkid) from IPRestriction where IP=@Ip 
	select 1
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_CheckIP] TO [rt_read]
    AS [dbo];

