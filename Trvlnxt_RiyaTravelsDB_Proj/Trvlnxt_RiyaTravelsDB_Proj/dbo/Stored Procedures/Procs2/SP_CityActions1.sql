-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[SP_CityActions1] 
	-- Add the parameters for the stored procedure here
	@CityName varchar(max)=null,
	@CityAdjective nvarchar(MAX)=null,
	@CountryName nvarchar(MAX)=null,
	--@Rate float =null,
	@CityImage nvarchar(MAX)=null,
	--@AirportName nvarchar(MAX)=null,
	--@AirportImageCity nvarchar(MAX),
	--@Routs nvarchar(MAX)=null,
	--@Time_Selector datetime = null,
	@Price float=null,
	@BannerImage nvarchar(MAX)=null,
	@UrlStructure nvarchar(MAX)=null,
	@MetaTitle nvarchar(MAX)=null,
	@MetaDescription nvarchar(MAX)=null,
	@Keywords nvarchar(MAX)=null,
	@GoogleAnalytics nvarchar(MAX)=null,
	--@isTrending bit=null,
	@hotelInclusive nvarchar(MAX)=null,
	@IsTrendingCity bit = null,
	@Inclusive bit = null,
	@Currency nvarchar(max) =null,
	@Timezone nvarchar(max) =null,
	@Temperature nvarchar(max) =null,
	@Precipitaion nvarchar(max) = null,
	@Description  nvarchar(max) = null,
	@IsActive bit=null,
	@Id int = null,
	@Uid int = null,
	@AltTag nvarchar(max)=null,
	@DisplayOrder int = null,
	@Action varchar(50) = null,
	@City_Popular_Route_Details [City_Popular_Route] readonly,
	@Airport_Details [City_Airports] readonly,
	@Hotels_Details [City_Hotels] readonly,
	@Message nvarchar(max)= null out
	--@ModifiedBy int=null 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET XACT_ABORT ON

	declare @trancount int;
	set @trancount = @@trancount;

	
	BEGIN TRY
		if @trancount = 0
		BEGIN TRANSACTION;
	else
		SAVE TRANSACTION MySavePoint;
		-- Insert statements for procedure here
	--print @Action
		IF (@Action='insert')
	BEGIN
	IF NOT EXISTS (SELECT 1 FROM TblCity where CityName = @CityName AND IsActive=0)
	BEGIN
	INSERT INTO TblCity (
			CityName,
			CityAdjective,
			CountryName,
			--Rate,
			CityImage,
			--AirportName,
			--AirportImage,
			--Routs,
			--TimeSelector,
			Price,
			BannerImage,
			UrlStructure,
			MetaTitle,
			MetaDescription,
			Keywords,
			IsActive,
			GoogleAnalytics,
			IsTrendingCity,
			Inclusive,
			CurrentTimeStamp,
			U_id,
			Currency,
			Timezone,
			Temperature,
			Precipitaion,
			Description,
			AltTag,
			DisplayOrder)

			VALUES(			
			@CityName,
			@CityAdjective,
			@CountryName,
			--@Rate,
			@CityImage,
			--@AirportName,
			--@Routs,
			@Price,
			@BannerImage,
			@UrlStructure,
			@MetaTitle,
			@MetaDescription,
			@Keywords,			
			@IsActive,
			@GoogleAnalytics,
			@IsTrendingCity,
			@Inclusive,
			SYSDATETIME(),
			@Uid,
			@Currency,
			@Timezone,
			@Temperature,
			@Precipitaion,
			@Description,
			@AltTag,
			@DisplayOrder)
			DECLARE @LAST_INSERTED_ID INT; 
			SELECT @LAST_INSERTED_ID = SCOPE_IDENTITY()
			
			
			INSERT INTO [dbo].[City_Popular_Route]  
			(   
			City_Id,
			Source_City,  
			Fastest_Flight_Time,  
			Route_Price,
			Route_Image,
			Time_Required,
			CurrentTimeStamp,
			U_id)
			Select 
			@LAST_INSERTED_ID,
			c.Source_City,  
			c.Fastest_Flight_Time,  
			c.Route_Price,
			c.Route_Img,
			c.Time_Required,
			SYSDATETIME(),
			@Uid
			From @City_Popular_Route_Details c;

			INSERT INTO [dbo].[City_Hotels]
			(
			[City_Id],
			[HotelCity],
			[Hotel_Name],
			[Address],
			[Strike_Price],
			[Price],
			[Star_Category],
			[Inclusive],
			[HotelUrl],
			[HotelMTitle],
			[HotelMDescription],
			[HotelGoogleAnalytics],
			[Keywords],
			[HotelImage],
			[CurrentTimeStamp],
			[U_id])

			SELECT
			@LAST_INSERTED_ID,
			H.Hotel_City,
			H.Hotel_Name,
			H.Address,
			H.Strike_Price,
			H.Price,
			H.Star_Category,
			H.Inclusive,
			H.HotelUrl,
			H.HotelMTitle,
			H.HotelMDescription,
			H.HotelGoogleAnalytics,
			H.Keywords,
			H.HotelImage,
			SYSDATETIME(),
			@Uid
			FROM 
			@Hotels_Details H

			
			INSERT INTO [dbo].[City_Airports]
			(
				[City_Id],
				[AirportName],
				[Description],
				[Route_Image],
				[CurrentTimeStamp],
				[U_id]
				)SELECT
				@LAST_INSERTED_ID,
				A.AirportName,
				A.Description,
				A.Route_Image,
				SYSDATETIME(),
				@Uid
				FROM @Airport_Details A



			SET @Message = 'City added.'
			--@IsActive)
		END
		ELSE
		BEGIN
		SET @Message = 'City already exist.'
		END
		END

		ELSE IF(@Action='Update')
		BEGIN
		IF NOT EXISTS (SELECT 1 FROM TblCity where CityName = @CityName and Id!= @Id and IsActive=0)
		BEGIN
		UPDATE TblCity SET
		CityName=@CityName,
		CityAdjective=@CityAdjective,
		CountryName=@CountryName,
		--Rate=@Rate,
		CityImage=IsNull(@CityImage,CityImage),
		--AirportName=@AirportName,
		--Routs=@Routs,
		Price=@Price,
		BannerImage=IsNull(@BannerImage,BannerImage),
		UrlStructure=@UrlStructure,
		MetaTitle=@MetaTitle,
		MetaDescription=@MetaDescription,
		Keywords=@Keywords,
		GoogleAnalytics=@GoogleAnalytics,
		IsTrendingCity = @IsTrendingCity,
		Inclusive = @hotelInclusive,
		Currency = @Currency,
		Timezone = @Timezone,
		AltTag=@AltTag,
		DisplayOrder = case when @DisplayOrder ='' then DisplayOrder else @DisplayOrder end,
		Temperature = @Temperature,
		Precipitaion = @Precipitaion,
		LastModifiedDate = SYSDATETIME(),
		ModifiedBy=@Uid
		WHERE ID = @Id

		DELETE City_Airports WHERE City_Id = @Id;
		DELETE City_Hotels WHERE City_Id = @Id;
		DELETE City_Popular_Route WHERE City_Id = @Id;
		
		INSERT INTO [dbo].[City_Popular_Route]  
			(   
			City_Id,
			Source_City,  
			Fastest_Flight_Time,  
			Route_Price,
			Route_Image,
			Time_Required,
			CurrentTimeStamp,
			U_id)
			Select 
			@Id,
			c.Source_City,  
			c.Fastest_Flight_Time,  
			c.Route_Price,
			c.Route_Img,
			c.Time_Required,
			SYSDATETIME(),
			@Uid
			From @City_Popular_Route_Details c;

			INSERT INTO [dbo].[City_Hotels]
			(
			[City_Id],
			[HotelCity],
			[Hotel_Name],
			[Address],
			[Strike_Price],
			[Price],
			[Star_Category],
			[Inclusive],
			[HotelUrl],
			[HotelMTitle],
			[HotelMDescription],
			[HotelGoogleAnalytics],
			[Keywords],
			[HotelImage],
			[CurrentTimeStamp],
			[U_id])
			SELECT
			@Id,
			H.Hotel_City,
			H.Hotel_Name,
			H.Address,
			H.Strike_Price,
			H.Price,
			H.Star_Category,
			H.Inclusive,
			H.HotelUrl,
			H.HotelMTitle,
			H.HotelMDescription,
			H.HotelGoogleAnalytics,
			H.Keywords,
			H.HotelImage,
			SYSDATETIME(),
			@Uid
			FROM 
			@Hotels_Details H

			
			INSERT INTO [dbo].[City_Airports]
			(
				[City_Id],
				[AirportName],
				[Description],
				[Route_Image],
				[CurrentTimeStamp],
				[U_id]
				)SELECT
				@Id,
				A.AirportName,
				A.Description,
				A.Route_Image,
				SYSDATETIME(),
				@Uid
				FROM @Airport_Details A

		SET @Message = 'City updated.'
		END

		ELSE
		BEGIN
		SET @Message = 'City already exist.'
		END
		END

		ELSE IF(@Action='getGridData')
		BEGIN
		SELECT Id,CityName FROM TblCity where IsActive = 0 order by CityName asc
		END

		ELSE IF(@Action='checkCityurl')
			BEGIN
				IF EXISTS(SELECT UrlStructure  FROM TblCity
                    WHERE UrlStructure = @UrlStructure)
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
		SELECT Id, CityName FROM TblCity WHERE CityName LIKE @CityName + '%' and IsActive != 1 order by CityName asc
		END


		ELSE IF(@Action='actionDelete')
		BEGIN
		UPDATE TblCity SET IsActive=1 where ID = @Id
		END
		ELSE IF(@Action='getCityData')
		BEGIN
				SELECT 
				c.Id,
				c.CityName,
				c.AltTag,
				c.DisplayOrder,
				c.CityAdjective,
				c.CountryName,
				--c.Rate,
				c.CityImage,
				--c.AirportName,
				--c.Routs,
				c.Price,
				c.BannerImage,
				c.UrlStructure,
				c.MetaTitle,
				c.MetaDescription,
				c.Keywords,
				c.GoogleAnalytics,
				c.IsTrendingCity,
				--c.Inclusive,
				c.[Description],
				c.[Currency],
				c.[Temperature],
				c.[Precipitaion],
				c.[Timezone],
				TZ.Timezone+' '+TZ.Locations as FullTimezone,
				CP.[Source_City],
				CP.[Fastest_Flight_Time],
				CP.[Route_Price],
				CP.[Popular_Route_Image],
				CP.[Time_Required],
				CP.[City_Airport_Name],
				CP.[City_Airport_Description],
				CP.[Airport_Route_Image],
				CP.[Hotel_Name],
				CP.[Address],
				CP.[Strike_Price],
				CP.[Rate],
				CP.[Star_Category],
				CP.[Inclusive],
				CP.[HotelUrl],
				CP.[HotelMTitle],
				CP.[HotelMDescription],
				CP.[HotelGoogleAnalytics],
				CP.[HotelKeywords],
				CP.[HotelCity],
				CP.[HotelImage]
				FROM TblCity c  
				CROSS JOIN (
				SELECT  P.[Source_City],
						P.[Fastest_Flight_Time],
						P.[Route_Price],
						P.[Route_Image] Popular_Route_Image,
						P.[Time_Required],
						A.[AirportName] City_Airport_Name,
						A.[Description] City_Airport_Description,
						A.[Route_Image] Airport_Route_Image,
						H.[Hotel_Name],
						H.[Address],
						H.[Strike_Price],
						H.[Price] Rate,
						H.[Star_Category],
						H.[Inclusive],
						H.[HotelUrl],
						H.[HotelMTitle],
						H.[HotelMDescription],
						H.[HotelGoogleAnalytics],
						H.[Keywords] HotelKeywords,
						H.[HotelCity],
						H.[HotelImage]
				FROM (SELECT *,
                             ROW_NUMBER() over(order by P.id) as rn
                      FROM   City_Popular_Route as P
                      WHERE  P.City_Id = @Id) as P
                FULL OUTER JOIN
                     (SELECT *,
                             ROW_NUMBER() over(order by A.id) as rn
                      FROM   City_Airports as A
                      WHERE  A.City_Id = @Id) as A
					  ON A.rn = P.rn
				FULL OUTER JOIN
                     (SELECT *,
                             ROW_NUMBER() over(order by H.id) as rn
                      FROM   City_Hotels as H
                      WHERE  H.City_Id = @Id) as H 
					  ON P.rn = H.rn) as CP

					  join Tbl_Timezone TZ on c.Timezone=TZ.Timezone 
				WHERE  c.ID = @Id 
			    END
	COMMIT TRANSACTION
	END TRY
				
    BEGIN CATCH
		DECLARE  @xstate int;
		SELECT @xstate = XACT_STATE();
		IF  @xstate = -1
            ROLLBACK;
		if @xstate = 1 and @@TRANCOUNT = 0
            rollback;
	    IF @xstate = 1 and @@TRANCOUNT > 0
            ROLLBACK TRANSACTION MySavePoint; -- rollback to MySavePoint
        
		DECLARE @Error_msg AS NVARCHAR(MAX);
	--SET @Message = 'Something went wrong. Please try again.'
		SET @Message = ERROR_MESSAGE();
		SET @Error_msg = ERROR_MESSAGE();
		EXEC SP_AuditInsert @Message =  @Error_msg, @AuditType = 'SP_EXCEPTION',@UserId =@Uid,@UserName = null,@PageName='SP_CityActions '
       END CATCH

       END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_CityActions1] TO [rt_read]
    AS [dbo];

