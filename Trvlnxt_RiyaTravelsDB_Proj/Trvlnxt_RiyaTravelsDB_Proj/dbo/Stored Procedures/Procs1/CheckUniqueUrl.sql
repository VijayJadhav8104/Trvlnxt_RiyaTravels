-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: < 25 / 10 2018 >
-- Description:	< Filter Unique Url>
-- =============================================
CREATE PROCEDURE [dbo].[CheckUniqueUrl] --'https://www.riya.travel/travel-diaries/dfgdf'
	-- Add the parameters for the stored procedure here
	@Url nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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
    ON OBJECT::[dbo].[CheckUniqueUrl] TO [rt_read]
    AS [dbo];

