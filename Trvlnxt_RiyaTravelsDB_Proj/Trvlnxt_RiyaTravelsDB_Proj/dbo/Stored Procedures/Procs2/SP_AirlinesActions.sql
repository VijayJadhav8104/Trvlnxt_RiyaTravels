
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_AirlinesActions] 
	-- Add the parameters for the stored procedure here
	@Airline_Id int=null,
	@AirlineName nvarchar(100)=null,
	--@ContinentAdjective nvarchar(MAX)=null,
	@AirlineImage nvarchar(MAX)=null,
	@DelayedFlights float = null,
	@Punctuality float = null,
	@FlightsCancelled float = null,
	@HandLuggage nvarchar(MAX) = null,
	@CheckInLuggage nvarchar(MAX) = null,
	@PopularDestination nvarchar(MAX)=null,
	@SimilarAirlines nvarchar(MAX)=null,
	@Urlstructure nvarchar(MAX)=null,
	@GoogleAnalytics nvarchar(MAX)=null,
	@IsActive bit = null,
	@Id int=null,
	@Uid int = null,
	@MetaTitle nvarchar(MAX)=null,
	@MetaDescription nvarchar(MAX)=null,
	@Keywords nvarchar(MAX)=null,
	--@QuickFacts nvarchar(MAX)=null,
	@Description nvarchar(MAX)=null,
	@BannerImage nvarchar(MAX)=null,
	@AirlineType nvarchar(MAX)=null,
	@Action varchar(50),
	@Message nvarchar(max)= null out 
	--@ModifiedBy int=null   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	BEGIN TRANSACTION;
    SAVE TRANSACTION MySavePoint;
	BEGIN TRY
    -- Insert statements for procedure here
	--print @Action
	IF (@Action='insert')
	BEGIN
	IF NOT EXISTS (SELECT 1 FROM TblAirline where AirlineName = @AirlineName AND IsActive = 0)
	    BEGIN
		INSERT INTO TblAirline(
			AirlineName,
		--	ContinentAdjective,
			AirlineImage,
			DelayedFlights,
			Punctuality,
			FlightsCancelled,
			HandLuggage,
			CheckInLuggage,
			PopularDestination,
			Urlstructure,
			GoogleAnalytics,
			IsActive,
			CurrentTimeStamp,
			U_id,
			MetaTitle,
			MetaDescription,
			Keywords,
			--QuickFacts,
			Description,
			BannerImage,
			SimilarAirline,
			AirlineType
			--Airline_Id
			)
			
			VALUES(
			@AirlineName,
		--	@ContinentAdjective,
			@AirlineImage,
			@DelayedFlights,
			@Punctuality,
			@FlightsCancelled,
			@HandLuggage,
			@CheckInLuggage,
			@PopularDestination,
			@Urlstructure,
			@GoogleAnalytics,
			@IsActive,
			SYSDATETIME(),
			@Uid,
			@MetaTitle,
			@MetaDescription,
			@Keywords,
			--@QuickFacts,
			@Description,
			@BannerImage,
			@SimilarAirlines,
			@AirlineType);
			
			DECLARE @LAST_INSERTED_ID INT;
			SELECT  @LAST_INSERTED_ID =  SCOPE_IDENTITY()
			;WITH tmp(AirlineId, DataItem, String) AS
			(
				SELECT
				@LAST_INSERTED_ID AirlineId,
				LEFT(@SimilarAirlines, CHARINDEX(',', @SimilarAirlines + ',') - 1),
				STUFF(@SimilarAirlines, 1, CHARINDEX(',', @SimilarAirlines + ','), '')
				UNION all

				SELECT
					AirlineId,
					LEFT(String, CHARINDEX(',', String + ',') - 1),
					STUFF(String, 1, CHARINDEX(',', String + ','), '')
				FROM tmp
			WHERE
			String > ''
			)



INSERT INTO [dbo].[SimilarAirline]
			(
				[SimilarAirline_Id],
				[Airline_Id]
				)SELECT
				A.DataItem,
				A.AirlineId
				FROM tmp A 

