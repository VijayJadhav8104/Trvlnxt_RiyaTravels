-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[ChequePubUrl] 
	-- Add the parameters for the stored procedure here
	@Url nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	 if not exists( select BlogTDImageUrl from PublishBlogMaster where BlogTDImageUrl=@Url and ActiveFlag='A' ) 
	begin
		select 0;
	end
	else
	begin
		select 1;
	end

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[ChequePubUrl] TO [rt_read]
    AS [dbo];

