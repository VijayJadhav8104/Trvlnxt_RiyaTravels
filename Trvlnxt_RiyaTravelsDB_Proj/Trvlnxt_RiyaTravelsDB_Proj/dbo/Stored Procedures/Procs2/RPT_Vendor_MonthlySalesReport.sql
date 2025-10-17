  
CREATE PROCEDURE [dbo].[RPT_Vendor_MonthlySalesReport]      
 @Date DATETIME  
  
AS  
BEGIN  
DECLARE @USExcRate DECIMAL(18, 2)  
 SET @USExcRate=(SELECT TOP 1 ROE FROM ROE WITH(NOLOCK) WHERE IsActive=1 AND FromCur='USD' AND ToCur='INR' ORDER BY Id DESC)  
 DECLARE @CanadaExcRate DECIMAL(18, 2)  
 SET @CanadaExcRate=(SELECT TOP 1 ROE FROM ROE WITH(NOLOCK) WHERE IsActive=1 AND FromCur='CAD' AND ToCur='INR' ORDER BY Id DESC)  
 DECLARE @UAEExcRate DECIMAL(18, 2)  
 SET @UAEExcRate=(SELECT TOP 1 ROE FROM ROE WITH(NOLOCK) WHERE IsActive=1 AND FromCur='AED' AND ToCur='INR' ORDER BY Id DESC)  
 DECLARE @GBPExcRate DECIMAL(18, 2)  
 SET @GBPExcRate=(SELECT TOP 1 ROE FROM ROE WITH(NOLOCK) WHERE IsActive=1 AND FromCur='GBP' AND ToCur='INR' ORDER BY Id DESC)  
 DECLARE @SARExcRate DECIMAL(18, 2)  
 SET @SARExcRate=(SELECT TOP 1 ROE FROM ROE WITH(NOLOCK) WHERE IsActive=1 AND FromCur='SAR' AND ToCur='INR' ORDER BY Id DESC)  
 DECLARE @THBExcRate DECIMAL(18, 2)  
 SET @THBExcRate=(SELECT TOP 1 ROE FROM ROE WITH(NOLOCK) WHERE IsActive=1 AND FromCur='THB' AND ToCur='INR' ORDER BY Id DESC)  

 declare @LimitValue decimal(18,2)
 set @LimitValue =10000
 select 
 case VendorName 
	when 'Amadeus' then 'Amadeus GDS'
	when '1ANDC' then 'Amadeus NDC'
	WHEN 'Sabre' THEN 'Sabre GDS' 
	WHEN 'SabreNDC' THEN 'Sabre NDC' 
	when 'AIExpress' then 'Air India Express'
	WHEN 'AirArabia' THEN 'Air Arabia'
	WHEN 'Air Arabia 3L' THEN '3L Air Arabia'
	WHEN 'AIRASIA' THEN 'Air Asia'
	WHEN 'AirBlue' THEN 'Air Blue'
	WHEN 'AKASAAIR' THEN 'Akasa Air' 
	WHEN 'AKASAAIR' THEN 'Akasa' 
	WHEN 'FlyDubai' THEN 'Fly Dubai' 
	WHEN 'GFNDC' THEN 'Gulf NDC' 
	WHEN 'OneAPIAirArabia' THEN 'OneAPI Air Arabia' 	
	WHEN 'TravelFusion' THEN 'Travel Fusion' 
	WHEN 'TravelFusionNDC' THEN 'Travel Fusion NDC' 
	WHEN 'EKNDC' THEN 'Emirate NDC'
	WHEN 'EYNDC' THEN 'Etihad NDC'
	WHEN 'FLYNAS' THEN 'Flynas'
	WHEN 'AllianceAir' THEN 'Alliance Air'
	WHEN 'ScootNDC' THEN 'Scoot NDC'
	WHEN 'WYNDC' THEN 'Oman NDC'
	WHEN 'Verteil' THEN 'Verteil NDC'
	WHEN 'XMLAGENCY' THEN 'XML Agency'
	WHEN 'TKNDC' THEN 'Turkish NDC'
	WHEN 'PKFARES' THEN 'PKFares'
