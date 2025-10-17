-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[Translate]
	@textToTranslate varchar(500) = NULL,
	@translatedText nvarchar(500) = NULL,
	@sourceLanguage varchar(10) = NULL,
	@targetLanguage varchar(10) = NULL
AS
BEGIN
	
	IF EXISTS(SELECT 1 
				FROM [Invoice].[Translations] 
				where textToTranslate = @textToTranslate
				and sourceLanguage = @sourceLanguage
				and targetLanguage = @targetLanguage)
	BEGIN

	SELECT translatedText FROM [Invoice].[Translations] 
	WHERE textToTranslate = @textToTranslate
	AND sourceLanguage = @sourceLanguage
	AND targetLanguage = @targetLanguage

	END
	BEGIN

		IF (@translatedText <> '')
		BEGIN

		INSERT INTO [Invoice].[Translations]
			   ([textToTranslate]
			   ,[translatedText]
			   ,[sourceLanguage]
			   ,[targetLanguage])
		 VALUES
			   (@textToTranslate
			   ,@translatedText
			   ,@sourceLanguage
			   ,@targetLanguage)

		END

	END
END
