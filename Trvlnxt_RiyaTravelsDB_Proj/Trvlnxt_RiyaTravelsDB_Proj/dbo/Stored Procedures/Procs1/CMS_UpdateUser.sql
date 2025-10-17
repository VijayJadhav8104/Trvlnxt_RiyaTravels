
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_UpdateUser]
	-- Add the parameters for the stored procedure here
	@uid bigint,
	@name varchar(50),
	@passwd varchar(50),
	@userid varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update CMS_UserMaster set UserName=@name,UserID=@userid, Passward=@passwd where PKID_int=@uid
	select 1
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_UpdateUser] TO [rt_read]
    AS [dbo];

