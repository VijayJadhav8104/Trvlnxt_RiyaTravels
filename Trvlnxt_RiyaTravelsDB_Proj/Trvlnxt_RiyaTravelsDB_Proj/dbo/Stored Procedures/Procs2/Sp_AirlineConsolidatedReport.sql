      
CREATE PROCEDURE [dbo].[Sp_AirlineConsolidatedReport] --'4-feb-2021','4-feb-2021',NULL,NULL,'IN',NULL,NULL,NULL      
 @FROMDate Date=NULL      
 , @ToDate Date=NULL      
 , @BranchCode varchar(40)=NULL      
 , @AgentTypeId varchar(50)=NULL      
 , @Country varchar(100)=NULL      
 , @AgentId int=NULL      
 , @AirlineCategory varchar(10)=NULL      
 , @AirlineCode varchar(max)=NULL      
 , @AccountType varchar(20)=''      
AS      
BEGIN      
 IF(@Country!='')      
 BEGIN      
  IF(@Country!='IN')      
  BEGIN      
     SELECT      
   BM.airName AS 'Airline Name'      
   , (COUNT(CASE WHEN UPPER(PD.paxType) IN ('ADT','ADULT') THEN 1 END)) Adult      
   , (COUNT(CASE WHEN UPPER(PD.paxType) IN ('CHD','CHILD') THEN 1 END)) Child      
   , (COUNT(CASE WHEN UPPER(PD.paxType) IN ('INF','INFANT') THEN 1 END)) Infant      
   , CAST(SUM(PD.basicFare)AS NUMERIC(18,2)) AS 'Basic Fare'      
   , SUM(CAST((PD.YQ) AS NUMERIC(18,2))) AS YQTax      
   , CAST(SUM(PD.totalTax-CAST((PD.YQ) AS NUMERIC(18,2)))AS NUMERIC(18,2)) AS 'Tax Others'      
   , CAST(SUM(ISNULL(PD.B2BMarkup,0))AS NUMERIC(18,2)) AS 'Hidden Markup'   ,   
    SUM(CASE WHEN (pd.MarkOn IS NULL OR pd.MarkOn = 'Markup on Base') THEN ISNULL(pd.BFC, 0) ELSE 0 END) AS 'Markup on fare',
	SUM(CASE WHEN pd.MarkOn = 'Markup on Tax' THEN ISNULL(pd.BFC, 0) ELSE 0 END) AS 'Markup on tax'    
   , SUM(ISNULL(PD.ServiceFee,0)) AS 'Service Fee'      
   , CAST(SUM(PD.totalFare)AS NUMERIC(18,2)) AS 'Net Amount'      
   , CAST(SUM(PD.totalFare + ISNULL(PD.B2BMarkup,0) + ISNULL(PD.BFC,0) + ISNULL(PD.ServiceFee,0)) AS NUMERIC(18,2)) AS 'Gross Amount'      
   , count(PD.pid) AS 'No of Tickets'      
   INTO #Temp      
   FROM tblBookMaster BM WITH(NOLOCK)      
   INNER JOIN tblPassengerBookDetails PD WITH(NOLOCK) ON PD.fkBookMaster=BM.pkId AND BM.IsBooked=1      
   LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=BM.AgentID      
   INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=BM.airCode      
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=BM.AgentID      
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID=BM.orderId      
   where ((@FROMDate = '') OR (CONVERT(date,BM.inserteddate) >= CONVERT(date,@FROMDate)))      
   AND ((@ToDate = '') OR (CONVERT(date,BM.inserteddate) <= CONVERT(date, @ToDate)))      
   AND ((@BranchCode = '') OR (@BranchCode!='BOMRC' AND (@AgentTypeId !='1' OR @AgentTypeId='') AND R.LocationCode = @BranchCode)      
   OR (@BranchCode='BOMRC' AND BM.AgentID='B2C' AND BM.Country='IN'))      
   --AND ((@AgentTypeId = '') OR ((@AgentTypeId!=1 OR @AgentTypeId='')AND AL.UserTypeID = @AgentTypeId ) OR ((@AgentTypeId=1 OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((@AgentTypeId = '') OR ((@AgentTypeId!='1' OR @AgentTypeId='')AND AL.UserTypeID IN (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))) OR ((@AgentTypeId='1' OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((CAST(@AgentId AS varchar(50)) = '0')      
   OR ((@AgentTypeId!='1' OR @AgentTypeId='') AND CAST(@AgentId AS varchar(50)) != '0' AND BM.AgentID =CAST(@AgentId AS varchar(50))))      
   --AND ((@Country = '') OR (al.BookingCountry = @Country AND(@AgentTypeId!=1 OR @AgentTypeId='')) OR ((@AgentTypeId=1 OR @AgentTypeId='') AND BM.Country=@Country))      
   AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ',')) AND(@AgentTypeId!='1' OR @AgentTypeId=''))OR ((@AgentTypeId='1' OR @AgentTypeId='') AND BM.Country IN (SELECT Data FROM sample_split(@Country, ','))))      
   AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))      
   AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))      
   --Jitendra Nakum Add Multiple Airline filter instead of single selection      
   AND (@AirlineCode = '' OR BM.airCode IN (SELECT Data FROM sample_split(@AirlineCode, ',')))      
   --AND ((@AirlineCode = '') OR (BM.airCode = @AirlineCode))      
   AND bm.totalFare>0 AND pd.totalFare>0      
   AND IsBooked=1      
   GROUP BY BM.airName      
      
   SELECT      
   BM.airName AS 'Airline Name'      
   , count(i.orderid) AS 'SegmentCount'      
   INTO #Temp1      
   FROM tblBookMaster BM WITH(NOLOCK)      
   INNER JOIN tblBookItenary I WITH(NOLOCK) ON I.fkBookMaster=BM.pkId      
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID=BM.orderId      
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=BM.AgentID      
   LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=BM.AgentID      
   INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=BM.airCode      
   where ((@FROMDate = '') OR (CONVERT(date,BM.inserteddate) >= CONVERT(date,@FROMDate)))      
    AND ((@ToDate = '') OR (CONVERT(date,BM.inserteddate) <= CONVERT(date, @ToDate)))      
    AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))      
   -- AND ((@AgentTypeId = '') OR ((@AgentTypeId!='1' OR @AgentTypeId='')AND AL.UserTypeID = @AgentTypeId ) OR ((@AgentTypeId=1 OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((@AgentTypeId = '') OR ((@AgentTypeId!='1' OR @AgentTypeId='')AND AL.UserTypeID IN (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))) OR ((@AgentTypeId='1' OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
    AND ((CAST(@AgentId AS varchar(50)) = '0') OR ((@AgentTypeId!='1' OR @AgentTypeId='') AND CAST(@AgentId AS varchar(50)) != '0' AND BM.AgentID =CAST(@AgentId AS varchar(50))))      
   -- AND ((@Country = '') OR (al.BookingCountry = @Country AND(@AgentTypeId!=1 OR @AgentTypeId=''))OR ((@AgentTypeId=1 OR @AgentTypeId='') AND BM.Country=@Country))      
   AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ',')) AND(@AgentTypeId!='1' OR @AgentTypeId=''))OR ((@AgentTypeId='1' OR @AgentTypeId='') AND BM.Country IN (SELECT Data FROM sample_split(@Country, ','))))      
   AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))      
   AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))      
   --Jitendra Nakum Add Multiple Airline filter instead of single selection      
   AND (@AirlineCode = '' OR BM.airCode IN (SELECT Data FROM sample_split(@AirlineCode, ',')))      
   --AND ((@AirlineCode = '') OR (BM.airCode = @AirlineCode))      
   AND IsBooked=1      
   GROUP BY BM.airName      
       
   SELECT      
   bm.orderId      
   , count(PD.pid) AS 'No of Tickets'      
   , BM.airName      
   INTO #Temp61      
   FROM tblBookMaster BM WITH(NOLOCK)      
   INNER JOIN tblPassengerBookDetails PD WITH(NOLOCK) ON PD.fkBookMaster=BM.pkId AND BM.IsBooked=1      
   LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=BM.AgentID      
   INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=BM.airCode      
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=BM.AgentID      
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID=BM.orderId      
   where ((@FROMDate = '') OR (CONVERT(date,BM.inserteddate) >= CONVERT(date,@FROMDate)))      
   AND ((@ToDate = '') OR (CONVERT(date,BM.inserteddate) <= CONVERT(date, @ToDate)))      
   AND ((@BranchCode = '') OR (@BranchCode!='BOMRC' AND (@AgentTypeId !='1' OR @AgentTypeId='') AND R.LocationCode = @BranchCode)      
   OR (@BranchCode='BOMRC' AND BM.AgentID='B2C' AND BM.Country='IN'))      
   --AND ((@AgentTypeId = '') OR ((@AgentTypeId!=1 OR @AgentTypeId='')AND AL.UserTypeID = @AgentTypeId ) OR ((@AgentTypeId=1 OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((@AgentTypeId = '') OR ((@AgentTypeId!='1' OR @AgentTypeId='')AND AL.UserTypeID IN (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))) OR ((@AgentTypeId='1' OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((CAST(@AgentId AS varchar(50)) = '0')      
   OR ((@AgentTypeId!='1' OR @AgentTypeId='') AND CAST(@AgentId AS varchar(50)) != '0' AND BM.AgentID =CAST(@AgentId AS varchar(50))))      
   AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))      
   --AND ((@Country = '') OR (al.BookingCountry = @Country AND(@AgentTypeId!=1 OR @AgentTypeId='')) OR ((@AgentTypeId=1 OR @AgentTypeId='') AND BM.Country=@Country))      
   AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ',')) AND(@AgentTypeId!='1' OR @AgentTypeId=''))OR ((@AgentTypeId='1' OR @AgentTypeId='') AND BM.Country IN (SELECT Data FROM sample_split(@Country, ','))))      
   AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))      
   --Jitendra Nakum Add Multiple Airline filter instead of single selection      
   AND (@AirlineCode = '' OR BM.airCode IN (SELECT Data FROM sample_split(@AirlineCode, ',')))      
   --AND ((@AirlineCode = '') OR (BM.airCode = @AirlineCode))      
   AND bm.totalFare>0 AND pd.totalFare>0      
   AND IsBooked=1      
   GROUP BY bm.orderId,BM.airName      
      
   SELECT      
   bm.orderId      
   , count(i.orderid) AS 'SegmentCount'      
   , BM.airName      
   INTO #Temp71      
   FROM tblBookMaster BM WITH(NOLOCK)      
   INNER JOIN tblBookItenary I WITH(NOLOCK) ON I.fkBookMaster=BM.pkId       
   LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=BM.AgentID      
   INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=BM.airCode      
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=BM.AgentID      
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID=BM.orderId      
   where ((@FROMDate = '') OR (CONVERT(date,BM.inserteddate) >= CONVERT(date,@FROMDate)))      
   AND ((@ToDate = '') OR (CONVERT(date,BM.inserteddate) <= CONVERT(date, @ToDate)))      
   AND ((@BranchCode = '') OR (@BranchCode!='BOMRC' AND (@AgentTypeId !='1' OR @AgentTypeId='') AND R.LocationCode = @BranchCode)      
   OR (@BranchCode='BOMRC' AND BM.AgentID='B2C' AND BM.Country='IN'))      
   --AND ((@AgentTypeId = '') OR ((@AgentTypeId!=1 OR @AgentTypeId='')AND AL.UserTypeID = @AgentTypeId ) OR ((@AgentTypeId=1 OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((@AgentTypeId = '') OR ((@AgentTypeId!='1' OR @AgentTypeId='')AND AL.UserTypeID IN (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))) OR ((@AgentTypeId='1' OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((CAST(@AgentId AS varchar(50)) = '0')      
   OR ((@AgentTypeId!='1' OR @AgentTypeId='') AND CAST(@AgentId AS varchar(50)) != '0' AND BM.AgentID =CAST(@AgentId AS varchar(50))))      
   --AND ((@Country = '') OR (al.BookingCountry = @Country AND(@AgentTypeId!=1 OR @AgentTypeId='')) OR ((@AgentTypeId=1 OR @AgentTypeId='') AND BM.Country=@Country))      
   AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ',')) AND(@AgentTypeId!='1' OR @AgentTypeId=''))OR ((@AgentTypeId='1' OR @AgentTypeId='') AND BM.Country IN (SELECT Data FROM sample_split(@Country, ','))))      
   AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))      
   AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))      
   --Jitendra Nakum Add Multiple Airline filter instead of single selection      
   AND (@AirlineCode = '' OR BM.airCode IN (SELECT Data FROM sample_split(@AirlineCode, ',')))      
   --AND ((@AirlineCode = '') OR (BM.airCode = @AirlineCode))      
   AND bm.totalFare>0       
   AND IsBooked=1      
   GROUP BY bm.orderId,BM.airName      
      
   SELECT      
   #Temp61.airName      
   , sum((SegmentCount) * ([No of Tickets])) AS SegmentCount      
   INTO #Temp81      
   FROM #Temp61      
   INNER JOIN #Temp71 ON #Temp71.orderId=#Temp61.orderId      
   GROUP BY #Temp61.airName      
      
   SELECT t.*,t2.SegmentCount AS 'SegmentCount'      
   INTO #Temp2      
   FROM #Temp t      
   INNER JOIN #Temp1 t1 ON t.[Airline Name]=t1.[Airline Name]      
   INNER JOIN #Temp81 t2 ON t.[Airline Name]=t2.airName      
      
   --SELECT * FROM #Temp2      
   SELECT * FROM #Temp2      
      
   SELECT      
   'Total'AS Total ,      
   SUM(Adult) AS ATotal,      
   SUM(Child) AS 'CTotal' ,      
   SUM(Infant) AS 'ITotal',      
   SUM([Basic Fare]) AS 'BTotal',      
   SUM(YQTax) AS 'TYQTax',      
   SUM([Tax Others]) AS 'TTotal',      
   SUM([Hidden Markup]) AS 'MTotal',      
   SUM([Markup on fare]) AS 'Markup on fare]',      
   SUM([Markup on tax]) AS 'Markup on tax',      
   SUM([Service Fee]) AS 'STotal',      
   SUM([Net Amount]) AS 'NTotal',      
   SUM([Gross Amount]) AS 'GTotal',      
   SUM([No of Tickets]) AS 'TicketTotal',      
   SUM([segmentCount]) AS 'TotalSegment'      
   FROM #Temp2      
         
   DROP TABLE #Temp      
   DROP TABLE #Temp1      
   DROP TABLE #Temp2      
   DROP TABLE #Temp61      
   DROP TABLE #Temp71      
   DROP TABLE #Temp81      
  END      
  ELSE      
  BEGIN      
   SELECT 
    BM.airName AS 'Airline Name',

    COUNT(CASE WHEN UPPER(PD.paxType) IN ('ADT','ADULT') THEN 1 END) AS Adult,
    COUNT(CASE WHEN UPPER(PD.paxType) IN ('CHD','CHILD') THEN 1 END) AS Child,
    COUNT(CASE WHEN UPPER(PD.paxType) IN ('INF','INFANT') THEN 1 END) AS Infant,

    SUM(CAST(PD.basicFare * BM.ROE AS NUMERIC(18,2))) AS [Basic Fare],
    SUM(CAST(PD.YQ * BM.ROE AS NUMERIC(18,2))) AS YQTax,
    SUM(CAST((PD.totalTax - PD.YQ) * BM.ROE AS NUMERIC(18,2))) AS [Tax Others],

    SUM(CAST(ISNULL(PD.B2BMarkup,0) AS NUMERIC(18,2))) AS [Hidden Markup],

    SUM(CASE WHEN (PD.MarkOn IS NULL OR PD.MarkOn = 'Markup on Base') 
             THEN ISNULL(PD.BFC, 0) ELSE 0 END) AS [Markup on fare],

    SUM(CASE WHEN PD.MarkOn = 'Markup on Tax' 
             THEN ISNULL(PD.BFC, 0) ELSE 0 END) AS [Markup on tax],

    SUM(CAST(ISNULL(PD.ServiceFee, 0) * BM.ROE AS NUMERIC(18,2))) AS [Service Fee],

    SUM(CAST(PD.totalFare * BM.ROE AS NUMERIC(18,2))) AS [Net Amount],

    SUM(CAST((PD.totalFare + ISNULL(PD.B2BMarkup,0) + ISNULL(PD.BFC,0) + ISNULL(PD.ServiceFee,0)) * BM.ROE AS NUMERIC(18,2))) AS [Gross Amount],

    COUNT(PD.pid) AS [No of Tickets]

