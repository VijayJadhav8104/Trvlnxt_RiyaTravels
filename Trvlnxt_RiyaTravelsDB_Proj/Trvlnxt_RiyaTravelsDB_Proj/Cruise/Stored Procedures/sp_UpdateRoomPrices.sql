



  
  
                  
CREATE PROCEDURE [Cruise].[sp_UpdateRoomPrices]
	--@Search_UID varchar(100),
	@Room_Type varchar(100),
	@BasePrice decimal(18,2),
	@ItineraryId varchar(100)
AS
BEGIN
	
	if exists(select * from Cruise.CacheRoomPrices where ItineraryId = @ItineraryId)
	BEGIN

	UPDATE [Cruise].[CacheRoomPrices]
   SET [Price] = @BasePrice
      --,[CreatedOn] = GETDATE()
      ,[ValidTill] = GETDATE()
 WHERE ItineraryId = @ItineraryId

	END
	ELSE
	BEGIN

	INSERT INTO [Cruise].[CacheRoomPrices]
           ([Room_Type]
           ,[Price]
           ,[CreatedOn]
           ,[ValidTill]
           ,[ItineraryId])
     VALUES
           (@Room_Type
           ,@BasePrice
           ,GETDATE()
           ,GETDATE()
           ,@ItineraryId)

	END

END
