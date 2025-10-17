-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetBlogOrdernumberUnique] 
	-- Add the parameters for the stored procedure here
	@BlogNumber nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
--	select BlogOrder from BlogMaster where BlogOrder=@BlogNumber


	if not exists(select BlogOrder from BlogMaster where  BlogOrder=@BlogNumber and Preview_Flag='A') AND  
	 not exists(select BlogOrder from PublishBlogMaster where BlogOrder=@BlogNumber and ActiveFlag='A')
	begin
		select 0 as BlogOrder;
	end
	else
	begin
		select 1 as BlogOrder;
	end



END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetBlogOrdernumberUnique] TO [rt_read]
    AS [dbo];

