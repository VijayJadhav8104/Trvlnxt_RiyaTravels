-- =============================================
-- Author:		Bhavika kawa
-- Create date: 25/06/2020
-- Description: For Airline consolidated report
-- [Sp_AirlineConsolidatedReport] '','','','','','','',''
-- =============================================
CREATE PROCEDURE [dbo].[Sp_AirlineConsolidatedReport-05-10-2020]--[Sp_AirlineConsolidatedReport] '','','','','IN','','',''
	@FromDate Date=null, 
	@ToDate Date=null, 
	@BranchCode varchar(40)=null, 
	@AgentTypeId int=null,
	@Country varchar(10)=null, 
	@AgentId int=null,	
	@AirlineCategory varchar(10)=null,
	@AirlineCode varchar(10)=null
AS
BEGIN

if (@Country!='IN')
BEGIN
	select BM.airName as 'Airline Name',
	(COUNT(CASE WHEN UPPER(PD.paxType) IN ('ADT','ADULT') THEN 1 END)) Adult,
	(COUNT(CASE WHEN UPPER(PD.paxType) IN ('CHD','CHILD') THEN 1 END)) Child,
	(COUNT(CASE WHEN UPPER(PD.paxType) IN ('INF','INFANT') THEN 1 END)) Infant,

	CAST(SUM(PD.basicFare)as numeric(18,2)) as 'Basic Fare',
	SUM(CAST((PD.YQ) AS numeric(18,2))) as YQTax,
	CAST(SUM(PD.totalTax-PD.YQ)as numeric(18,2)) as 'Tax Others',
	CAST(SUM(isnull(PD.Markup,0) + isnull(bm.AgentMarkup,0) + isnull(pr.ServiceFee,0))as numeric(18,2)) as 'Mark Up',
	CAST(SUM(PD.totalFare)as numeric(18,2)) as 'Net Amount',
	cast(SUM(PD.totalFare+BM.TotalDiscount + isnull(PD.Markup,0) +  isnull(bm.AgentMarkup,0) + isnull(pr.ServiceFee,0)) as numeric(18,2)) as 'Gross Amount',

	count(PD.pid) as 'No of Tickets' 
	
	into #Temp1

	from tblBookMaster BM
	inner join tblPassengerBookDetails PD on PD.fkBookMaster=BM.pkId AND BM.IsBooked=1
	LEFT JOIN B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=BM.AgentID
	INNER JOIN AirlineCode_Console A ON A.AirlineCode=BM.airCode
	left join agentLogin AL ON CAST(AL.UserID AS VARCHAR(50))=BM.AgentID
	left join PNRRetriveDetails PR on PR.OrderID=BM.orderId
	where ((@FROMDate = '') or (CONVERT(date,BM.inserteddate) >= CONVERT(date,@FROMDate)))
 		 AND ((@ToDate = '') or (CONVERT(date,BM.inserteddate) <= CONVERT(date, @ToDate)))
 		 AND ((@BranchCode = '') or (@BranchCode!='BOMRC' AND (@AgentTypeId !=1  OR  @AgentTypeId='') AND R.LocationCode = @BranchCode)
				or (@BranchCode='BOMRC' and BM.AgentID='B2C' AND BM.Country='IN'))
		AND ((@AgentTypeId = '') or ((@AgentTypeId!=1  OR  @AgentTypeId='')AND AL.UserTypeID = @AgentTypeId ) OR ((@AgentTypeId=1 OR   @AgentTypeId='')AND BM.AgentID='B2C') )
 		 AND ((cast(@AgentId as varchar(50)) = '0') 
or  ((@AgentTypeId!=1 OR  @AgentTypeId='') and cast(@AgentId as varchar(50)) != '0' and BM.AgentID =cast(@AgentId as varchar(50))))
		 AND ((@Country = '') or (al.BookingCountry = @Country AND(@AgentTypeId!=1 OR  @AgentTypeId=''))
		  OR ((@AgentTypeId=1 OR @AgentTypeId='') AND BM.Country=@Country))
		 AND ((@AirlineCategory = '') or (A.type = @AirlineCategory))
		 AND ((@AirlineCode = '') or (BM.airCode = @AirlineCode))
		 
	group by BM.airName
	select * from #Temp1
	select * from #Temp1

	select 
	'Total'as Total ,
	SUM(Adult) as ATotal, 
	SUM(Child) as 'CTotal' , 
	SUM(Infant) as 'ITotal', 
	SUM([Basic Fare]) as 'BTotal', 
	SUM(YQTax) as 'TYQTax',
	SUM([Tax Others]) as 'TTotal',
	SUM([Mark Up]) as 'MTotal',
	SUM([Net Amount]) as 'NTotal',
	SUM([Gross Amount]) as 'GTotal', 
	SUM([No of Tickets]) as 'TicketTotal'
	from  #Temp1

