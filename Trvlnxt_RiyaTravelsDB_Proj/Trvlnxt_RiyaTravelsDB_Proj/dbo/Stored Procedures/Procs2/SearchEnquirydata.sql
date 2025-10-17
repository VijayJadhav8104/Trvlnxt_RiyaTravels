CREATE PROCEDURE [dbo].[SearchEnquirydata]
	@EnquiryType varchar(50)
	, @FromDate datetime
	, @ToDate datetime
	, @Start int=null
	, @Pagesize int=null
	, @RecordCount INT OUTPUT
	, @Country varchar(3)
AS
BEGIN
 	if(@EnquiryType ='All' AND @Country ='All') 
	begin
		IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL
 			DROP table  #tempTableA
 		
		SELECT * INTO #tempTableA  FROM (
	  		SELECT
			Name
			, Email
			, Feedback
			, IP
			, Device
			, ContactNo
			, InquiryType
			, Browser
			, InsertDateTime
			, Country
			FROM Feedback WITH(NOLOCK)
			WHERE  CONVERT(date,InsertDateTime) >= CONVERT(date,@FromDate)  
			AND CONVERT(date,InsertDateTime) <= CONVERT(date,@ToDate)
		) p
	  	ORDER BY P.InsertDateTime DESC

		SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA

		SELECT * FROM #tempTableA
		ORDER BY  InsertDateTime desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	END
	ELSE IF(@EnquiryType !='All' AND @Country !='All')
	BEGIN
		IF OBJECT_ID ( 'tempdb..#tempTableB') IS NOT NULL
 			DROP table  #tempTableB
 		
		SELECT * INTO #tempTableB FROM (
	  		SELECT 
			Name
			, Email
			, Feedback
			, IP
			, Device
			, ContactNo
			, InquiryType
			, Browser
			, InsertDateTime
			, Country
			FROM Feedback WITH(NOLOCK)
			WHERE InquiryType=@EnquiryType
			AND Country=@Country
			AND  CONVERT(date,InsertDateTime) >= CONVERT(date,@FromDate)
			AND CONVERT(date,InsertDateTime) <= CONVERT(date,@ToDate)
		) p
	  	ORDER BY P.InsertDateTime DESC

		SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA
		
		SELECT * FROM #tempTableB
		ORDER BY  InsertDateTime desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	END
	else if(@EnquiryType ='All' AND @Country !='All')
	begin
		IF OBJECT_ID ( 'tempdb..#tempTableC') IS NOT NULL
 			DROP table  tempTableC
 		
		SELECT * INTO #tempTableC from (
			SELECT
			Name
			, Email
			, Feedback
			, IP
			, Device
			, ContactNo
			, InquiryType
			, Browser
			, InsertDateTime
			, Country
			FROM Feedback WITH(NOLOCK)
	  		WHERE CONVERT(date,InsertDateTime) >= CONVERT(date,@FromDate)
			AND CONVERT(date,InsertDateTime) <= CONVERT(date,@ToDate)
			AND Country=@Country		   
	  	) p
		ORDER BY P.InsertDateTime DESC

		SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA

		SELECT * FROM #tempTableC
		ORDER BY  InsertDateTime desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	end
	else if(@EnquiryType !='All' AND @Country ='All')
	begin
		IF OBJECT_ID ( 'tempdb..#tempTableD') IS NOT NULL
 			DROP table  #tempTableD
 		
		SELECT * INTO #tempTableD from (  
	  		SELECT
			Name
			, Email
			, Feedback
			, IP
			, Device
			, ContactNo
			, InquiryType
			, Browser
			, InsertDateTime
			, Country
			, SubInquiry
			FROM Feedback WITH(NOLOCK)
	  		WHERE CONVERT(date,InsertDateTime) >= CONVERT(date,@FromDate)  
			AND CONVERT(date,InsertDateTime) <= CONVERT(date,@ToDate)
			AND InquiryType=@EnquiryType		   
		) p
	  	ORDER BY P.InsertDateTime DESC

		SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA
		
		SELECT * FROM #tempTableD
		ORDER BY  InsertDateTime desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	END
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SearchEnquirydata] TO [rt_read]
    AS [dbo];

