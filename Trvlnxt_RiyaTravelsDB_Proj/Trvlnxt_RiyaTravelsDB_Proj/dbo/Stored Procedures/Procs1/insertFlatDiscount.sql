
CREATE proc [dbo].[insertFlatDiscount]
(
@SectorType varchar(5),
@AirCode varchar(20)=null,
@UserId int,
@FlatDiscountType int,
@salesFrm_date	date=NULL,	
@salesTo_date	date=NULL,
@travelFrm_date	date=NULL,
@travelTo_date	date=NULL,
@FlatDiscount  FlatDiscount READONLY,
@Country varchar(10),
@Username varchar(50)

)
as
BEGIN
	IF(@AirCode ='All') 
	 BEGIN

	Update FlatDiscount set IsActive=0 WHERE  [SectorType]=@SectorType
	 insert into FlatDiscount
	(
	[SectorType],
	[AirCode],
	[Insert_date],
	[UserId],
	[IsActive],
	FlatDiscountType,
	salesFrm_date,	
	salesTo_date,	
	travelFrm_date,	
	travelTo_date,
	minFlatAmt,	
	maxFlatAmt,
	amount,
	Country,
	Username

	) 
	SELECT @SectorType,AirlineCode,
	GETDATE(),@UserId,1,@FlatDiscountType,
	@salesFrm_date,	
	@salesTo_date,	
	@travelFrm_date,	
	@travelTo_date,
	MinFlatAmt
	,MaxFlatAmt
	,FlatDiscount
	,@Country
	,@Username
	FROM AirlineCode_Console, @FlatDiscount
	
	END

	else IF(@AirCode ='FSC') 
	 BEGIN

	Update FlatDiscount set IsActive=0 WHERE  [SectorType]=@SectorType
	 insert into FlatDiscount
	(
	[SectorType],
	[AirCode],
	[Insert_date],
	[UserId],
	[IsActive],
	FlatDiscountType,
	salesFrm_date,	
	salesTo_date,	
	travelFrm_date,	
	travelTo_date,
	minFlatAmt,	
	maxFlatAmt,
	amount,
	Country,
	Username
	
	) 
	SELECT @SectorType,AirlineCode,
	GETDATE(),@UserId,1,@FlatDiscountType,
	@salesFrm_date,	
	@salesTo_date,	
	@travelFrm_date,	
	@travelTo_date,
	MinFlatAmt
	,MaxFlatAmt
	,FlatDiscount
	,@Country
	,@Username
	FROM AirlineCode_Console, @FlatDiscount
	WHERE [type]='FSC'
	
	END

	ELSE IF (@AirCode='LCC')
	 BEGIN

	Update FlatDiscount set IsActive=0 WHERE  [SectorType]=@SectorType
	 insert into FlatDiscount
	(
	[SectorType],
	[AirCode],
	[Insert_date],
	[UserId],
	[IsActive],
	FlatDiscountType,
	salesFrm_date,	
	salesTo_date,	
	travelFrm_date,	
	travelTo_date,
	minFlatAmt,	
	maxFlatAmt,
	amount,
	Country,
	Username
	) 
	SELECT @SectorType,AirlineCode,
	GETDATE(),@UserId,1,@FlatDiscountType,
	@salesFrm_date,	
	@salesTo_date,	
	@travelFrm_date,	
	@travelTo_date,
	MinFlatAmt
	,MaxFlatAmt
	,FlatDiscount
	,@Country
	,@Username
	FROM AirlineCode_Console, @FlatDiscount
	WHERE [type]='LCC'
	END

	ELSE

	BEGIN
	
	DECLARE @Id int;
	set @Id = (select top(1) [PKId] from FlatDiscount where [SectorType]=@SectorType  order by PKId desc)

		if Not Exists(select [PKId] from FlatDiscount where[SectorType]=@SectorType )
			BEGIN
				insert into FlatDiscount
(
[SectorType],
[AirCode],
[Insert_date],
[UserId],
[IsActive],
FlatDiscountType,
salesFrm_date,	
salesTo_date,	
travelFrm_date,	
travelTo_date,
minFlatAmt,	
maxFlatAmt,
amount,
Country,
Username
) SELECT
@SectorType,
@AirCode,
GETDATE(),
@UserId,
1,
@FlatDiscountType,
@salesFrm_date,	
	@salesTo_date,	
	@travelFrm_date,	
	@travelTo_date,
MinFlatAmt
,MaxFlatAmt
,FlatDiscount
,@Country
,@Username
FROM @FlatDiscount
			END

		ELSE

			BEGIN
				Update FlatDiscount set IsActive=0 where  [SectorType]=@SectorType
				insert into FlatDiscount
(
[SectorType],
[AirCode],
[Insert_date],
[UserId],
[IsActive],
FlatDiscountType,
salesFrm_date,	
salesTo_date,	
travelFrm_date,	
travelTo_date,
minFlatAmt,	
maxFlatAmt,
amount,
Country,
Username

) SELECT
@SectorType,
@AirCode,
GETDATE(),
@UserId,
1,
@FlatDiscountType,
@salesFrm_date,	
@salesTo_date,	
@travelFrm_date,	
@travelTo_date,
MinFlatAmt
,MaxFlatAmt
,FlatDiscount
,@Country,
@Username

FROM @FlatDiscount
			END

	END
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insertFlatDiscount] TO [rt_read]
    AS [dbo];

