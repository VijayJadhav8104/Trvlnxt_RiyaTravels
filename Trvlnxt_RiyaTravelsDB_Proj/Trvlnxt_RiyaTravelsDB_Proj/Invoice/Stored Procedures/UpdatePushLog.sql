-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[UpdatePushLog]
	@Request VARCHAR(MAX) = NULL,
	@Response VARCHAR(MAX) = NULL,
	@Module VARCHAR(50) = NULL,
	@CreatedBy VARCHAR(50) = NULL
AS
BEGIN
	
	INSERT INTO [Invoice].[PushLog]
           ([Request]
           ,[Response]
           ,[Module]
		   ,[CreatedBy])
     VALUES
           (@Request
           ,@Response
           ,@Module
		   ,@CreatedBy)

END
