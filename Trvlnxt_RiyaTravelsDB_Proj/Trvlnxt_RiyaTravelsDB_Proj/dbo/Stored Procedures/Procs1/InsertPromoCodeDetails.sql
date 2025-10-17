
CREATE PROCEDURE [dbo].[InsertPromoCodeDetails]
	-- Add the parameters for the stored procedure here
	@AirLineCode varchar(20)=null,
	@fare varchar(50)=null,
	@salesFrm datetime,
	@salesTo datetime,
	@travelFrm date=null,
	@travelTo date=null,
	@SectorIncludeFrom VARCHAR(500),
	@SectorIncludeTo VARCHAR(500),
	@SectorExcludeFrom VARCHAR(500),
	@SectorExcludeTo VARCHAR(500),
	@MinFareAmount INT,
	@Discount INT,
	@remarks varchar(500)=null,
	@UserType tinyint,
	@PromoType tinyint,
	@IncludeFlat tinyint,
	@PromoCode varchar(50),
	@UserID bigint,
	@Mode varchar(5),
	@GST INT
AS
BEGIN

if(@Mode='I')
	BEGIN
	 IF NOT EXISTS(SELECT Pk_Id FROM PromoCode WHERE PromoCode=@PromoCode and FareType=@fare)
	 BEGIN
		If(@AirLineCode='All')
			BEGIN

				Update [dbo].PromoCode Set IsActive = 0 , [modifiedDate]=getdate(),ModifiedBy = @UserID
				where FareType=@fare 

				create   TABLE #TT1(aircode varchar(20) NULL)

				insert into #TT1
				SELECT [AirlineCode] AS  [_CODE] from dbo.AirlineCode_Console
   
				INSERT INTO [dbo].PromoCode
				   ([AirCode]
				   ,[FareType]
					,[salesFrm_date]
				   ,[salesTo_date]
				   ,[travelFrm_date]
				   ,[travelTo_date]
					,SectorIncludeFrom
					,SectorIncludeTo 
					,SectorExcludeFrom
					,SectorExcludeTo
					,MinFareAmount 
					,Discount 
					,remark
					,UserType
					,PromoType 
					,IncludeFlat 
					,PromoCode
					,UserID,IsActive,GST )
				select 
					aircode ,
					@fare ,
					@salesFrm ,
					@salesTo ,
					@travelFrm ,
					@travelTo 
					,@SectorIncludeFrom
					,@SectorIncludeTo 
					,@SectorExcludeFrom
					,@SectorExcludeTo
					,@MinFareAmount 
					,@Discount 
					,@remarks 
					,@UserType
					,@PromoType 
					,@IncludeFlat 
					,@PromoCode
					,@UserID,1,@GST  from #TT1

				select 1
				DROP TABLE #TT1

			END
		
			else If(@AirLineCode='LCC')
			BEGIN 

				Update [dbo].PromoCode Set IsActive = 0 , [modifiedDate]=getdate(),ModifiedBy = @UserID 
				where FareType=@fare and AirCode IN('SG','G8','6E')

				create   TABLE #TT2(aircode varchar(20) NULL)

				insert into #TT2
				SELECT [AirlineCode] AS  [_CODE] from dbo.AirlineCode_Console WHERE type='LCC'
   
				INSERT INTO [dbo].PromoCode
				   ([AirCode]
				   ,[FareType]
					,[salesFrm_date]
				   ,[salesTo_date]
				   ,[travelFrm_date]
				   ,[travelTo_date]
					,SectorIncludeFrom
					,SectorIncludeTo 
					,SectorExcludeFrom
					,SectorExcludeTo
					,MinFareAmount 
					,Discount 
					,remark
					,UserType
					,PromoType 
					,IncludeFlat 
					,PromoCode
					,UserID,IsActive,GST )
				select 
					aircode ,
					@fare ,
					@salesFrm ,
					@salesTo ,
					@travelFrm ,
					@travelTo 
					,@SectorIncludeFrom
					,@SectorIncludeTo 
					,@SectorExcludeFrom
					,@SectorExcludeTo
					,@MinFareAmount 
					,@Discount 
					,@remarks 
					,@UserType
					,@PromoType 
					,@IncludeFlat 
					,@PromoCode
					,@UserID,1,@GST  from #TT2

				select 1
				DROP TABLE #TT2
			END  

			else If(@AirLineCode='FSC')
			BEGIN 

				Update [dbo].PromoCode Set IsActive = 0, [modifiedDate]=getdate(),ModifiedBy = @UserID 
				where FareType=@fare and AirCode NOT IN('SG','G8','6E')

				create   TABLE #TT3(aircode varchar(20) NULL)

				insert into #TT3
				SELECT [AirlineCode] AS  [_CODE] from dbo.AirlineCode_Console WHERE type='FSC'
   
				INSERT INTO [dbo].PromoCode
				   ([AirCode]
				   ,[FareType]
					,[salesFrm_date]
				   ,[salesTo_date]
				   ,[travelFrm_date]
				   ,[travelTo_date]
					,SectorIncludeFrom
					,SectorIncludeTo 
					,SectorExcludeFrom
					,SectorExcludeTo
					,MinFareAmount 
					,Discount 
					,remark
					,UserType
					,PromoType 
					,IncludeFlat 
					,PromoCode
					,UserID,IsActive,GST )
				select 
					aircode ,
					@fare ,
					@salesFrm ,
					@salesTo ,
					@travelFrm ,
					@travelTo 
					,@SectorIncludeFrom
					,@SectorIncludeTo 
					,@SectorExcludeFrom
					,@SectorExcludeTo
					,@MinFareAmount 
					,@Discount 
					,@remarks 
					,@UserType
					,@PromoType 
					,@IncludeFlat 
					,@PromoCode
					,@UserID,1,@GST  from #TT3

				select 1
				DROP TABLE #TT3

			END  

		else
			
			BEGIN
				   IF NOT EXISTS(SELECT * FROM PromoCode WHERE [AirCode] = @AirLineCode AND [FareType] = @fare)
					BEGIN
						INSERT INTO [dbo].PromoCode
				   ([AirCode]
				   ,[FareType]
					,[salesFrm_date]
				   ,[salesTo_date]
				   ,[travelFrm_date]
				   ,[travelTo_date]
					,SectorIncludeFrom
					,SectorIncludeTo 
					,SectorExcludeFrom
					,SectorExcludeTo
					,MinFareAmount 
					,Discount 
					,remark
					,UserType
					,PromoType 
					,IncludeFlat 
					,PromoCode
					,UserID,IsActive,GST )
			VALUES(
					@AirLineCode ,
					@fare ,
					@salesFrm ,
					@salesTo ,
					@travelFrm ,
					@travelTo 
					,@SectorIncludeFrom
					,@SectorIncludeTo 
					,@SectorExcludeFrom
					,@SectorExcludeTo
					,@MinFareAmount 
					,@Discount 
					,@remarks 
					,@UserType
					,@PromoType 
					,@IncludeFlat 
					,@PromoCode
					,@UserID,1,@GST  )
						select 1
					End
					ELSE
					BEGIN
						UPDATE [dbo].PromoCode set  IsActive=0,[modifiedDate]=getdate(),ModifiedBy = @UserID 
										WHERE [AirCode] = @AirLineCode AND [FareType] = @fare 
						
							 			INSERT INTO [dbo].PromoCode
				   ([AirCode]
				   ,[FareType]
					,[salesFrm_date]
				   ,[salesTo_date]
				   ,[travelFrm_date]
				   ,[travelTo_date]
					,SectorIncludeFrom
					,SectorIncludeTo 
					,SectorExcludeFrom
					,SectorExcludeTo
					,MinFareAmount 
					,Discount 
					,remark
					,UserType
					,PromoType 
					,IncludeFlat 
					,PromoCode
					,UserID,IsActive,GST )
				values( 
					@AirLineCode ,
					@fare ,
					@salesFrm ,
					@salesTo ,
					@travelFrm ,
					@travelTo 
					,@SectorIncludeFrom
					,@SectorIncludeTo 
					,@SectorExcludeFrom
					,@SectorExcludeTo
					,@MinFareAmount 
					,@Discount 
					,@remarks 
					,@UserType
					,@PromoType 
					,@IncludeFlat 
					,@PromoCode
					,@UserID,1,@GST )
						select 1
					ND

					END
			
					END
	END
		ELSE
		BEGIN
		SELECT 2
		END
	END