INTO #Temp3
FROM tblBookMaster BM WITH(NOLOCK)
INNER JOIN tblPassengerBookDetails PD WITH(NOLOCK) ON PD.fkBookMaster = BM.pkId
LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50)) = BM.AgentID
INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode = BM.airCode
LEFT JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50)) = BM.AgentID
LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId
WHERE 
    ((@FROMDate = '') OR (CONVERT(DATE, BM.inserteddate) >= CONVERT(DATE, @FROMDate)))    
    AND ((@ToDate = '') OR (CONVERT(DATE, BM.inserteddate) <= CONVERT(DATE, @ToDate)))    
    AND ((@BranchCode = '') 
         OR (@BranchCode != 'BOMRC' AND (@AgentTypeId != '1' OR @AgentTypeId = '') AND R.LocationCode = @BranchCode)
         OR (@BranchCode = 'BOMRC' AND BM.AgentID = 'B2C' AND BM.Country = 'IN'))
    AND ((@AgentTypeId = '') 
         OR ((@AgentTypeId != '1' OR @AgentTypeId = '') AND AL.UserTypeID IN (SELECT CAST(Data AS INT) FROM sample_split(@AgentTypeId, ',')))
         OR ((@AgentTypeId = '1' OR @AgentTypeId = '') AND BM.AgentID = 'B2C'))
    AND ((@AccountType = '') OR (R.CustomerType = @AccountType))    
    AND ((CAST(@AgentId AS VARCHAR(50)) = '0' 
         OR ((@AgentTypeId != '1' OR @AgentTypeId = '') AND CAST(@AgentId AS VARCHAR(50)) != '0' AND BM.AgentID = CAST(@AgentId AS VARCHAR(50)))))
    AND ((@Country = '') 
         OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ',')) AND (@AgentTypeId != '1' OR @AgentTypeId = '')) 
         OR ((@AgentTypeId = '1' OR @AgentTypeId = '') AND BM.Country IN (SELECT Data FROM sample_split(@Country, ','))))
    AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))
    AND (@AirlineCode = '' OR BM.airCode IN (SELECT Data FROM sample_split(@AirlineCode, ',')))
    AND BM.IsBooked = 1 
    AND BM.totalFare > 0 
    AND PD.totalFare > 0
