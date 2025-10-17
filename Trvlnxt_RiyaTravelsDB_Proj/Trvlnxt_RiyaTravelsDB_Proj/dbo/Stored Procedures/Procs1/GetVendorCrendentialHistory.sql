CREATE PROC GetVendorCrendentialHistory
	@VendorID INT,
	@OfficeID varchar(100)='',
	@FromDate   datetime,
	@ToDate		datetime,
	@Start int=null,
	@Pagesize int=null,
	@Userid int=null,
	@RecordCount INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID ( 'tempdb..#tempTablev') IS NOT NULL
	DROP table  #tempTablev
	SELECT * INTO #tempTablev 
	FROM
	(  
		SELECT history.ID,History.VendorID,vendor.VendorName,History.OfficeId,History.Field,History.Value,History.FareType,History.ApiIndicator,
		OidName,Vendorcode,Billingusertype,Erpcountry,Iatanumber,CountryHistoryId,
		U.UserName as 'ModifiedBy',History.ModifiedOn 
		FROM mVendorCredentialHistory as History
		INNER JOIN mVendor vendor on vendor.ID=History.VendorID
		INNER JOIN mUser U on U.ID=History.ModifiedBy

		WHERE  CONVERT(date,History.ModifiedOn) >= CONVERT(date,@FromDate)  
		AND CONVERT(date,History.ModifiedOn) <= CONVERT(date,@ToDate)
		AND VendorID=@VendorID AND (@OfficeID='' OR History.OfficeId=@OfficeID)
		 ) p 
	ORDER BY p.ModifiedOn DESC

		SELECT @RecordCount = @@ROWCOUNT

		SELECT * FROM #tempTablev
		ORDER BY  ModifiedOn desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY

	
END
