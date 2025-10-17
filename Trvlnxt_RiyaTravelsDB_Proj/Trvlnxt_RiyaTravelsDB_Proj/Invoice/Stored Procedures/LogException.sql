-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Invoice.LogException
	@ExceptionMessage VARCHAR(MAX),
	@ExceptionStackTrack VARCHAR(MAX),
	@ControllerName VARCHAR(100),
	@ActionName VARCHAR(100)
AS
BEGIN
	
	INSERT INTO [Invoice].[ErrorLog]
           ([ExceptionMessage]
           ,[ExceptionStackTrack]
           ,[ControllerName]
           ,[ActionName])
     VALUES
           (@ExceptionMessage
           ,@ExceptionStackTrack
           ,@ControllerName
           ,@ActionName)

END
