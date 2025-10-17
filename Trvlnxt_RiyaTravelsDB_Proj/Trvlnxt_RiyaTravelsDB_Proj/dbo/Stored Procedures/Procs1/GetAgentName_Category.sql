create proc [dbo].[GetAgentName_Category]
@ServiceType int,
@UserType varchar(50),
@Country varchar(10)
AS
BEGIN
	
		if (@ServiceType=1)
		begin
		select AgencyId,AgencyNames,AgentCategory,id from tbl_ServiceFee_GST_QuatationDetails S
		where MarketPoint=@Country AND UserType IN (SELECT VALUE FROM mCommon WHERE ID=@UserType)
		end
		ELSE if (@ServiceType=2)
		begin
		select AgencyId,AgencyNames,AgentCategory,id from Flight_Flat S
		where MarketPoint=@Country AND UserType IN (SELECT VALUE FROM mCommon WHERE ID=@UserType)
		end
		ELSE if (@ServiceType=3)
		begin
		select AgencyId,AgencyNames,AgentCategory,id from Flight_MarkupType S
		where MarketPoint=@Country AND UserType IN (SELECT VALUE FROM mCommon WHERE ID=@UserType)
		end
		ELSE if (@ServiceType=4)
		begin
		select AgencyId,AgencyNames,AgentCategory,id from Flight_PromoCode S
		where MarketPoint=@Country AND UserType IN (SELECT VALUE FROM mCommon WHERE ID=@UserType)
		end
		ELSE if (@ServiceType=5)
		begin
		select AgencyId,AgencyNames,AgentCategory,id from FlightCommission S
		where MarketPoint=@Country AND UserType IN (SELECT VALUE FROM mCommon WHERE ID=@UserType)
		end
	END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAgentName_Category] TO [rt_read]
    AS [dbo];

