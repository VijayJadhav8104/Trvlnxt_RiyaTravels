
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_InserNewUser]
	-- Add the parameters for the stored procedure here
	@name varchar(50),
	@userid varchar(50),
	@passwd varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if exists(select * from CMS_UserMaster where [UserID]=@userid COLLATE SQL_Latin1_General_CP1_CS_AS or [UserName]=@name COLLATE SQL_Latin1_General_CP1_CS_AS)
    begin
    select 2
    end
    else
    begin
	insert into CMS_UserMaster(UserName,UserID,Passward) values(@name,@userid,@passwd)
	select 1
	end

END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_InserNewUser] TO [rt_read]
    AS [dbo];

