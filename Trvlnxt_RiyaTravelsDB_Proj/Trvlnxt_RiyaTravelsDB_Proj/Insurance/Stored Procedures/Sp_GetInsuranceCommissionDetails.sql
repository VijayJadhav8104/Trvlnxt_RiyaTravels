
--============================================    
-- Author : Jitendra Nakum    
-- Crated Date : 07/05/2022    
-- Description : To get Cruise Sevice/ fee / quotation / gst    
-- exec [Insurance].[Sp_GetInsuranceCommissionDetails] '', ''
--============================================    
CREATE PROCEDURE [Insurance].[Sp_GetInsuranceCommissionDetails]
@UserType Varchar(50)=null,    
@MarketPoint Varchar(50)=null    
AS    
BEGIN     
	SELECT 
	INS.PKID,
	INS.UserTypeId,
	INS.MarketPoint,
	INS.AgentId,
	INS.ServicetypeId,
	INS.SupplierId,
	INS.PlanIds,
	INS.TravelValidityFrom,
	INS.TravelValidityTo,
	INS.SalesValidityFrom,
	INS.SalesValidityTo,
	ISNULL(INS.Origin,'') AS Origin,
	ISNULL(INS.Destination,'') AS Destination ,
	INS.Currency,
	INS.BookingTypeIds,
	ISNULL(INS.GST,0) AS GST,
	ISNULL(INS.TDS,0) AS TDS,
	ISNULL(INS.CommissionPer,0) AS CommissionPer,
	ISNULL(INS.Markupamt,0) AS Markupamt,
	ISNULL(INS.MarkupPercentage,0) AS MarkupPercentage,
	INS.InsertedOn,
	INS.InsertedBy,
	isnull(INS.ModifiedOn,getdate()) as ModifiedOn,
	ISNULL(INS.ModifiedBy,0) AS ModifiedBy,
	INS.Status,
	MU.UserName as 'CreatedBy',  
	--CASE INS.UserTypeId  WHEN 1 then 'B2C' WHEN 2 then 'B2B' WHEN 3 then 'Marine' WHEN 4 then 'Holiday' 
	--WHEN 5 then 'RBT' WHEN 1245 then 'External Client' ELSE 'NA' END
	ci.Value AS 'UserType'
	FROM Insurance.tbl_Insurance_Markup_Comm INS
	LEFT JOIN mUser MU ON Mu.ID=INS.InsertedBy
	LEFT JOIN Insurance.mCommonInsurance ci ON ci.ID=INS.UserTypeId
	WHERE 
	INS.ServicetypeId=7 -- fix for get commission data
	AND (@UserType IS NULL OR @UserType='' OR INS.UserTypeId=@UserType)
	AND (@MarketPoint IS NULL OR @MarketPoint='' OR INS.MarketPoint = @MarketPoint)
	order by InsertedOn desc
END 
