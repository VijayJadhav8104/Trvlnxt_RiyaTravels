-- =============================================
-- Author:		Pradeep Pandey
-- Create date: 27 May 2020
-- Description:	To Update Agent Group Mapping
-- =============================================
CREATE PROCEDURE [dbo].[SP_UpdateAgentGroupMapping]
	-- Add the parameters for the stored procedure here
	@Option varchar(100),
	@MarketPoint varchar(30),
	@UserType varchar(50)=null,
	@AgencyId varchar(MAX)=null,
	@AgentCategory varchar(MAX)=null,
	@AgencyNames varchar(MAX)=null,
	@UserID int


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;

    -- Insert statements for procedure here
	If(@Option='PromoCode')
	begin
	  Update Flight_PromoCode set AgencyNames=@AgencyNames,AgencyId=@AgencyId,UserID=@UserID,UpdatedDate=GETDATE() where UserType= @UserType and MarketPoint=@MarketPoint and AgentCategory=@AgentCategory
	end

	Else If(@Option='Service fee/GST/Quotation')
	begin
	  Update tbl_ServiceFee_GST_QuatationDetails set AgencyNames=@AgencyNames,AgencyId=@AgencyId,UserID=@UserID,UpdatedDate=GETDATE() where UserType= @UserType and MarketPoint=@MarketPoint and AgentCategory=@AgentCategory
	end

	Else If(@Option='PricingCode/Tourcode/Commission')
	begin
	  Update Flight_Commission set AgencyNames=@AgencyNames,AgencyId=@AgencyId,UserID=@UserID,UpdatedDate=GETDATE() where UserType= @UserType and MarketPoint=@MarketPoint and AgentCategory=@AgentCategory
	end

	Else If(@Option='Flat')
	begin
	  Update Flight_Flat set AgencyNames=@AgencyNames,AgencyId=@AgencyId,UserID=@UserID,UpdatedDate=GETDATE() where UserType= @UserType and MarketPoint=@MarketPoint and AgentCategory=@AgentCategory
	end

	Else If(@Option='MarkupType')
	begin
	  Update Flight_MarkupType set AgencyNames=@AgencyNames,AgencyId=@AgencyId,UserID=@UserID,UpdatedDate=GETDATE() where UserType= @UserType and MarketPoint=@MarketPoint and AgentCategory=@AgentCategory
	end


END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_UpdateAgentGroupMapping] TO [rt_read]
    AS [dbo];