drop table #Temp1
END
ELSE
BEGIN
	select BM.airName as 'Airline Name',
	(COUNT(CASE WHEN UPPER(PD.paxType) IN ('ADT','ADULT') THEN 1 END)) Adult,
	(COUNT(CASE WHEN UPPER(PD.paxType) IN ('CHD','CHILD') THEN 1 END)) Child,
	(COUNT(CASE WHEN UPPER(PD.paxType) IN ('INF','INFANT') THEN 1 END)) Infant,

	CAST((SUM(PD.basicFare) * BM.ROE) as numeric(18,0)) as 'Basic Fare',
	SUM(CAST(((PD.YQ) * BM.ROE) AS numeric(18,0)))  as YQTax,
	CAST((SUM(PD.totalTax-PD.YQ)* BM.ROE) as numeric(18,0)) as 'Tax Others',
	CAST(((SUM(isnull(PD.Markup,0) + isnull(bm.AgentMarkup,0) + isnull(pr.ServiceFee,0))) * BM.ROE)as numeric(18,0)) as 'Mark Up',
	CAST((SUM(PD.totalFare) * BM.ROE)as numeric(18,0)) as 'Net Amount',
	cast(((SUM(PD.totalFare+BM.TotalDiscount + isnull(PD.Markup,0) +  isnull(bm.AgentMarkup,0) + isnull(pr.ServiceFee,0)))* BM.ROE) as numeric(18,0)) as 'Gross Amount',

	count(PD.pid) as 'No of Tickets' 
	
	into #Temp2

	from tblBookMaster BM
	inner join tblPassengerBookDetails PD on PD.fkBookMaster=BM.pkId AND BM.IsBooked=1
	LEFT JOIN B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=BM.AgentID
	left JOIN AirlineCode_Console A ON A.AirlineCode=BM.airCode
	left join agentLogin AL ON CAST(AL.UserID AS VARCHAR(50))=BM.AgentID
	left join PNRRetriveDetails PR on PR.OrderID=BM.orderId
--	where ((@FROMDate = '') or (CONVERT(date,BM.inserteddate) >= CONVERT(date,@FROMDate)))
-- 		 AND ((@ToDate = '') or (CONVERT(date,BM.inserteddate) <= CONVERT(date, @ToDate)))
-- 		 AND ((@BranchCode = '') or (@BranchCode!='BOMRC' AND (@AgentTypeId !=1  OR  @AgentTypeId='') AND R.LocationCode = @BranchCode)
--				or (@BranchCode='BOMRC' and BM.AgentID='B2C' AND BM.Country='IN'))
--		AND ((@AgentTypeId = '') or ((@AgentTypeId!=1  OR  @AgentTypeId='')AND AL.UserTypeID = @AgentTypeId ) OR ((@AgentTypeId=1 OR   @AgentTypeId='')AND BM.AgentID='B2C') )
-- 		 AND ((cast(@AgentId as varchar(50)) = '0') 
--or  ((@AgentTypeId!=1 OR  @AgentTypeId='') and cast(@AgentId as varchar(50)) != '0' and BM.AgentID =cast(@AgentId as varchar(50))))
--		 AND ((@Country = '') or (al.BookingCountry = @Country AND(@AgentTypeId!=1 OR  @AgentTypeId=''))
--		  OR ((@AgentTypeId=1 OR @AgentTypeId='') AND BM.Country=@Country))
--		 AND ((@AirlineCategory = '') or (A.type = @AirlineCategory))
--		 AND ((@AirlineCode = '') or (BM.airCode = @AirlineCode))
		 
	group by BM.airName,BM.ROE

	select * from #Temp2
	select * from #Temp2

	select 
	'Total'as Total ,
	SUM(Adult) as ATotal, 
	SUM(Child) as 'CTotal' , 
	SUM(Infant) as 'ITotal', 
	SUM([Basic Fare]) as 'BTotal', 
	SUM(YQTax) as 'TYQTax',
	SUM([Tax Others]) as 'TTotal',
	SUM([Mark Up]) as 'MTotal',
	SUM([Net Amount]) as 'NTotal',
	SUM([Gross Amount]) as 'GTotal', 
	SUM([No of Tickets]) as 'TicketTotal'
	from  #Temp2

drop table #Temp2
END
	
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_AirlineConsolidatedReport-05-10-2020] TO [rt_read]
    AS [dbo];

