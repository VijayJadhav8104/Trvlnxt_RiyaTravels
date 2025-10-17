
CREATE proc [dbo].[CMS_GetFAQByCountry]
@Country varchar(100),
@Start int=null,
@Pagesize int=null,
@RecordCount INT OUTPUT
AS
BEGIN
	Begin
		IF OBJECT_ID ( 'tempdb..#tempTableFAQ') IS NOT NULL
			DROP table  #tempTableFAQ
			SELECT * INTO #tempTableFAQ
			from(
				SELECT 
						Id,
						Question,
						Answer
						FROM 
							CMS_FAQ
						where
							Country=@Country
							) p

				ORDER BY Id DESC		
				SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA
				SELECT * FROM #tempTableFAQ
				ORDER BY  Id 
				OFFSET @Start ROWS
				FETCH NEXT @Pagesize ROWS ONLY
		END
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_GetFAQByCountry] TO [rt_read]
    AS [dbo];

