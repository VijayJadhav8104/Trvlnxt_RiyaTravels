CREATE PROCEDURE [dbo].[USP_TrvlNxt_GetMonthlySalesReport_JN_new]      
 @Date DATETIME   
 , @getDayWise BIT      
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
 declare @LimitValue decimal(18,2)
 set @LimitValue =10000
 IF(@getDayWise = 0)  
 BEGIN  
  SELECT * FROM (  
   SELECT MC.Value AS [User Type]  
   , AL.Country  
   , COUNT(PB.TicketNumber) AS [No Of Tickets]  

    , CONVERT(VARCHAR(50), CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM( iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) +' '+ CC.CurrencyCode AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END AS [ExchangeRate]

	
   --, CONVERT(VARCHAR(50), CAST(SUM(PB.totalFare + BM.TotalDiscount + ISNULL(PB.Markup, 0) + ISNULL(bm.AgentMarkup, 0) + ISNULL(pr.ServiceFee, 0)) AS DECIMAL(18,0)))+' '+CC.CurrencyCode AS [Total Sales Old]  
 
   --, CAST((CASE AL.Country WHEN 'CANADA' THEN @CanadaExcRate WHEN 'UAE' THEN @UAEExcRate WHEN 'USA' THEN @USExcRate WHEN 'UNITED KINGDOM' THEN @GBPExcRate ELSE 1 END)
   -- * (CAST(SUM(PB.totalFare + BM.TotalDiscount + isnull(PB.Markup, 0) + isnull(bm.AgentMarkup, 0) + isnull(pr.ServiceFee, 0)) AS decimal(18,0))) AS DECIMAL(18,0))  
   -- AS [Total Sales INR OLD]  

   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID   
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.AgentID != 'B2C'  
   AND BM.IsBooked = 1  
   AND BM.totalFare > 0  
   AND CONVERT(DATE, BM.IssueDate) = CONVERT(DATE,@Date)  
   AND (AL.Country = 'CANADA' OR AL.Country = 'UAE' OR AL.Country = 'USA')  
   AND AL.UserTypeId = 2  
   --AND BM.GDSPNR != '2LDER5' --iata amount wrong
   GROUP BY AL.Country, MC.Value,CC.CurrencyCode  
       
   UNION  
       
   SELECT   
   'B2C' AS [User Type]  
   , 'INDIA' AS Country  
   , COUNT(PB.TicketNumber) AS [No Of Tickets]
   
   , CONVERT(VARCHAR(50), CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) +' '+ CC.CurrencyCode AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END AS [ExchangeRate] 


   --, CONVERT(VARCHAR(50),CAST(SUM(PB.totalFare + BM.TotalDiscount + ISNULL(PB.Markup, 0) + ISNULL(bm.AgentMarkup, 0) + ISNULL(pr.ServiceFee, 0)) AS DECIMAL(18,0)))+' '+CC.CurrencyCode AS [Total Sales OLD]  
    
   --, CAST(SUM(PB.totalFare + BM.TotalDiscount + isnull(PB.Markup, 0) + isnull(bm.AgentMarkup, 0) + isnull(pr.ServiceFee, 0)) AS decimal(18,0)) AS [Total Sales INR OLD]  

   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.AgentID = 'B2C'  
   AND BM.IsBooked = 1  
   AND BM.totalFare > 0  
   AND CONVERT(DATE, BM.IssueDate) = CONVERT(DATE,@Date)  
   GROUP BY CC.CurrencyCode  
       
   UNION  
       
   SELECT MC.Value AS [User Type]  
   , AL.Country  
   , COUNT(ISNULL(PB.TicketNumber, 0)) AS [No Of Tickets] 
   
   , CONVERT(VARCHAR(50), CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) +' '+ CC.CurrencyCode AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END AS [ExchangeRate] 


   --, CONVERT(VARCHAR(50),CAST(SUM(PB.totalFare + BM.TotalDiscount + ISNULL(PB.Markup, 0) + ISNULL(bm.AgentMarkup, 0) + ISNULL(pr.ServiceFee, 0)) AS DECIMAL(18,0))) + ' ' + CC.CurrencyCode  AS [Total Sales OLD]  
   
   --, CAST((CASE AL.Country WHEN 'CANADA' THEN @CanadaExcRate WHEN 'UAE' THEN @UAEExcRate WHEN 'USA' THEN @USExcRate WHEN 'UNITED KINGDOM' then @GBPExcRate ELSE 1 END)  
   --* (CAST(SUM(PB.totalFare + BM.TotalDiscount + isnull(PB.Markup, 0) + isnull(bm.AgentMarkup, 0) + isnull(pr.ServiceFee, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0))  
   -- AS [Total Sales INR OLD]  

   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID  
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.IsBooked = 1  
   AND BM.totalFare > 0  
   AND BM.AgentID != 'B2C'  
   AND CONVERT(DATE, BM.IssueDate) = CONVERT(DATE,@Date)  
   AND (AL.UserTypeId = 3 OR AL.UserTypeId = 4 OR AL.UserTypeId = 5)  
   GROUP BY AL.Country, MC.Value,CC.CurrencyCode  

   UNION
      SELECT 'MarineCorp' as UserType
	  ,case when AL.Country_Code='IN' THEN 'INDIA' end as Country_Code
   --, AL.Country_Code  
   , COUNT(CI.TicketNumber) AS [No Of Tickets]  

    , CONVERT(VARCHAR(50), CAST(SUM(BM.totalFare * BM.ROE 
	--+ ISNULL(PB.Markup, 0) 
	+ ISNULL(CI.B2bMarkup, 0) + ISNULL(CI.BFCMarkup, 0) + ISNULL(CI.ServiceFee, 0)+ ISNULL(CI.ServiceFee_GST, 0)) 
	- SUM(iif(ISNULL(BM.IATACommission, 0) > @LimitValue,0,ISNULL(BM.IATACommission, 0)) 
	+ iif(ISNULL(CI.PLBCommission, 0) > @LimitValue,0,ISNULL(CI.PLBCommission, 0)) 
	+ ISNULL(CI.DropnetCommission, 0)) AS DECIMAL(18,0))) +' '+ CC.CurrencyCode AS [Total Sales] 
	
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
   AND CONVERT(DATE, BM.Booked_Date) = CONVERT(DATE,@Date)  
  
   and AL.User_Type='MN'
   --AND (AL.Country = 'CANADA' OR AL.Country = 'UAE' OR AL.Country = 'USA')  
   AND AL.Country_Code ='IN' 
   GROUP BY AL.Country_Code, CC.CurrencyCode  

       
   UNION  
       
   SELECT MC.Value AS [User Type]  
   , AL.Country  
   , COUNT(ISNULL(PB.TicketNumber, 0)) AS [No Of Tickets] 
   
   , CONVERT(VARCHAR(50), CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) +' '+ CC.CurrencyCode AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END AS [ExchangeRate] 


   --, CONVERT(VARCHAR(50),CAST(SUM((PB.totalFare + BM.TotalDiscount + ISNULL(PB.Markup, 0) + ISNULL(bm.AgentMarkup, 0) + ISNULL(pr.ServiceFee, 0)) * BM.ROE) AS DECIMAL(18,0)))+ ' ' + CC.CurrencyCode AS [Total Sales OLD]  
  
   --, CAST((CASE AL.Country WHEN 'CANADA' THEN @CanadaExcRate WHEN 'UAE' THEN @UAEExcRate WHEN 'USA' THEN @USExcRate WHEN 'UNITED KINGDOM' THEN @GBPExcRate ELSE 1 END)  
   -- * (CAST(SUM((PB.totalFare + BM.TotalDiscount + ISNULL(PB.Markup, 0) + ISNULL(bm.AgentMarkup, 0) + ISNULL(pr.ServiceFee, 0)) * BM.ROE)AS DECIMAL(18,0))) AS DECIMAL(18,0)) 	
   -- AS [Total Sales INR OLD] 
	
   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID  
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.IsBooked = 1  
   AND BM.totalFare > 0  
   AND BM.AgentID != 'B2C'
   AND BM.BookingSource != 'API'
   AND CONVERT(DATE, BM.IssueDate) = convert(date,@Date)  
   AND AL.UserTypeId = 2  
   AND AL.Country = 'INDIA'  
   GROUP BY AL.Country,  MC.Value, CC.CurrencyCode 
   
   ------Marine_CBT added by Roshni ----------
   UNION
      SELECT 'MarineCorp' as UserType
	  ,case when AL.Country_Code='IN' THEN 'INDIA' end as Country_Code
   --, AL.Country_Code  
   , COUNT(CI.TicketNumber) AS [No Of Tickets]  

    , CONVERT(VARCHAR(50), CAST(SUM(BM.totalFare * BM.ROE 
	--+ ISNULL(PB.Markup, 0) 
	+ ISNULL(CI.B2bMarkup, 0) + ISNULL(CI.BFCMarkup, 0) + ISNULL(CI.ServiceFee, 0)+ ISNULL(CI.ServiceFee_GST, 0)) 
	- SUM(iif(ISNULL(BM.IATACommission, 0) > @LimitValue,0,ISNULL(BM.IATACommission, 0)) 
	+ iif(ISNULL(CI.PLBCommission, 0) > @LimitValue,0,ISNULL(CI.PLBCommission, 0)) 
	+ ISNULL(CI.DropnetCommission, 0)) AS DECIMAL(18,0))) +' '+ CC.CurrencyCode AS [Total Sales] 
	
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
   AND CONVERT(DATE, BM.Booked_Date) = CONVERT(DATE,@Date)  
  
   and AL.User_Type='MN'
   --AND (AL.Country = 'CANADA' OR AL.Country = 'UAE' OR AL.Country = 'USA')  
   AND AL.Country_Code ='IN' 
   GROUP BY AL.Country_Code, CC.CurrencyCode  

    ------ END Marine_CBT added by Roshni ----------

    UNION  
       
   SELECT 'API' AS [User Type]  
   , AL.Country  
   , COUNT(ISNULL(PB.TicketNumber, 0)) AS [No Of Tickets] 
   
   , CONVERT(VARCHAR(50), CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) +' '+ CC.CurrencyCode AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END AS [ExchangeRate] 


 
	
   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID  
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.IsBooked = 1  
   AND BM.totalFare > 0  
   AND BM.AgentID != 'B2C'
   AND BM.BookingSource = 'API'
   AND CONVERT(DATE, BM.IssueDate) = convert(date,@Date)  
   AND AL.UserTypeId = 2  
   AND AL.Country = 'INDIA'  
   GROUP BY AL.Country,  MC.Value, CC.CurrencyCode  
  ) AS t  
  ORDER BY ( CASE t.Country WHEN 'INDIA' THEN CASE t.[User Type] when 'API' THEN 6 ELSE 1 END WHEN 'UAE' THEN 2 WHEN 'CANADA' THEN 3 WHEN 'USA' THEN 4 WHEN 'UNITED KINGDOM' THEN 5 END
  ) ASC  

  




 END      
 ELSE      
 BEGIN      
 SELECT * FROM (  
   SELECT MC.Value AS [User Type]  
   , AL.Country  
   , COUNT(PB.TicketNumber) AS [No Of Tickets]  

    , CONVERT(VARCHAR(50), CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) +' '+ CC.CurrencyCode AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END AS [ExchangeRate]

	
   --, CONVERT(VARCHAR(50), CAST(SUM(PB.totalFare + BM.TotalDiscount + ISNULL(PB.Markup, 0) + ISNULL(bm.AgentMarkup, 0) + ISNULL(pr.ServiceFee, 0)) AS DECIMAL(18,0)))+' '+CC.CurrencyCode AS [Total Sales Old]  
 
   --, CAST((CASE AL.Country WHEN 'CANADA' THEN @CanadaExcRate WHEN 'UAE' THEN @UAEExcRate WHEN 'USA' THEN @USExcRate WHEN 'UNITED KINGDOM' THEN @GBPExcRate ELSE 1 END)
   -- * (CAST(SUM(PB.totalFare + BM.TotalDiscount + isnull(PB.Markup, 0) + isnull(bm.AgentMarkup, 0) + isnull(pr.ServiceFee, 0)) AS decimal(18,0))) AS DECIMAL(18,0))  
   -- AS [Total Sales INR OLD]  

   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID   
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.AgentID != 'B2C'  
   AND BM.IsBooked = 1  
   AND BM.totalFare > 0  
   AND CONVERT(DATE, BM.IssueDate) = CONVERT(DATE,@Date)  
   AND (AL.Country = 'CANADA' OR AL.Country = 'UAE' OR AL.Country = 'USA')  
   AND AL.UserTypeId = 2  
   GROUP BY AL.Country, MC.Value,CC.CurrencyCode  
       
   UNION  
       
   SELECT   
   'B2C' AS [User Type]  
   , 'INDIA' AS Country  
   , COUNT(PB.TicketNumber) AS [No Of Tickets]
   
   , CONVERT(VARCHAR(50), CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) +' '+ CC.CurrencyCode AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END AS [ExchangeRate] 


   --, CONVERT(VARCHAR(50),CAST(SUM(PB.totalFare + BM.TotalDiscount + ISNULL(PB.Markup, 0) + ISNULL(bm.AgentMarkup, 0) + ISNULL(pr.ServiceFee, 0)) AS DECIMAL(18,0)))+' '+CC.CurrencyCode AS [Total Sales OLD]  
    
   --, CAST(SUM(PB.totalFare + BM.TotalDiscount + isnull(PB.Markup, 0) + isnull(bm.AgentMarkup, 0) + isnull(pr.ServiceFee, 0)) AS decimal(18,0)) AS [Total Sales INR OLD]  

   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.AgentID = 'B2C'  
   AND BM.IsBooked = 1  
   AND BM.totalFare > 0  
   AND CONVERT(DATE, BM.IssueDate) = CONVERT(DATE,@Date)  
   GROUP BY CC.CurrencyCode  
       
   UNION  
       
   SELECT MC.Value AS [User Type]  
   , AL.Country  
   , COUNT(ISNULL(PB.TicketNumber, 0)) AS [No Of Tickets] 
   
   , CONVERT(VARCHAR(50), CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) +' '+ CC.CurrencyCode AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END AS [ExchangeRate] 


   --, CONVERT(VARCHAR(50),CAST(SUM(PB.totalFare + BM.TotalDiscount + ISNULL(PB.Markup, 0) + ISNULL(bm.AgentMarkup, 0) + ISNULL(pr.ServiceFee, 0)) AS DECIMAL(18,0))) + ' ' + CC.CurrencyCode  AS [Total Sales OLD]  
   
   --, CAST((CASE AL.Country WHEN 'CANADA' THEN @CanadaExcRate WHEN 'UAE' THEN @UAEExcRate WHEN 'USA' THEN @USExcRate WHEN 'UNITED KINGDOM' then @GBPExcRate ELSE 1 END)  
   -- * (CAST(SUM(PB.totalFare + BM.TotalDiscount + isnull(PB.Markup, 0) + isnull(bm.AgentMarkup, 0) + isnull(pr.ServiceFee, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0))  
   -- AS [Total Sales INR OLD]  

   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID  
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.IsBooked = 1  
   AND BM.totalFare > 0  
   AND BM.AgentID != 'B2C'  
   AND CONVERT(DATE, BM.IssueDate) = CONVERT(DATE,@Date)  
   AND (AL.UserTypeId = 3 OR AL.UserTypeId = 4 OR AL.UserTypeId = 5)  
   GROUP BY AL.Country, MC.Value,CC.CurrencyCode  
   
   UNION
      SELECT 'MarineCorp' as UserType
	  ,case when AL.Country_Code='IN' THEN 'INDIA' end as Country_Code
   --, AL.Country_Code  
   , COUNT(CI.TicketNumber) AS [No Of Tickets]  

    , CONVERT(VARCHAR(50), CAST(SUM(BM.totalFare * BM.ROE 
	--+ ISNULL(PB.Markup, 0) 
	+ ISNULL(CI.B2bMarkup, 0) + ISNULL(CI.BFCMarkup, 0) + ISNULL(CI.ServiceFee, 0)+ ISNULL(CI.ServiceFee_GST, 0)) 
	- SUM(iif(ISNULL(BM.IATACommission, 0) > @LimitValue,0,ISNULL(BM.IATACommission, 0)) 
	+ iif(ISNULL(CI.PLBCommission, 0) > @LimitValue,0,ISNULL(CI.PLBCommission, 0)) 
	+ ISNULL(CI.DropnetCommission, 0)) AS DECIMAL(18,0))) +' '+ CC.CurrencyCode AS [Total Sales] 
	
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
   AND CONVERT(DATE, BM.Booked_Date) = CONVERT(DATE,@Date)  
  
   and AL.User_Type='MN'
   --AND (AL.Country = 'CANADA' OR AL.Country = 'UAE' OR AL.Country = 'USA')  
   AND AL.Country_Code ='IN' 
   GROUP BY AL.Country_Code, CC.CurrencyCode  
 


   UNION  
       
   SELECT MC.Value AS [User Type]  
   , AL.Country  
   , COUNT(ISNULL(PB.TicketNumber, 0)) AS [No Of Tickets] 
   
   , CONVERT(VARCHAR(50), CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) +' '+ CC.CurrencyCode AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END AS [ExchangeRate] 


   --, CONVERT(VARCHAR(50),CAST(SUM((PB.totalFare + BM.TotalDiscount + ISNULL(PB.Markup, 0) + ISNULL(bm.AgentMarkup, 0) + ISNULL(pr.ServiceFee, 0)) * BM.ROE) AS DECIMAL(18,0)))+ ' ' + CC.CurrencyCode AS [Total Sales OLD]  
  
   --, CAST((CASE AL.Country WHEN 'CANADA' THEN @CanadaExcRate WHEN 'UAE' THEN @UAEExcRate WHEN 'USA' THEN @USExcRate WHEN 'UNITED KINGDOM' THEN @GBPExcRate ELSE 1 END)  
   -- * (CAST(SUM((PB.totalFare + BM.TotalDiscount + ISNULL(PB.Markup, 0) + ISNULL(bm.AgentMarkup, 0) + ISNULL(pr.ServiceFee, 0)) * BM.ROE)AS DECIMAL(18,0))) AS DECIMAL(18,0)) 	
   -- AS [Total Sales INR OLD] 
	
   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID  
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.IsBooked = 1  
   AND BM.totalFare > 0  
   AND BM.AgentID != 'B2C'  
   AND BM.BookingSource != 'API'  
   AND CONVERT(DATE, BM.IssueDate) = convert(date,@Date)  
   AND AL.UserTypeId = 2  
   AND AL.Country = 'INDIA'  
   GROUP BY AL.Country,  MC.Value, CC.CurrencyCode  

    UNION  
       
   SELECT 'API' AS [User Type]  
   , AL.Country  
   , COUNT(ISNULL(PB.TicketNumber, 0)) AS [No Of Tickets] 
   
   , CONVERT(VARCHAR(50), CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) +' '+ CC.CurrencyCode AS [Total Sales] 
	
	, CAST((CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END) * (CAST(SUM(PB.totalFare * BM.ROE + ISNULL(PB.Markup, 0) + ISNULL(PB.B2bMarkup, 0) + ISNULL(PB.BFC, 0) + ISNULL(PB.ServiceFee, 0)+ ISNULL(PB.GST, 0)) - SUM(iif(ISNULL(PB.IATACommission, 0) > @LimitValue,0,ISNULL(PB.IATACommission, 0)) + iif(ISNULL(PB.PLBCommission, 0) > @LimitValue,0,ISNULL(PB.PLBCommission, 0)) + ISNULL(PB.DropnetCommission, 0)) AS DECIMAL(18,0))) AS DECIMAL(18,0)) AS [Total Sales INR]  

	, CASE CC.CurrencyCode WHEN 'USD' THEN @USExcRate WHEN 'CAD' THEN @CanadaExcRate WHEN 'AED' THEN @UAEExcRate WHEN 'GBP' THEN @GBPExcRate ELSE 1 END AS [ExchangeRate] 

	
   FROM tblPassengerBookDetails PB WITH(NOLOCK)  
   LEFT JOIN tblBookMaster BM WITH(NOLOCK) ON PB.fkBookMaster = BM.pkId  
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON BM.AgentID = AL.UserID  
   LEFT JOIN PNRRetriveDetails PR WITH(NOLOCK) ON PR.OrderID = BM.orderId  
   LEFT JOIN mCommon MC WITH(NOLOCK) ON MC.ID = AL.UserTypeID  
   LEFT JOIN mCountryCurrency CC WITH(NOLOCK) on CC.CountryCode=BM.Country  
   WHERE BM.IsBooked = 1  
   AND BM.totalFare > 0  
   AND BM.AgentID != 'B2C'  
   AND BM.BookingSource = 'API'  
   AND CONVERT(DATE, BM.IssueDate) = convert(date,@Date)  
   AND AL.UserTypeId = 2  
   AND AL.Country = 'INDIA'  
   GROUP BY AL.Country,  MC.Value, CC.CurrencyCode  
  ) AS t  
  ORDER BY (CASE t.Country WHEN 'INDIA' THEN CASE t.[User Type] when 'API' THEN 6 ELSE 1 END WHEN 'UAE' THEN 2 WHEN 'CANADA' THEN 3 WHEN 'USA' THEN 4 WHEN 'UNITED KINGDOM' THEN 5 END) ASC  
 END  
END