ELSE if(@Mode='U')

	BEGIN
	IF NOT EXISTS(SELECT Pk_Id FROM PromoCode WHERE PromoCode=@PromoCode and FareType=@fare)
	 BEGIN	
	
				IF NOT EXISTS(SELECT * FROM PromoCode WHERE [AirCode] = @AirLineCode AND [FareType] = @fare)
				BEGIN
					INSERT INTO [dbo].PromoCode
				([AirCode]
				,[FareType]
				,[salesFrm_date]
				,[salesTo_date]
				,[travelFrm_date]
				,[travelTo_date]
				,SectorIncludeFrom
				,SectorIncludeTo 
				,SectorExcludeFrom
				,SectorExcludeTo
				,MinFareAmount 
				,Discount 
				,remark
				,UserType
				,PromoType 
				,IncludeFlat 
				,PromoCode
				,UserID,IsActive,GST )
		VALUES(
				@AirLineCode ,
				@fare ,
				@salesFrm ,
				@salesTo ,
				@travelFrm ,
				@travelTo 
				,@SectorIncludeFrom
				,@SectorIncludeTo 
				,@SectorExcludeFrom
				,@SectorExcludeTo
				,@MinFareAmount 
				,@Discount 
				,@remarks 
				,@UserType
				,@PromoType 
				,@IncludeFlat 
				,@PromoCode
				,@UserID,1,@GST  )
					select 1
				End
				ELSE
				BEGIN
					UPDATE [dbo].PromoCode set  IsActive=0,[modifiedDate]=getdate(),ModifiedBy = @UserID 
									WHERE [AirCode] = @AirLineCode AND [FareType] = @fare 
						
							 		INSERT INTO [dbo].PromoCode
				([AirCode]
				,[FareType]
				,[salesFrm_date]
				,[salesTo_date]
				,[travelFrm_date]
				,[travelTo_date]
				,SectorIncludeFrom
				,SectorIncludeTo 
				,SectorExcludeFrom
				,SectorExcludeTo
				,MinFareAmount 
				,Discount 
				,remark
				,UserType
				,PromoType 
				,IncludeFlat 
				,PromoCode
				,UserID,IsActive,GST )
			values( 
				@AirLineCode ,
				@fare ,
				@salesFrm ,
				@salesTo ,
				@travelFrm ,
				@travelTo 
				,@SectorIncludeFrom
				,@SectorIncludeTo 
				,@SectorExcludeFrom
				,@SectorExcludeTo
				,@MinFareAmount 
				,@Discount 
				,@remarks 
				,@UserType
				,@PromoType 
				,@IncludeFlat 
				,@PromoCode
				,@UserID,1,@GST )
					select 1
				ND

				END
			
					END

		ELSE
		BEGIN
		SELECT 2
		END

	END