;WITH tmpDestination(AirlineId, DataItem, String) AS
			(
				SELECT
				@LAST_INSERTED_ID AirlineId,
				LEFT(@PopularDestination, CHARINDEX(',', @PopularDestination + ',') - 1),
				STUFF(@PopularDestination, 1, CHARINDEX(',', @PopularDestination + ','), '')
				UNION all

				SELECT
					AirlineId,
					LEFT(String, CHARINDEX(',', String + ',') - 1),
					STUFF(String, 1, CHARINDEX(',', String + ','), '')
				FROM tmpDestination
			WHERE
			String > ''
			)
			INSERT INTO [dbo].[PopularDestination]
			(
				[PopularDestinations_Id],
				[Airline_Id]
				)SELECT
				A.DataItem,
				A.AirlineId
				FROM tmpDestination A
			SET @Message = 'Airlines added.'
			END
		    ELSE
			BEGIN
			SET @Message = 'Airlines already exist.'
			END
	
		    END

		ELSE IF(@Action='Update')
		BEGIN
		IF NOT EXISTS (SELECT 1 FROM TblAirline  where AirlineName = @AirlineName and Id!= @Id  AND IsActive = 0)
		BEGIN

		Update TblAirline SET
		AirlineName=@AirlineName,
		--Airline_Id=@Airline_Id,
	--	ContinentAdjective=@ContinentAdjective,
		DelayedFlights=@DelayedFlights,
		Punctuality=@Punctuality,
		AirlineImage=IsNull(@AirlineImage,AirlineImage),
		FlightsCancelled=@FlightsCancelled,
		HandLuggage=@HandLuggage,
        CheckInLuggage=@CheckInLuggage,
		PopularDestination=@PopularDestination,
		Urlstructure=@Urlstructure,
		GoogleAnalytics=@GoogleAnalytics,
		IsActive=@IsActive,
		MetaTitle=@MetaTitle,
		MetaDescription=@MetaDescription,
		Keywords=@Keywords,
		--QuickFacts=@QuickFacts,
		Description=@Description,
		AirlineType=@AirlineType,
		BannerImage=IsNull(@BannerImage,BannerImage),
		SimilarAirline=ISNULL(@SimilarAirlines,SimilarAirline),
		LastModifiedDate = SYSDATETIME(),
		ModifiedBy=@Uid
	    where Id = @Id;

		DELETE FROM [SimilarAirline] WHERE Airline_Id = @Id;
		DELETE FROM [PopularDestination] WHERE Airline_Id = @Id;
		set @LAST_INSERTED_ID=@Id
		;WITH tmp(AirlineId, DataItem, String) AS
			(
				SELECT
				@LAST_INSERTED_ID AirlineId,
				--@Id AirlineId,
				LEFT(@SimilarAirlines, CHARINDEX(',', @SimilarAirlines + ',') - 1),
				STUFF(@SimilarAirlines, 1, CHARINDEX(',', @SimilarAirlines + ','), '')
				UNION all

				SELECT
					AirlineId,
					LEFT(String, CHARINDEX(',', String + ',') - 1),
					STUFF(String, 1, CHARINDEX(',', String + ','), '')
				FROM tmp
			WHERE
			String > ''
			)

			

INSERT INTO [dbo].[SimilarAirline]
			(
				[SimilarAirline_Id],
				[Airline_Id]
				)SELECT
				A.DataItem,
				A.AirlineId
				FROM tmp A

;WITH tmpDestination(AirlineId, DataItem, String) AS
			(
				SELECT
				@LAST_INSERTED_ID AirlineId,
				LEFT(@PopularDestination, CHARINDEX(',', @PopularDestination + ',') - 1),
				STUFF(@PopularDestination, 1, CHARINDEX(',', @PopularDestination + ','), '')
				UNION all

				SELECT
					AirlineId,
					LEFT(String, CHARINDEX(',', String + ',') - 1),
					STUFF(String, 1, CHARINDEX(',', String + ','), '')
				FROM tmpDestination
			WHERE
			String > ''
			)
			INSERT INTO [dbo].[PopularDestination]
			(
				[PopularDestinations_Id],
				[Airline_Id]
				)SELECT
				A.DataItem,
				A.AirlineId
				FROM tmpDestination A


		SET @Message = 'Airlines updated.'
		END
		ELSE
		BEGIN
		SET @Message = 'Airlines already exist.'
		END
		END
	
		ELSE IF(@Action='getGridData')
		BEGIN
		SELECT Id,AirlineName,AirlineType FROM TblAirline where IsActive = 0
		END

		ELSE IF(@Action='checkAirlineurl')
			BEGIN
				IF EXISTS(SELECT Urlstructure  FROM TblAirline
                    WHERE Urlstructure = @Urlstructure)
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
				SELECT Id, AirlineName,AirlineType FROM TblAirline WHERE AirlineName LIKE @AirlineName + '%' and IsActive != 1
			END


		ELSE IF(@Action='actionDelete')
		BEGIN
		UPDATE TblAirline SET IsActive=1 where Id = @Id
		END

		ELSE IF(@Action='getAirlineData')
		BEGIN
		SELECT 
		c.Id,
		c.AirlineName,
		--c.Airline_Id,
		c.AirlineImage,
		--c.ContinentAdjective,
		c.DelayedFlights,
		c.Punctuality,
		c.FlightsCancelled,
		c.HandLuggage,
		c.CheckInLuggage,
	    c.PopularDestination,
	    c.Urlstructure,		
		c.GoogleAnalytics,
		c.MetaTitle,
		c.MetaDescription,
		c.Keywords,
		--c.QuickFacts,
		c.Description,
		c.BannerImage,
		c.AirlineType,
		c.SimilarAirline SimilarAirline
	    FROM TblAirline c  WHERE c.Id = @Id;
		SELECT s.SimilarAirline_Id,A.AirlineName From SimilarAirline s
		JOIN TblAirline A on s.SimilarAirline_Id = A.Id
		 WHERE S.Airline_Id=@Id;

		SELECT P.PopularDestinations_Id, C.CityName From PopularDestination p
		JOIN TblCity C on C.ID = P.PopularDestinations_Id
		WHERE Airline_Id=@Id;
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
	EXEC SP_AuditInsert @Message =  @Error_msg, @AuditType = 'SP_EXCEPTION',@UserId =@Uid,@UserName = null,@PageName='[dbo].[SP_AirlinesActions] '
        END CATCH
	
        END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_AirlinesActions] TO [rt_read]
    AS [dbo];

