-- =============================================
-- Author:		<Nikhil Badgujar>
-- Create date: <21-03-2019>
-- Description:	<Insert Continent>
-- Modified by:		<#Gajanan Kadam>
-- Create date: <10-12-2019>
-- Description:	added bannerImage
-- =============================================
CREATE PROCEDURE [dbo].[Sp_InsertContinent] 
	-- Add the parameters for the stored procedure here
	@ContinentName varchar(50) = null,
	@Adjective nvarchar(max) = null, 
	@Description nvarchar(max) = null,
	@Url nvarchar(max) = null,
	@MetaTitle nvarchar(max) = null,
	@MetaDescription nvarchar(max) = null,
	@Keywords nvarchar(max) = null,
	@CoverImage nvarchar(max) =null,
	@IsActive bit = null,
	@GoogleAnalytics nvarchar(max)=null,
	@Id int = null,
	@AltTag  nvarchar(max)=null,
	@Action varchar(50),
	@Uid int = null,	
	@Message nvarchar(max) = null out ,
	@Banner_Image nvarchar(max)=null
	--@ModifiedBy int=null
AS
BEGIN
	SET NOCOUNT ON;

    

	BEGIN TRANSACTION;
    SAVE TRANSACTION MySavePoint;
	BEGIN TRY
	-- Insert statements for procedure here
	IF (@Action='insert')
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM Continent where ContinentName = @ContinentName AND IsActive=0)
		BEGIN
			INSERT INTO Continent(
				ContinentName,
				Adjective,
				Description,
				Url,
				MetaTitle,
				MetaDescription,
				Keywords,
				CoverImage,
				IsActive,
				GoogleAnalytics,
				U_id,
				CurrentTimeStamp,
				AltTag,
				BannerImage				
				)
			VALUES(
				@ContinentName,
				@Adjective,
				@Description,
				@Url,
				@MetaTitle,
				@MetaDescription,
				@Keywords,
				@CoverImage,
				@IsActive,
				@GoogleAnalytics,
				@Uid,
				SYSDATETIME(),
				@AltTag,
				@Banner_Image							
				)
		   SET @Message = 'Continent added.'
		END
		ELSE
			BEGIN
				SET @Message = 'Continent already exist.'
			END
		END
		ELSE IF(@Action='Update')
			BEGIN
				IF NOT EXISTS (SELECT 1 FROM Continent where ContinentName = @ContinentName and Id!= @Id AND IsActive=0)
					BEGIN
						UPDATE Continent SET 
						ContinentName=@ContinentName,
						AltTag=@AltTag,
						Adjective=@Adjective,
						Description=@Description,
						Url=@Url,
						MetaTitle=@MetaTitle,
						MetaDescription=@MetaDescription,
						Keywords=@Keywords,
						CoverImage=IsNull(@CoverImage,CoverImage),
						IsActive=@IsActive,
						GoogleAnalytics=@GoogleAnalytics, 
						LastModifiedDate = SYSDATETIME(),
		                ModifiedBy=@Uid,
						BannerImage = case when @Banner_Image is null then BannerImage else @Banner_Image end
						WHERE Id= @Id
						SET @Message = 'Continent updated.'
					END
				ELSE
					BEGIN
						SET @Message = 'Continent already exist.'
					END
			END
		ELSE IF(@Action='getGridData')
			BEGIN
				SELECT Id,ContinentName FROM Continent where  IsActive = 0
			END

			ELSE IF(@Action='checkContinenturl')
			BEGIN
				IF EXISTS(SELECT Url  FROM Continent
                    WHERE Url = @Url)
      BEGIN
            SELECT 'TRUE'
      END
      ELSE
      BEGIN
            SELECT 'FALSE'
      END
			END

			ELSE IF(@Action='getGridSearch')
			BEGIN
				SELECT Id, ContinentName FROM Continent WHERE ContinentName LIKE '%'+@ContinentName + '%' and IsActive != 1
			END

		ELSE IF(@Action='actionDelete')
				BEGIN
					UPDATE Continent SET IsActive=1 WHERE	 Id = @Id
				END

			ELSE IF(@Action='getContinentData')
				BEGIN
					SELECT 
					c.Id,
					c.AltTag,
					c.ContinentName,
					c.Adjective,
					c.Description,
					c.Url,
					c.MetaTitle,
					c.MetaDescription,
					c.Keywords,
					c.GoogleAnalytics,
					c.CoverImage,
					c.BannerImage
					 FROM Continent c  WHERE c.Id = @Id and IsActive=0
				
				END
			COMMIT TRANSACTION
			END TRY
	

BEGIN CATCH
	IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION MySavePoint; -- rollback to MySavePoint
        END
	DECLARE @Error_msg AS NVARCHAR(MAX);
	SET @Message = 'Something went wrong. Please try again.'
	SET @Error_msg = ERROR_MESSAGE();
	EXEC SP_AuditInsert @Message =  @Error_msg, @AuditType = 'SP_EXCEPTION',@UserId =@Uid,@UserName = null,@PageName='[dbo].[Sp_InsertContinent] '
END CATCH

END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_InsertContinent] TO [rt_read]
    AS [dbo];