GROUP BY BM.airName;   
      
   SELECT      
   BM.airName AS 'Airline Name'      
   , count(i.orderid) AS 'SegmentCount'      
   INTO #Temp4      
   FROM tblBookMaster BM WITH(NOLOCK)      
   INNER JOIN tblBookItenary I WITH(NOLOCK) ON I.fkBookMaster=BM.pkId       
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID=BM.orderId      
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=BM.AgentID      
   --LEFT JOIN agentLogin AL ON AL.UserID =BM.AgentID      
   LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=BM.AgentID      
   INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=BM.airCode      
   where ((@FROMDate = '') OR (CONVERT(date,BM.inserteddate) >= CONVERT(date,@FROMDate)))      
    AND ((@ToDate = '') OR (CONVERT(date,BM.inserteddate) <= CONVERT(date, @ToDate)))      
    AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))      
   -- AND ((@AgentTypeId = '') OR ( AL.UserTypeID = @AgentTypeId) OR (@AgentTypeId='1' AND BM.AgentID='B2C'))      
   AND ((@AgentTypeId = '') OR ( AL.UserTypeID IN (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))) OR (@AgentTypeId='1' AND BM.AgentID='B2C'))      
   AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))      
    AND ((@AgentId = '') OR (BM.AgentID =CAST(@AgentId AS varchar(50))))      
   --   AND ((@Country = '') OR (al.BookingCountry = @Country) OR (@country='IN' AND BM.AgentID='B2C'))      
   AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))) OR (@country='IN' AND BM.AgentID='B2C'))      
   --AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))      
   --AND ((@AirlineCode = '') OR (BM.airCode = @AirlineCode))      
   AND bm.IsBooked=1 AND bm.totalFare>0       
   GROUP BY BM.airName      
      
      
   SELECT bm.orderId,      
   count(PD.pid) AS 'No of Tickets',BM.airName      
   INTO #Temp6      
   FROM tblBookMaster BM WITH(NOLOCK)      
   INNER JOIN tblPassengerBookDetails PD WITH(NOLOCK) ON PD.fkBookMaster=BM.pkId       
   LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=BM.AgentID      
   INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=BM.airCode      
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=BM.AgentID      
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID=BM.orderId      
   where ((@FROMDate = '') OR (CONVERT(date,BM.inserteddate) >= CONVERT(date,@FROMDate)))      
   AND ((@ToDate = '') OR (CONVERT(date,BM.inserteddate) <= CONVERT(date, @ToDate)))      
   AND ((@BranchCode = '') OR (@BranchCode!='BOMRC' AND (@AgentTypeId !='1' OR @AgentTypeId='')       
   AND R.LocationCode = @BranchCode)OR (@BranchCode='BOMRC' AND BM.AgentID='B2C' AND BM.Country='IN'))      
   --AND ((@AgentTypeId = '') OR ((@AgentTypeId!=1 OR @AgentTypeId='')AND AL.UserTypeID = @AgentTypeId ) OR ((@AgentTypeId=1 OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((@AgentTypeId = '') OR ((@AgentTypeId!='1' OR @AgentTypeId='')AND AL.UserTypeID IN (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))) OR ((@AgentTypeId='1' OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))      
   AND ((CAST(@AgentId AS varchar(50)) = '0' OR ((@AgentTypeId!='1' OR @AgentTypeId='') AND CAST(@AgentId AS varchar(50)) != '0' AND BM.AgentID =CAST(@AgentId AS varchar(50))))      
   --AND ((@Country = '') OR (al.BookingCountry = @Country AND(@AgentTypeId!=1 OR @AgentTypeId='')) OR ((@AgentTypeId=1 OR @AgentTypeId='') AND BM.Country=@Country))      
   AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ',')) AND(@AgentTypeId!='1' OR @AgentTypeId=''))OR ((@AgentTypeId='1' OR @AgentTypeId='') AND BM.Country IN (SELECT Data FROM sample_split(@Country, ','))))      
   AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))      
   --Jitendra Nakum Add Multiple Airline filter instead of single selection      
   AND (@AirlineCode = '' OR BM.airCode IN (SELECT Data FROM sample_split(@AirlineCode, ','))))      
   --AND ((@AirlineCode = '') OR (BM.airCode = @AirlineCode)))      
   AND IsBooked=1 AND bm.totalFare>0 AND pd.totalFare>0      
   GROUP BY bm.orderId,BM.airName      
      
   SELECT      
   bm.orderId      
   , count(i.orderid) AS 'SegmentCount'      
   , BM.airName      
   INTO #Temp7      
   FROM tblBookMaster BM WITH(NOLOCK)      
   INNER JOIN tblBookItenary I WITH(NOLOCK) ON I.fkBookMaster=BM.pkId       
   LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=BM.AgentID      
   INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=BM.airCode      
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=BM.AgentID      
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID=BM.orderId      
   where ((@FROMDate = '') OR (CONVERT(date,BM.inserteddate) >= CONVERT(date,@FROMDate)))      
   AND ((@ToDate = '') OR (CONVERT(date,BM.inserteddate) <= CONVERT(date, @ToDate)))      
   AND ((@BranchCode = '') OR (@BranchCode!='BOMRC' AND ( @AgentTypeId !='1' OR @AgentTypeId='')       
   AND R.LocationCode = @BranchCode)OR (@BranchCode='BOMRC' AND BM.AgentID='B2C' AND BM.Country='IN'))      
   --AND ((@AgentTypeId = '') OR ((@AgentTypeId!=1 OR @AgentTypeId='')AND AL.UserTypeID = @AgentTypeId ) OR ((@AgentTypeId=1 OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((@AgentTypeId = '') OR ((@AgentTypeId!='1' OR @AgentTypeId='')AND AL.UserTypeID IN (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))) OR ((@AgentTypeId='1' OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))      
   AND ((CAST(@AgentId AS varchar(50)) = '0' OR ((@AgentTypeId!='1' OR @AgentTypeId='') AND CAST(@AgentId AS varchar(50)) != '0' AND BM.AgentID =CAST(@AgentId AS varchar(50))))      
   --AND ((@Country = '') OR (al.BookingCountry = @Country AND(@AgentTypeId!=1 OR @AgentTypeId='')) OR ((@AgentTypeId=1 OR @AgentTypeId='') AND BM.Country=@Country))      
   AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ',')) AND(@AgentTypeId!='1' OR @AgentTypeId=''))OR ((@AgentTypeId='1' OR @AgentTypeId='') AND BM.Country IN (SELECT Data FROM sample_split(@Country, ','))))      
   AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))      
   --Jitendra Nakum Add Multiple Airline filter instead of single selection      
   AND (@AirlineCode = '' OR BM.airCode IN (SELECT Data FROM sample_split(@AirlineCode, ','))))      
   --AND ((@AirlineCode = '') OR (BM.airCode = @AirlineCode)))      
   AND IsBooked=1 AND bm.totalFare>0       
   GROUP BY bm.orderId,BM.airName      
      
   SELECT #Temp6.airName, sum((SegmentCount) * ([No of Tickets])) AS SegmentCount INTO #Temp8 FROM #Temp6      
   INNER JOIN #Temp7 ON #Temp7.orderId=#Temp6.orderId      
   GROUP BY #Temp6.airName      
       
   SELECT t.* ,t2.SegmentCount        
   INTO #Temp5      
   FROM #Temp3 t      
   INNER JOIN #Temp4 t1 ON t.[Airline Name]=t1.[Airline Name]      
   INNER JOIN #Temp8 t2 ON t.[Airline Name]=t2.airName      
      
   SELECT * FROM #Temp5      
   --SELECT * FROM #Temp5      
      
   SELECT      
   'Total'AS Total ,      
   SUM(Adult) AS ATotal,      
   SUM(Child) AS 'CTotal' ,      
   SUM(Infant) AS 'ITotal',      
   SUM([Basic Fare]) AS 'BTotal',      
   SUM(YQTax) AS 'TYQTax',      
   SUM([Tax Others]) AS 'TTotal',      
   SUM([Hidden Markup]) AS 'MTotal',      
   SUM([Markup on fare]) AS 'Markup on fare]',      
   SUM([Markup on tax]) AS 'Markup on tax',      
   SUM([Service Fee]) AS 'STotal',      
   SUM([Net Amount]) AS 'NTotal',      
   SUM([Gross Amount]) AS 'GTotal',      
   SUM([No of Tickets]) AS 'TicketTotal',      
   SUM([segmentCount]) AS 'TotalSegment'      
   FROM #Temp5      
      
   DROP TABLE #Temp3      
   DROP TABLE #Temp4      
   DROP TABLE #Temp5      
   DROP TABLE #Temp6      
   DROP TABLE #Temp7      
   DROP TABLE #Temp8      
  END      
 END      
 ELSE      
 BEGIN      
  IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL      
   DROP TABLE #tempTableA      
      
  SELECT * INTO #tempTableA FROM (       
   SELECT      
   BM.airName AS 'Airline Name'      
   , (COUNT(CASE WHEN UPPER(PD.paxType) IN ('ADT','ADULT') THEN 1 END)) Adult      
   , (COUNT(CASE WHEN UPPER(PD.paxType) IN ('CHD','CHILD') THEN 1 END)) Child      
   , (COUNT(CASE WHEN UPPER(PD.paxType) IN ('INF','INFANT') THEN 1 END)) Infant      
   , CAST(SUM(PD.basicFare) AS NUMERIC(18,2)) AS 'Basic Fare'      
   , SUM(CAST((PD.YQ) AS NUMERIC(18,2))) AS YQTax      
   , CAST(SUM(PD.totalTax-CAST((PD.YQ) AS NUMERIC(18,2))) AS NUMERIC(18,2)) AS 'Tax Others'      
   --, CAST(SUM(ISNULL(PD.B2BMarkup,0) + ISNULL(PD.BFC,0)) AS NUMERIC(18,2)) AS 'Mark Up'      
   , CAST(SUM(ISNULL(PD.B2BMarkup,0))AS NUMERIC(18,2)) AS 'Hidden Markup'      
