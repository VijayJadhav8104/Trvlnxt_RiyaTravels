-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[PageVisitLog]
	@Module VARCHAR(MAX) = NULL,
	@Page VARCHAR(MAX) = NULL,
	@Url VARCHAR(MAX) = NULL,
	@UserId BIGINT = 0,
	@IsStaff INT = 0
AS
BEGIN
	IF @Module != 'Unknown'
	BEGIN
		INSERT INTO [Invoice].[PagesVisited]
			   ([Module]
			   ,[Page]
			   ,[Url]
			   ,[UserId]
			   ,[IsStaff])
		 VALUES
			   (@Module
			   ,@Page
			   ,@Url
			   ,@UserId,
			   @IsStaff)
	END
END