ELSE

	BEGIN
	IF NOT EXISTS(SELECT * FROM PromoCode WHERE [AirCode] = @AirLineCode AND [FareType] = @fare)
				BEGIN
					INSERT INTO [dbo].PromoCode
				([AirCode]
				,[FareType]
				,[salesFrm_date]
				,[salesTo_date]
				,[travelFrm_date]
				,[travelTo_date]
				,SectorIncludeFrom
				,SectorIncludeTo 
				,SectorExcludeFrom
				,SectorExcludeTo
				,MinFareAmount 
				,Discount 
				,remark
				,UserType
				,PromoType 
				,IncludeFlat 
				,PromoCode
				,UserID,IsActive,GST )
		VALUES(
				@AirLineCode ,
				@fare ,
				@salesFrm ,
				@salesTo ,
				@travelFrm ,
				@travelTo 
				,@SectorIncludeFrom
				,@SectorIncludeTo 
				,@SectorExcludeFrom
				,@SectorExcludeTo
				,@MinFareAmount 
				,@Discount 
				,@remarks 
				,@UserType
				,@PromoType 
				,@IncludeFlat 
				,@PromoCode
				,@UserID,1,@GST  )
					select 1
				End
				ELSE
				BEGIN
					UPDATE [dbo].PromoCode set  IsActive=0,[modifiedDate]=getdate(),ModifiedBy = @UserID 
									WHERE [AirCode] = @AirLineCode AND [FareType] = @fare 
						
							 		INSERT INTO [dbo].PromoCode
				([AirCode]
				,[FareType]
				,[salesFrm_date]
				,[salesTo_date]
				,[travelFrm_date]
				,[travelTo_date]
				,SectorIncludeFrom
				,SectorIncludeTo 
				,SectorExcludeFrom
				,SectorExcludeTo
				,MinFareAmount 
				,Discount 
				,remark
				,UserType
				,PromoType 
				,IncludeFlat 
				,PromoCode
				,UserID,IsActive,GST )
			values( 
				@AirLineCode ,
				@fare ,
				@salesFrm ,
				@salesTo ,
				@travelFrm ,
				@travelTo 
				,@SectorIncludeFrom
				,@SectorIncludeTo 
				,@SectorExcludeFrom
				,@SectorExcludeTo
				,@MinFareAmount 
				,@Discount 
				,@remarks 
				,@UserType
				,@PromoType 
				,@IncludeFlat 
				,@PromoCode
				,@UserID,1,@GST )
					select 1
				ND

				END
	END

	
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertPromoCodeDetails] TO [rt_read]
    AS [dbo];