, SUM(CASE WHEN (pd.MarkOn IS NULL OR pd.MarkOn='Markup on Base')     
           THEN ISNULL(pd.BFC,0) ELSE 0 END) AS 'Markup on fare'      
    
, SUM(CASE WHEN pd.MarkOn='Markup on Tax'     
           THEN ISNULL(pd.BFC,0) ELSE 0 END) AS 'Markup on tax'    
   , SUM(ISNULL(PD.ServiceFee,0)) AS 'Service Fee'      
   , CAST(SUM(PD.totalFare)AS NUMERIC(18,2)) AS 'Net Amount'      
   , CAST(SUM(PD.totalFare+ ISNULL(PD.B2BMarkup,0) + ISNULL(PD.BFC,0) + ISNULL(PD.ServiceFee,0)) AS NUMERIC(18,2)) AS 'Gross Amount'      
   , count(PD.pid) AS 'No of Tickets'      
   FROM tblBookMaster BM WITH(NOLOCK)      
   INNER JOIN tblPassengerBookDetails PD WITH(NOLOCK) ON PD.fkBookMaster=BM.pkId AND BM.IsBooked=1      
   LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=BM.AgentID      
   INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=BM.airCode      
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=BM.AgentID      
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID=BM.orderId      
   where ((@FROMDate = '') OR (CONVERT(date,BM.inserteddate) >= CONVERT(date,@FROMDate)))      
   AND ((@ToDate = '') OR (CONVERT(date,BM.inserteddate) <= CONVERT(date, @ToDate)))      
   AND ((@BranchCode = '') OR (@BranchCode!='BOMRC' AND (@AgentTypeId !='1' OR @AgentTypeId='') AND R.LocationCode = @BranchCode)      
   OR (@BranchCode='BOMRC' AND BM.AgentID='B2C' AND BM.Country='IN'))      
   --AND ((@AgentTypeId = '') OR ((@AgentTypeId!=1 OR @AgentTypeId='')AND AL.UserTypeID = @AgentTypeId ) OR ((@AgentTypeId=1 OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((@AgentTypeId = '') OR ((@AgentTypeId!='1' OR @AgentTypeId='')AND AL.UserTypeID IN (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))) OR ((@AgentTypeId='1' OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))      
   AND ((CAST(@AgentId AS varchar(50)) = '0')      
   OR((@AgentTypeId!='1' OR @AgentTypeId='') AND CAST(@AgentId AS varchar(50)) != '0' AND BM.AgentID =CAST(@AgentId AS varchar(50))))      
   --AND ((al.BookingCountry !='IN' AND(@AgentTypeId!=1 OR @AgentTypeId=''))OR ((@AgentTypeId=1 OR @AgentTypeId='') AND BM.Country=@Country))      
   AND ((al.BookingCountry !='IN' AND(@AgentTypeId!='1' OR @AgentTypeId=''))OR ((@AgentTypeId='1' OR @AgentTypeId='') AND BM.Country IN (SELECT Data FROM sample_split(@Country, ','))))      
   AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))      
   --Jitendra Nakum Add Multiple Airline filter instead of single selection      
   AND (@AirlineCode = '' OR BM.airCode IN (SELECT Data FROM sample_split(@AirlineCode, ',')))      
   --AND ((@AirlineCode = '') OR (BM.airCode = @AirlineCode))      
   GROUP BY BM.airName--,pd.MarkOn      
      
   UNION      
      
   SELECT BM.airName AS 'Airline Name',      
   (COUNT(CASE WHEN UPPER(PD.paxType) IN ('ADT','ADULT') THEN 1 END)) Adult,      
   (COUNT(CASE WHEN UPPER(PD.paxType) IN ('CHD','CHILD') THEN 1 END)) Child,      
   (COUNT(CASE WHEN UPPER(PD.paxType) IN ('INF','INFANT') THEN 1 END)) Infant,      
   CAST((SUM(PD.basicFare) * BM.ROE) AS NUMERIC(18,2)) AS 'Basic Fare',      
   SUM(CAST(((PD.YQ) * BM.ROE) AS NUMERIC(18,2))) AS YQTax,      
   CAST((SUM(PD.totalTax-CAST((PD.YQ) AS NUMERIC(18,2)))* BM.ROE) AS NUMERIC(18,2)) AS 'Tax Others',      
   --CAST(((SUM(ISNULL(PD.B2BMarkup,0) + ISNULL(PD.BFC,0))) * BM.ROE)AS NUMERIC(18,2)) AS 'Mark Up',      
   CAST(SUM(ISNULL(PD.B2BMarkup,0))AS NUMERIC(18,2)) AS 'Hidden Markup'      
   ,    
    SUM(CASE WHEN (PD.MarkOn IS NULL OR PD.MarkOn='Markup on Base')     
           THEN ISNULL(pd.BFC,0) ELSE 0 END) AS 'Markup on fare'      
    
, SUM(CASE WHEN pd.MarkOn='Markup on Tax'     
           THEN ISNULL(pd.BFC,0) ELSE 0 END) AS 'Markup on tax',    
   (SUM(ISNULL(PD.ServiceFee,0))* BM.ROE) AS 'Service Fee',      
   CAST((SUM(PD.totalFare) * BM.ROE) AS NUMERIC(18,0)) AS 'Net Amount',      
   CAST(((SUM(PD.totalFare+ ISNULL(PD.B2BMarkup,0) + ISNULL(PD.BFC,0) + ISNULL(PD.ServiceFee,0)))* BM.ROE) AS NUMERIC(18,2)) AS 'Gross Amount',      
   count(PD.pid) AS 'No of Tickets'      
   FROM tblBookMaster BM WITH(NOLOCK)      
   INNER JOIN tblPassengerBookDetails PD WITH(NOLOCK) ON PD.fkBookMaster=BM.pkId AND BM.IsBooked=1      
   LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=BM.AgentID      
   INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=BM.airCode      
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=BM.AgentID      
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID=BM.orderId      
   where ((@FROMDate = '') OR (CONVERT(date,BM.inserteddate) >= CONVERT(date,@FROMDate)))      
   AND ((@ToDate = '') OR (CONVERT(date,BM.inserteddate) <= CONVERT(date, @ToDate)))      
   AND ((@BranchCode = '') OR (@BranchCode!='BOMRC' AND (@AgentTypeId !='1' OR @AgentTypeId='') AND R.LocationCode = @BranchCode)      
   OR (@BranchCode='BOMRC' AND BM.AgentID='B2C' AND BM.Country='IN'))      
   --AND ((@AgentTypeId = '') OR ((@AgentTypeId!=1 OR @AgentTypeId='')AND AL.UserTypeID = @AgentTypeId ) OR ((@AgentTypeId=1 OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((@AgentTypeId = '') OR ((@AgentTypeId!='1' OR @AgentTypeId='')AND AL.UserTypeID IN (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))) OR ((@AgentTypeId='1' OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
   AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))      
   AND ((CAST(@AgentId AS varchar(50)) = '0')      
   OR ((@AgentTypeId!='1' OR @AgentTypeId='') AND CAST(@AgentId AS varchar(50)) != '0' AND BM.AgentID =CAST(@AgentId AS varchar(50))))      
   --AND ((al.BookingCountry = 'IN' AND(@AgentTypeId!=1 OR @AgentTypeId='')) OR ((@AgentTypeId=1 OR @AgentTypeId='') AND BM.Country=@Country))      
   AND ((al.BookingCountry !='IN' AND(@AgentTypeId!='1' OR @AgentTypeId=''))OR ((@AgentTypeId='1' OR @AgentTypeId='') AND BM.Country IN (SELECT Data FROM sample_split(@Country, ','))))      
   AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))      
   --Jitendra Nakum Add Multiple Airline filter instead of single selection      
   AND (@AirlineCode = '' OR BM.airCode IN (SELECT Data FROM sample_split(@AirlineCode, ',')))      
   --AND ((@AirlineCode = '') OR (BM.airCode = @AirlineCode))      
   GROUP BY BM.airName,BM.ROE--,pd.MarkOn      
  ) P      
      
  SELECT BM.airName AS 'Airline Name',count(i.orderid) AS 'SegmentCount'      
  INTO #tempTableB      
  FROM tblBookMaster BM WITH(NOLOCK)      
  INNER JOIN tblBookItenary I WITH(NOLOCK) ON I.fkBookMaster=BM.pkId      
  LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID=BM.orderId      
  LEFT JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=BM.AgentID      
  LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=BM.AgentID      
  INNER JOIN AirlineCode_Console A WITH(NOLOCK) ON A.AirlineCode=BM.airCode      
  where ((@FROMDate = '') OR (CONVERT(date,BM.inserteddate) >= CONVERT(date,@FROMDate)))      
   AND ((@ToDate = '') OR (CONVERT(date,BM.inserteddate) <= CONVERT(date, @ToDate)))      
   AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))      
  -- AND ((@AgentTypeId = '') OR ((@AgentTypeId!=1 OR @AgentTypeId='')AND AL.UserTypeID = @AgentTypeId ) OR ((@AgentTypeId=1 OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
  AND ((@AgentTypeId = '') OR ((@AgentTypeId!='1' OR @AgentTypeId='')AND AL.UserTypeID IN (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))) OR ((@AgentTypeId='1' OR  @AgentTypeId='')AND BM.AgentID='B2C') )      
  AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))      
  AND ((CAST(@AgentId AS varchar(50)) = '0')      
    OR ((@AgentTypeId!='1' OR @AgentTypeId='') AND CAST(@AgentId AS varchar(50)) != '0' AND BM.AgentID =CAST(@AgentId AS varchar(50))))      
  -- AND ((@Country = '') OR (al.BookingCountry = @Country))       
  AND ((@AirlineCategory = '') OR (A.type = @AirlineCategory))      
  --Jitendra Nakum Add Multiple Airline filter instead of single selection      
  AND (@AirlineCode = '' OR BM.airCode IN (SELECT Data FROM sample_split(@AirlineCode, ',')))      
  --AND ((@AirlineCode = '') OR (BM.airCode = @AirlineCode))      
  AND IsBooked=1      
  GROUP BY BM.airName      
       
  SELECT t.*,t1.SegmentCount AS 'SegmentCount'      
  INTO #tempTableC      
  FROM #tempTableA t      
  INNER JOIN #tempTableB t1 ON t.[Airline Name]=t1.[Airline Name]      
      
  --SELECT * FROM #tempTableC      
  SELECT * FROM #tempTableC      
      
  SELECT      
  'Total'AS Total ,      
  SUM(Adult) AS ATotal,      
  SUM(Child) AS 'CTotal' ,      
  SUM(Infant) AS 'ITotal',      
  SUM([Basic Fare]) AS 'BTotal',      
  SUM(YQTax) AS 'TYQTax',      
  SUM([Tax Others]) AS 'TTotal',      
  SUM([Hidden Markup]) AS 'MTotal',      
  SUM([Markup on fare]) AS 'Markup on fare]',      
  SUM([Markup on tax]) AS 'Markup on tax',      
  SUM([Service Fee]) AS 'STotal',      
  SUM([Net Amount]) AS 'NTotal',      
  SUM([Gross Amount]) AS 'GTotal',      
  SUM([No of Tickets]) AS 'TicketTotal',      
  SUM([SegmentCount]) AS 'TotalSegment'      
  FROM #tempTableC      
      
  DROP TABLE #tempTableB      
  DROP TABLE #tempTableC      
 END      
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_AirlineConsolidatedReport] TO [rt_read]
    AS [dbo];

