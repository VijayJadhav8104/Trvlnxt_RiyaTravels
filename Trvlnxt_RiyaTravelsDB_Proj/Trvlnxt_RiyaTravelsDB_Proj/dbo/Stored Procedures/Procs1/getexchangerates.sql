CREATE PROCEDURE [dbo].[getexchangerates] -- [getexchangerates] 0,'2019-11-27',10,0,null
	-- Add the parameters for the stored procedure here
	@id bigint,
	@inserteddt_dt date,
	@PageSize int =10,
	@PageIndex int =0,
	@RecordCount INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    IF(@id=0)
    BEGIN
		
		with cte
		as(
			SELECT PKID_int,currencyname_vc,currencycode_vc,cast(salerate_ft AS decimal(10,2)) AS salerate_ft
					,cast(buyrate_ft AS decimal(10,2)) AS buyrate_ft,inserteddt_dt,status,createdOn
			FROM CMS_ExchangeRates 
			WHERE inserteddt_dt=@inserteddt_dt
		)
		SELECT * INTO #Result1 FROM cte 
		ORDER BY PKID_int

		SELECT * FROM 
			(SELECT * , ROW_NUMBER() OVER (ORDER BY PKID_int asc) AS RowRank 
			 FROM  #Result1)R
			 --WHERE RowRank > (@PageIndex * @PageSize) AND RowRank <= ((@PageIndex * @PageSize) + @PageSize)

		SELECT @RecordCount = COUNT(*) FROM #Result1

	END
	ELSE 
	BEGIN
		SELECT currencycode_vc + ISNULL('-' + currencyname_vc, '') AS code,PKID_int 
		FROM [CMS_ExchangeRates] 
	END
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getexchangerates] TO [rt_read]
    AS [dbo];

