CREATE proc [dbo].[GenerateSalesReport]
@FromDate date=null,
@ToDate date=null,
@Client varchar(50)=null,
@Country varchar(50)=null
AS
BEGIN
		BEGIN	
		--domestic		
		IF OBJECT_ID ( 'tempdb..#tempSalesTableA') IS NOT NULL
		DROP table  #tempSalesTableA       
					SELECT * INTO #tempSalesTableA 
				  from
					(  
					  select  COUNT(P.pid) as 'TotalPax',CONVERT(DATE,P.inserteddate) AS inserteddate1
								FROM 
									tblPassengerBookDetails P,
									tblBookMaster B
								WHERE
									P.fkBookMaster=B.pkId
									AND
										B.IsBooked=1  AND B.CounterCloseTime=1
									GROUP BY 
												CONVERT(DATE,P.inserteddate)

					   ) a

					INNER JOIN tblBookMaster b 
						on CONVERT(DATE,b.inserteddate)=CONVERT(DATE,a.inserteddate1)

					select count(pkId) AS 'count',ROW_NUMBER() over(order by  count(pkId))as 'SrNoDom',
								CONVERT(date,inserteddate) AS 'Dates',								
								ISNULL(sum(totalFare),0) AS 'Sales',
								sum(FlatDiscount+PromoDiscount) AS 'discount',
								ISNULL(sum(TotalMarkup),0) AS 'Convinence Fee',TotalPax from #tempSalesTableA
			
								WHERE IsBooked=1
									AND
									(
										 -- (CONVERT(date,inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
											-- AND 
											--(CONVERT(date,inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL)
											CONVERT(date,inserteddate)>=convert(date,@FromDate)
												and
												CONVERT(date,inserteddate)<=convert(date,@ToDate)
									)
									  AND
									  (Country=@Country or @Country is null or @Country='')
									  AND
									  (AgentID = @Client or AgentID not in ('B2C') or @Client is null or @Client='')
									  and
											CounterCloseTime=1
										GROUP BY 
											CONVERT(date,inserteddate),TotalPax
											order by CONVERT(date,inserteddate) asc


					--international

					IF OBJECT_ID ( 'tempdb..#tempSalesTableB') IS NOT NULL
					DROP table  #tempSalesTableB  
					SELECT * INTO #tempSalesTableB
					from
					(  
						select COUNT(P.pid) as 'TotalPax',CONVERT(DATE,P.inserteddate) AS inserteddate1
						FROM 
							tblPassengerBookDetails P,
							tblBookMaster B
						WHERE
							P.fkBookMaster=B.pkId
							AND
								B.IsBooked=1 AND 
									B.CounterCloseTime=2
							GROUP BY 
										CONVERT(DATE,P.inserteddate)

					) a

				INNER JOIN tblBookMaster b 
					on 
						CONVERT(DATE,b.inserteddate)= CONVERT(DATE,a.inserteddate1)

				select count(pkId) AS 'countIn',ROW_NUMBER() over(order by  count(pkId))as 'SrNoIn',
					CONVERT(date,inserteddate) AS 'Dates',
					ISNULL(sum(totalFare),0) AS 'SalesIn',
					sum(FlatDiscount+PromoDiscount) AS 'discountIn',
					ISNULL(sum(TotalMarkup),0) AS 'Convinence FeeIn',TotalPax from #tempSalesTableB
			
					WHERE IsBooked=1
						AND
							(
								--(CONVERT(date,inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
								--	AND 
								--(CONVERT(date,inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL)
								CONVERT(date,inserteddate)>=convert(date,@FromDate)
								and
								CONVERT(date,inserteddate)<=convert(date,@ToDate)
							)
						AND
							(Country=@Country or @Country is null or @Country='')
							AND
								(AgentID = @Client or AgentID not in ('B2C') or @Client is null or @Client='')
						AND
								CounterCloseTime=2
							GROUP BY 
								CONVERT(date,inserteddate),TotalPax
								order by CONVERT(date,inserteddate) asc

		END
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GenerateSalesReport] TO [rt_read]
    AS [dbo];

