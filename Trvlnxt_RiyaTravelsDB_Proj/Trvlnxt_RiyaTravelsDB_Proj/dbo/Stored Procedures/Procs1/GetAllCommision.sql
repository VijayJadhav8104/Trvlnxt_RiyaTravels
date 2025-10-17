
CREATE proc [dbo].[GetAllCommision]
@Start int=null,
@Pagesize int=null,
@RecordCount INT OUTPUT
  AS
  BEGIN
		BEGIN
		IF OBJECT_ID ( 'tempdb..#tempTableComission') IS NOT NULL
		DROP table  #tempTableComission
		SELECT * INTO #tempTableComission 
		from(
			SELECT 
					PKID,
					airline,
					domesticcomision,
					DomesticType,
					intcommision,
					InternationalType,
					UserId,
					FairBasis,
					Country
					FROM 
						Comission
					where
						IsACtive=1
						) p

			ORDER BY PKID DESC		
			SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA
		    SELECT * FROM #tempTableComission
			ORDER BY  PKID 
			OFFSET @Start ROWS
			FETCH NEXT @Pagesize ROWS ONLY
		END
  END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllCommision] TO [rt_read]
    AS [dbo];

