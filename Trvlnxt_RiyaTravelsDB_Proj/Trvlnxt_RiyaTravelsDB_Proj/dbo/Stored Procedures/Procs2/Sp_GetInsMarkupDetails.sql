--exec Sp_GetInsMarkupDetails 'US','B2B','8'
CREATE Procedure [dbo].[Sp_GetInsMarkupDetails]
	@MarketPoint nvarchar(5) =null,
	@UserType varchar(50)=null,
	@ServiceTypeID varchar(5)=null
AS
BEGIN
	
declare @UserID int

	SELECT @UserID =  ID
	FROM [mCommonInsurance]
	WHERE Value=@UserType and isactive=1

	if(@UserID is NULL)
	begin
	select UserTypeId,MarketPoint,AgentId,ServicetypeId,SupplierId,PlanIds,Currency,BookingTypeIds as BookingType,Markupamt,MarkupPercentage,InsertedOn,ModifiedOn
	from [tbl_Insurance_Markup_Comm] where Status='1' and MarketPoint=@MarketPoint 
	and ServicetypeId=@ServiceTypeID and UserTypeId=@UserType order by ISNULL(ModifiedOn,InsertedOn) desc
	end
	--else 
	--begin
	--select UserTypeId,MarketPoint,AgentId,ServicetypeId,SupplierId,PlanIds,Currency,BookingTypeIds as BookingType,Markupamt,MarkupPercentage,InsertedOn,ModifiedOn
	--from [tbl_Insurance_Markup_Comm] where Status='1' and MarketPoint=@MarketPoint 
	--and ServicetypeId=@ServiceTypeID and UserTypeId=@UserID order by ISNULL(ModifiedOn,InsertedOn) desc
	--end

END