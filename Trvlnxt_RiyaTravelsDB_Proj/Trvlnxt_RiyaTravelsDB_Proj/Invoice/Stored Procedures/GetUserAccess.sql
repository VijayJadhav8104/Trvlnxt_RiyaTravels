-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[GetUserAccess]
	@UserId bigint = 0,
	@Module VARCHAR(50)
AS
BEGIN
	
	Select * from [Invoice].[UserAccess] Where UserId = @UserId and Module = @Module

END
