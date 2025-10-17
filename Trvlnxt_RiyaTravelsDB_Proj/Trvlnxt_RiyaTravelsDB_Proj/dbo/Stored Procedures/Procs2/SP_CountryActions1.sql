
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[SP_CountryActions1]
	-- Add the parameters for the stored procedure here
	@Action varchar(50)=null,
	@Id int = null,
	@Continent_Id int=null,
	@CountryName nvarchar(50)=null,
	@Adjective nvarchar(100)=null,
	@Rate float =null,
	@Image nvarchar(MAX)=null,
	@Banner_Image nvarchar(MAX)=null,
	@Description nvarchar(max)=null,
	@Url nvarchar(200)=null,
	--@UrlStructure nvarchar(200)=null,
	@MetaTitle nvarchar(max)=null,
	@MetaDescription nvarchar(max)=null,
	@Keywords nvarchar(max)=null,
	@GoogleAnalytics nvarchar(max)=null,
	@Uid int=null,
	@AltTag nvarchar(max)=null,
	@DisplayOrder int = null,
	@IsActive bit=null,
	@CurrentTimeStamp datetime= null,
	@Message nvarchar(100) = null out
	--@ModifiedBy int=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRANSACTION;
    SAVE TRANSACTION MySavePoint;
	BEGIN TRY 
    

			 if(@Action='ViewCountryData')
				--getCountryData
				begin
				select 
				CO.ContinentName,
				CC.Continent_Id,
				CC.CountryName,
				cc.AltTag,
				cc.DisplayOrder,
				CC.Adjective,
				CC.Rate,
				CC.Image,
				CC.Banner_Image,
				CC.Description,
				CC.Url, 
				CC.UrlStructure,
				CC.MetaTitle,
				CC.MetaDescription,
			    CC.Keywords, 
				CC.GoogleAnalytics 
				from Conti_Country CC JOIN Continent CO ON CC.Continent_Id = CO.Id where CC.Id = @Id
				end



				-- Insert statements for procedure here
		Else IF(@Action='getGridData')
			BEGIN
				SELECT Id,CountryName FROM Conti_Country 
		        where IsActive = 0 order by CountryName asc
			END
       else if(@Action='SearchCountryData')
	   begin
	   
	   SELECT Id,CountryName FROM Conti_Country 
		        where IsActive = 0 and CountryName LIKE '%'+ @CountryName + '%' order by CountryName Asc
	   end

		ELSE IF (@Action='insert')
			BEGIN
				IF NOT EXISTS(SELECT 1 FROM Conti_Country WHERE CountryName=@CountryName AND IsActive=0)
					BEGIN
						INSERT INTO Conti_Country(
						Continent_Id,
						CountryName,
						Adjective,
						Rate,
						[Image],
						Banner_Image,
						[Description],
						Url,
						--UrlStructure,
						MetaTitle,
						MetaDescription,
						Keywords,
						[Date],
						IsActive,
						GoogleAnalytics,
						U_id,
						CurrentTimeStamp,
						AltTag,
						DisplayOrder)
						
						VALUES(
						@Continent_Id,
						@CountryName,
						@Adjective,
						@Rate,
						@Image,
						@Banner_Image,
						@Description,
						@Url,
						--@UrlStructure,
						@MetaTitle,
						@MetaDescription,
						@Keywords,
						SYSDATETIME(),
						@IsActive,
						@GoogleAnalytics,
						@Uid,
						SYSDATETIME(),
						@AltTag,
						@DisplayOrder)
						SET @Message = 'Country added.'
					END
				ELSE 
					BEGIN
						SET @Message = 'Country '+@CountryName+' already exist.'
					END
			END
			else if(@Action='actionDelete')
			begin 
			Update Conti_Country set IsActive=1 where ID=@Id
			SET @Message = 'Country Deleted..'
			end
		ELSE IF(@Action='Update')
			BEGIN
				IF NOT EXISTS(SELECT 1 FROM Conti_Country WHERE CountryName=@CountryName and Id!= @Id AND IsActive=0)
					BEGIN
						UPDATE Conti_Country 
						SET 
						Continent_Id=@Continent_Id,
						CountryName=@CountryName,
						Adjective=@Adjective,
						Rate=@Rate,
						[Image]=IsNull(@Image,Image),
						Banner_Image=IsNull(@Banner_Image,Banner_Image),
						[Description]=@Description,
						Url=@Url,
						--UrlStructure=@UrlStructure,
						MetaTitle=@MetaTitle,
						AltTag=@AltTag,
						DisplayOrder = case when @DisplayOrder ='' then DisplayOrder else @DisplayOrder end,
						MetaDescription=@MetaDescription,
						Keywords=@Keywords,
						GoogleAnalytics=@GoogleAnalytics,
						LastModifiedDate = SYSDATETIME(),
		                ModifiedBy=@Uid
						WHERE Id=@Id
						SET @Message = 'Country Updated..'
					END
					ELSE 
					BEGIN
						SET @Message = 'Country '+@CountryName+' already exist.'
					END
				END


				ELSE IF(@Action='checkCountryurl')
			BEGIN
				IF EXISTS(SELECT Url  FROM Conti_Country
                    WHERE Url = @Url)
      BEGIN
            SELECT 'TRUE'
      END
      ELSE
      BEGIN
            SELECT 'FALSE'
      END
			END

				
    ELSE IF(@Action='getCountryData')
	BEGIN
				--SELECT * FROM Conti_Country WHERE ID=@id	
	select
	 c.Id,
	 c.Continent_Id,
	 c.CountryName,
	 c.AltTag,
	 c.DisplayOrder,
	 c.Adjective,
	 c.Rate,
	 c.Image,
	 c.Banner_Image,
	 c.[Description],
	 c.Url, 
	 --c.UrlStructure,
	 c.MetaTitle,
	 c.MetaDescription,
	 c.Keywords, 
	 c.GoogleAnalytics 
	 from Conti_Country c where c.Id = @Id
    END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION MySavePoint; -- rollback to MySavePoint
			END
		DECLARE @Error_msg AS NVARCHAR(MAX);
		SET @Message = 'Something went wrong. Please try again.'
		SET @Error_msg = ERROR_MESSAGE();
		EXEC SP_AuditInsert @Message =  @Error_msg, @AuditType = 'SP_EXCEPTION' ,@UserId =@Uid,@UserName = null,@PageName='SP_CountryActions'
	END CATCH
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_CountryActions1] TO [rt_read]
    AS [dbo];