else
VendorName end VendorName
    ,[User Type]  
   , Country  
   ,CountryCode
   ,CurrencyCode 
   ,[No Of Tickets] 
   ,[Total Sales] 
   ,[Total Sales INR] 
   ,[ExchangeRate]
   ,case VendorName 
   when 'Amadeus' then 1  
   when 'Amadeus NDC' then 2 
   when '1ANDC' then 2  
   when 'Sabre' then 3
   when 'SabreNDC' then 4
   when 'EKNDC' then 5
   when 'EYNDC' then 6
   when 'GFNDC' then 7
   when 'TravelFusionNDC' then 8
   when 'WYNDC' then 8.1
   when 'ScootNDC' then 8.2
   when 'Verteil' then 8.3
   when 'Air Arabia 3L' then 9
   when '3L Air Arabia' then 9
   when 'Aerticket' then 10
   when 'AirArabia' then 11
   when 'Air Arabia' then 11
   when 'AIRASIA' then 12
   when 'Air Asia' then 12
   when 'AirBlue' then 13
   when 'Air Blue' then 13  
   when 'AIExpress' then 14
   when 'Air India Express' then 14
    when 'AKASAAIR' then 15
   when 'Akasa Air' then 15
   when 'FitsAir' then 16
    when 'FlyDubai' then 17
   when 'Fly Dubai' then 17
   when 'Galileo' then 18
   when 'Indigo' then 19
   when 'Jazeera' then 20
   when 'OneAPIAirArabia' then 21
   when 'OneAPI Air Arabia' then 21
   when 'SalamAir' then 22
   when 'Spicejet' then 23
   when 'STS' then 24
   when 'TravelFusion' then 25
   when 'Travel Fusion' then 25
   when 'FLYNAS' then 26
   when 'Flynas' then 26
   when 'Alliance Air' then 27
   when 'AllianceAir' then 27
   when 'Vietjet' then 28
   when 'XMLAGENCY' then 29
   when 'TKNDC' then 30
   when 'PKFARES' then 31
   else 100 end SequenceField

  from (     

  --Query 1 for india without holiday and without selected custid
   SELECT
  BM.VendorName
    , MC.Value AS [User Type]  
   , AL.Country  
   ,CC.CountryCode
   ,CC.CurrencyCode  
   , COUNT(PB.TicketNumber) AS [No Of Tickets]  

    , CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM( iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))  AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate WHEN 'SAR' THEN @SARExcRate WHEN 'THB' THEN @THBExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate WHEN 'SAR' THEN @SARExcRate WHEN 'THB' THEN @THBExcRate  ELSE 1 END AS [ExchangeRate]


   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID   
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.AgentID != 'B2C'  
    AND BM.BookingSource != 'API'
	and MC.Value!='Holiday'
   AND BM.IsBooked = 1  
   and BM.BookingStatus = 1
   AND BM.totalFare > 0  
   AND CONVERT(DATE, BM.IssueDate) = CONVERT(DATE,@Date)  
   and  bm.UserID not in (
   SELECT FKUserID FROM B2BRegistration WHERE ICAST IN (select Icust from tblInterBranchWinyatra 
where Country='IN')
   )
   AND (AL.Country = 'INDIA')  
   GROUP BY BM.VendorName,MC.Value ,AL.Country,CC.CountryCode, CC.CurrencyCode
 union
 
  --Query 2 for india only holiday with selected custid
   SELECT
  BM.VendorName
    , MC.Value AS [User Type]  
   , AL.Country  
   ,CC.CountryCode
   ,CC.CurrencyCode  
   , COUNT(PB.TicketNumber) AS [No Of Tickets]  

    , CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM( iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))  AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate WHEN 'SAR' THEN @SARExcRate WHEN 'THB' THEN @THBExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate WHEN 'SAR' THEN @SARExcRate WHEN 'THB' THEN @THBExcRate  ELSE 1 END AS [ExchangeRate]


   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID   
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.AgentID != 'B2C'  
    AND BM.BookingSource != 'API'	
   AND BM.IsBooked = 1  
   and BM.BookingStatus = 1
   AND BM.totalFare > 0  
   AND CONVERT(DATE, BM.IssueDate) = CONVERT(DATE,@Date)  
   and  (bm.UserID in (
   SELECT FKUserID FROM B2BRegistration WHERE ICAST IN (select Icust from tblInterBranchWinyatra 
where Country='IN') or  MC.Value ='Holiday')
   )
   AND (AL.Country = 'INDIA')  
   GROUP BY BM.VendorName,MC.Value ,AL.Country,CC.CountryCode, CC.CurrencyCode
 union

  --Query 3 for without india
  SELECT
  BM.VendorName
    , MC.Value AS [User Type]  
   , AL.Country  
   ,CC.CountryCode
   ,CC.CurrencyCode  
   , COUNT(PB.TicketNumber) AS [No Of Tickets]  

    , CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM( iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))  AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate WHEN 'SAR' THEN @SARExcRate WHEN 'THB' THEN @THBExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate WHEN 'SAR' THEN @SARExcRate WHEN 'THB' THEN @THBExcRate  ELSE 1 END AS [ExchangeRate]


   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID   
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.AgentID != 'B2C'  
    AND BM.BookingSource != 'API'
   AND BM.IsBooked = 1  
   and BM.BookingStatus = 1
   AND BM.totalFare > 0  
   AND CONVERT(DATE, BM.IssueDate) = CONVERT(DATE,@Date)   
   AND ( AL.Country = 'UAE' OR AL.Country = 'CANADA'  OR AL.Country = 'USA' or AL.Country = 'SAUDI ARABIA' OR AL.Country = 'UNITED KINGDOM'  OR AL.Country = 'THAILAND')  
   GROUP BY BM.VendorName,MC.Value ,AL.Country,CC.CountryCode, CC.CurrencyCode
 union
  --Query 4 B2c
   SELECT
  BM.VendorName
    , 'B2C' AS [User Type]  
   , case bm.Country   
   when 'IN' then 'INDIA'
   when 'AE' then 'UAE' 
   when 'CA' then 'CANADA' 
   when 'GB' then 'UNITED KINGDOM' 
   when 'SA' then 'SAUDI ARABIA' 
   when 'US' then 'USA' 
   when 'TH' then 'THAILAND' 
   end
   ,CC.CountryCode
   ,CC.CurrencyCode  
   , COUNT(PB.TicketNumber) AS [No Of Tickets]  

    , CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM( iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))  AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate WHEN 'SAR' THEN @SARExcRate WHEN 'THB' THEN @THBExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate WHEN 'SAR' THEN @SARExcRate WHEN 'THB' THEN @THBExcRate  ELSE 1 END AS [ExchangeRate]


   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   --LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
  -- LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID   
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.AgentID = 'B2C'  
    AND BM.BookingSource != 'API'
   AND BM.IsBooked = 1  
   and BM.BookingStatus = 1
   AND BM.totalFare > 0     
   AND CONVERT(DATE, BM.IssueDate) = CONVERT(DATE,@Date)  
   and  bm.UserID not in (
   SELECT FKUserID FROM B2BRegistration WHERE ICAST IN (select Icust from tblInterBranchWinyatra 
where Country='IN')
   )
  -- AND (AL.Country = 'INDIA' OR AL.Country = 'CANADA' OR AL.Country = 'UAE' OR AL.Country = 'USA' or AL.Country = 'SAUDI ARABIA' OR AL.Country = 'UNITED KINGDOM'  OR AL.Country = 'THAILAND' )  
   GROUP BY BM.VendorName,bm.Country ,CC.CountryCode, CC.CurrencyCode
    
