
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_InsertTestimotions] 
	-- Add the parameters for the stored procedure here
	@name  varchar(50),
	@comment text,
	@image varchar(max),
	@id bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if(@id=0)
	begin
	insert into CMS_TestImonial (Name,Comment,Image) values(@name,@comment,@image)
	select 1
	end
	else
	begin
	update CMS_TestImonial set Name=@name,Comment=@comment,Image=@image where PKID = @id
	select 2
	end
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_InsertTestimotions] TO [rt_read]
    AS [dbo];

