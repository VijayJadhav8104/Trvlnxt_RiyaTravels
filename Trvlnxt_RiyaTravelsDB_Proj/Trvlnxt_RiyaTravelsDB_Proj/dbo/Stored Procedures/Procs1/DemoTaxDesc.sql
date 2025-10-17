
CREATE proc [dbo].[DemoTaxDesc] 
AS
BEGIN
	DECLARE 
		@i int=1,
		@Iterator INT
	SET @Iterator = (Select Count(*) from tblPassengerBookDetails Where fkBookMaster in  (select pkId from tblBookMaster where IsBooked=1)  
					 and convert(varchar(25),inserteddate,23) between '2018-04-01' and '2018-06-14')
	
		IF OBJECT_ID('tempdb..#Results1') IS NOT NULL
		DROP TABLE #Results1; 

		;with cte
				as(SELECT fkBookMaster,DiscriptionTax, ROW_NUMBER() OVER (ORDER BY fkBookMaster) AS SNO  FROM tblPassengerBookDetails  Where fkBookMaster in  (select pkId from tblBookMaster 
				where IsBooked=1) and convert(varchar(25),inserteddate,23) between '2018-04-01' and '2018-06-14' )
				--AND airCode in ('SG','6E','G8')
					--)

		select * INTO #Results1  from cte
		--Drop Table #Results1

	WHILE (@i <= @Iterator)
	BEGIN

		DECLARE @TaxDesc varchar (max)

		SET @TaxDesc=(select DiscriptionTax FROM #Results1 WHERE SNO=@i)

		IF OBJECT_ID('tempdb..#tempTaxDesc') IS NOT NULL
		DROP TABLE #tempTaxDesc; 
		--Drop Table #temp1
		-- select * from #temp1
		SELECT ROW_NUMBER() OVER (order by item) AS RowNo  ,* INTO #tempTaxDesc
		FROM [SplitString](@TaxDesc,';') as abc 
		
		Declare @j int=1,
			@NumberRows INT 
			SET @NumberRows = (SELECT Count(*) FROM #tempTaxDesc)

		WHILE (@j <= @NumberRows)
		BEGIN

			Declare @sss varchar(10) =(SELECT Item FROM #tempTaxDesc WHERE RowNo=@j)
			
			IF(LEFT(@sss, CHARINDEX(':', @sss) - 1) != '')
			BEGIN
				INSERT INTO TaxDescTest (
					[Tax Code]
					,[Tax Nature Code]
					,Amount
					,[Document Type]
					,[Document No_]
					,[Document Line No_]
					,[Currency Code]
					,[Currency Factor]
					,[Exchange Rate]
					,[Company ID])
				SELECT LEFT(@sss, CHARINDEX(':', @sss) -1),LEFT(@sss, CHARINDEX(':', @sss) -1),(RIGHT(@sss,LEN(@sss)-CHARINDEX(':',@sss))),
					'1' as [Document Type]
					, tb.orderId as [Document No_]
					, tb.pkId  as [Document Line No_]
					, CASE WHEN tb.country='IN' THEN 'INR' WHEN tb.country='US' THEN 'USD' WHEN tb.country='CA' THEN 'CAD' ELSE '' END as [Currency Code]
					, NULL as [Currency Factor], NULL as [Exchange Rate], '3' as [Company ID]
				from tblBookMaster tb 
				--left join TBLbookItenary ti on tb.orderId=ti.orderId 
				--Left Join tblPassengerBookDetails Tpbd on tb.pkId=tpbd.fkBookMaster
				WHERE tb.pkId=(SELECT r.fkBookMaster FROM #Results1 r WHERE SNO=@i)
				--convert(varchar(25),tb.inserteddate,23) > '2018-04-01'
				order by 1
				--print @i
			END

			Set @j = @j + 1
		END

		Set @i = @i + 1


	END 
END

--select count(*) from TaxDescTest
-- Truncate table TaxDescTest


--insert into [14.143.46.138].[RCIntegrationTest].[dbo].[Booking Air Tax Line Web]
--([Document Type],[Document No_],[Document Line No_],[Tax Code],[Tax Nature Code],[Currency Code],[Amount],[Currency Factor],[Exchange Rate],[CompanyID])
--select distinct [Document Type],[Document No_],[Document Line No_],[Tax Code],[Tax Nature Code],[Currency Code],[Amount],[Currency Factor],[Exchange Rate],[Company ID] 
--from TaxDescTest



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DemoTaxDesc] TO [rt_read]
    AS [dbo];