union
 --Query 5 for API
   SELECT
  BM.VendorName,
    CASE  MC.Value when 'RBT' then
   'Cliq Biz'
   else
   'API (' + MC.Value+ ')'
   end   AS  [User Type] 
   , AL.Country  
   ,CC.CountryCode
   ,CC.CurrencyCode  
   , COUNT(PB.TicketNumber) AS [No Of Tickets]  

    , CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM( iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))  AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate WHEN 'SAR' THEN @SARExcRate WHEN 'THB' THEN @THBExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate WHEN 'SAR' THEN @SARExcRate WHEN 'THB' THEN @THBExcRate  ELSE 1 END AS [ExchangeRate]


   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID   
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.AgentID != 'B2C'  
    AND BM.BookingSource = 'API'
   AND BM.IsBooked = 1  
   and BM.BookingStatus = 1
   AND BM.totalFare > 0  
   AND CONVERT(DATE, BM.inserteddate) = CONVERT(DATE,@Date)  
   AND AL.UserTypeId <> 3  
   AND (AL.Country = 'INDIA' OR AL.Country = 'CANADA' OR AL.Country = 'UAE' OR AL.Country = 'USA' or AL.Country = 'SAUDI ARABIA' OR AL.Country = 'UNITED KINGDOM'  OR AL.Country = 'THAILAND' )  
   GROUP BY BM.VendorName,MC.Value ,AL.Country,CC.CountryCode, CC.CurrencyCode
   union

    --Query 6 for cliq marine
    SELECT 
	 BM.VendorName
    , 'Cliq Marine' AS  [User Type]  
   , AL.Country  
   ,CC.CountryCode
   ,CC.CurrencyCode
   , COUNT(ISNULL(PB.TicketNumber, 0)) AS [No Of Tickets] 
   
     , CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM( iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))  AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END AS [ExchangeRate] 


 
	
   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID  
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.IsBooked = 1  
   and BM.BookingStatus = 1
   AND BM.totalFare > 0  
   AND BM.AgentID != 'B2C'
   AND BM.BookingSource = 'API'
   AND CONVERT(DATE, BM.inserteddate) = convert(date,@Date)  
   AND (AL.UserTypeId = 3)  
   AND (AL.Country = 'CANADA' OR AL.Country = 'UAE' OR AL.Country = 'USA')  
   GROUP BY BM.VendorName,MC.Value ,AL.Country,CC.CountryCode, CC.CurrencyCode
   union
    --Query 6.1 for API marine India
    SELECT 
	 BM.VendorName
    , 'API (Marine)' AS  [User Type]  
   , AL.Country  
   ,CC.CountryCode
   ,CC.CurrencyCode
   , COUNT(ISNULL(PB.TicketNumber, 0)) AS [No Of Tickets] 
   
     , CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM( iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))  AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END AS [ExchangeRate] 
	
   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID  
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.IsBooked = 1  
   and BM.BookingStatus = 1
   AND BM.totalFare > 0  
   AND BM.AgentID != 'B2C'
   AND BM.BookingSource = 'API'
   AND CONVERT(DATE, BM.inserteddate) = convert(date,@Date)  
   AND (AL.UserTypeId = 3  )
   AND (AL.Country = 'INDIA')  
   GROUP BY BM.VendorName,MC.Value ,AL.Country,CC.CountryCode, CC.CurrencyCode

    UNION
	 --Query 7 for marine corp
      SELECT
	   BM.VendorName,
	  'Marine' as UserType
	  ,case when AL.Country_Code='IN' THEN 'INDIA' end as Country	  
   ,CC.CountryCode
   ,CC.CurrencyCode
   --, AL.Country_Code  
   , COUNT(CI.TicketNumber) AS [No Of Tickets]  

    ,  CAST(SUM(BM.totalFare * BM.ROE 
	--+ ISNULL(PB.Markup, 0) 
	+ ISNULL(CI.B2bMarkup, 0) + ISNULL(CI.BFCMarkup, 0) + ISNULL(CI.ServiceFee, 0)+ ISNULL(CI.ServiceFee_GST, 0)) 
	- SUM(iif(ISNULL(BM.IATACommission, 0) > @LimitValue,0,ISNULL(BM.IATACommission, 0)) 
	+ iif(ISNULL(CI.PLBCommission, 0) > @LimitValue,0,ISNULL(CI.PLBCommission, 0)) 
	+ ISNULL(CI.DropnetCommission, 0)) AS DECIMAL(18,0))  AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END) * (CAST(SUM(BM.totalFare * BM.ROE 
	--+ ISNULL(PB.Markup, 0) 
	+ ISNULL(CI.B2bMarkup, 0) + ISNULL(CI.BFCMarkup, 0) + ISNULL(CI.ServiceFee, 0)+ ISNULL(CI.ServiceFee_GST, 0)) - SUM(iif(ISNULL(BM.IATACommission, 0) > @LimitValue,0,ISNULL(BM.IATACommission, 0)) + iif(ISNULL(CI.PLBCommission, 0) > @LimitValue,0,ISNULL(CI.PLBCommission, 0)) + ISNULL(CI.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END AS [ExchangeRate]

	
   --, CONVERT(VARCHAR(50), CAST(SUM(PB.totalFare + BM.TotalDiscount + ISNULL(PB.Markup, 0) + ISNULL(bm.AgentMarkup, 0) + ISNULL(pr.ServiceFee, 0)) AS DECIMAL(18,0)))+' '+CC.CurrencyCode AS [Total Sales Old]  
 
   --, CAST((CASE AL.Country WHEN 'CANADA' THEN @CanadaExcRate WHEN 'UAE' THEN @UAEExcRate WHEN 'USA' THEN @USExcRate WHEN 'UNITED KINGDOM' THEN @GBPExcRate ELSE 1 END)
   -- * (CAST(SUM(PB.totalFare + BM.TotalDiscount + isnull(PB.Markup, 0) + isnull(bm.AgentMarkup, 0) + isnull(pr.ServiceFee, 0)) AS decimal(18,0))) AS DECIMAL(18,0))  
   -- AS [Total Sales INR OLD]  

   FROM MarineTool.dbo.txnBookPaxInfo PB WITH(NOLOCK)  
   LEFT JOIN MarineTool.dbo.txnBookFlightInfo BM WITH(NOLOCK) ON PB.FkFlightInfoID = BM.ID 
   LEFT JOIN MarineTool.dbo.txnBookClassInfo CI WITH(NOLOCK)  ON  CI.FkFlightInfoID  = BM.ID and CI.FkPaxID = PB.ID
   LEFT JOIN MarineTool.dbo.mCorporate AL WITH(NOLOCK) ON BM.Corporate_Code = AL.ID  
   --LEFT JOIN MarineTool.dbo.PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   --LEFT JOIN MarineTool.dbo.mCommon MC WITH(NOLOCK) ON MC.ID = AL.User_Type   
   LEFT JOIN MarineTool.dbo.mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE 
   --BM.AgentID != 'B2C'  AND
    BM.IsBooked = 1  
   AND CI.totalFare > 0  
   AND CONVERT(DATE, BM.Created_Date) = CONVERT(DATE,@Date)  
  
   and AL.User_Type='MN'
   --AND (AL.Country = 'CANADA' OR AL.Country = 'UAE' OR AL.Country = 'USA')  
   AND AL.Country_Code ='IN' 
   and BM.Status =  1
   and BM.Migration_Status is null
   GROUP BY BM.VendorName,AL.Country_Code,CC.CountryCode, CC.CurrencyCode

	union select 'Amadeus','ALL','ALL','','',0,0,0,0 
	union select 'Amadeus NDC','ALL','ALL','','',0,0,0,0
	union select 'Sabre','ALL','ALL','','',0,0,0,0
	union select 'SabreNDC','ALL','ALL','','',0,0,0,0
	union select 'AERTicket','ALL','ALL','','',0,0,0,0	
	union select 'Air Arabia','ALL','ALL','','',0,0,0,0	
	union select 'Air Arabia 3L','ALL','ALL','','',0,0,0,0	
	union select 'Air Asia','ALL','ALL','','',0,0,0,0
	union select 'Air India Express','ALL','ALL','','',0,0,0,0
	union select 'AirArabia','ALL','ALL','','',0,0,0,0
	union select 'AIRASIA','ALL','ALL','','',0,0,0,0
	union select 'AirBlue','ALL','ALL','','',0,0,0,0
	union select 'Akasa Air','ALL','ALL','','',0,0,0,0
	union select 'AKASAAIR','ALL','ALL','','',0,0,0,0
	union select 'Amadeus','ALL','ALL','','',0,0,0,0
	union select 'Amadeus NDC','ALL','ALL','','',0,0,0,0
	union select 'EKNDC','ALL','ALL','','',0,0,0,0
	union select 'EYNDC','ALL','ALL','','',0,0,0,0
	union select 'FitsAir','ALL','ALL','','',0,0,0,0
	union select 'Fly Dubai','ALL','ALL','','',0,0,0,0
	union select 'FlyDubai','ALL','ALL','','',0,0,0,0
	union select 'Galileo','ALL','ALL','','',0,0,0,0
	union select 'GFNDC','ALL','ALL','','',0,0,0,0
	union select 'Indigo','ALL','ALL','','',0,0,0,0
	union select 'Jazeera','ALL','ALL','','',0,0,0,0
	union select 'OneAPIAirArabia','ALL','ALL','','',0,0,0,0	
	union select 'SabreNDC','ALL','ALL','','',0,0,0,0
	union select 'SalamAir','ALL','ALL','','',0,0,0,0
	union select 'Spicejet','ALL','ALL','','',0,0,0,0
	union select 'STS','ALL','ALL','','',0,0,0,0
	union select 'TravelFusion','ALL','ALL','','',0,0,0,0
	union select 'TravelFusionNDC','ALL','ALL','','',0,0,0,0
	union select 'Flynas','ALL','ALL','','',0,0,0,0
	union select 'WYNDC','ALL','ALL','','',0,0,0,0
	union select 'ScootNDC','ALL','ALL','','',0,0,0,0
    union select 'AllianceAir','ALL','ALL','','',0,0,0,0
	union select 'Verteil','ALL','ALL','','',0,0,0,0
	union select 'Vietjet','ALL','ALL','','',0,0,0,0
	union select 'XMLAGENCY','ALL','ALL','','',0,0,0,0
	union select 'TKNDC','ALL','ALL','','',0,0,0,0
	union select 'PKFARES','ALL','ALL','','',0,0,0,0
	
   )
   
   
   vw order by SequenceField
END