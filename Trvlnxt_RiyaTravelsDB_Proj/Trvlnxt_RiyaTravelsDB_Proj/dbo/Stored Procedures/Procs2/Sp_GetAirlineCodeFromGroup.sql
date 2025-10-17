-- =============================================
-- Author:		Bhavika kawa
-- Create date: 03/06/2020
-- Description:	to get airline code on the basis of selected group
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetAirlineCodeFromGroup]
	@ServiceType varchar(100),
	@GroupName varchar(100)
AS
BEGIN
	if(@ServiceType='Service fee/GST/Quotation')
	BEGIN
		SELECT AirlineType FROM tbl_ServiceFee_GST_QuatationDetails WHERE AgentCategory=@GroupName
	END
	if(@ServiceType='MarkupType')
	BEGIN
		SELECT AirlineType FROM Flight_MarkupType WHERE AgentCategory=@GroupName
	END
	if(@ServiceType='Flat')
	BEGIN
		SELECT AirlineType FROM Flight_Flat WHERE AgentCategory=@GroupName
	END
	if(@ServiceType='PromoCode')
	BEGIN
		SELECT AirlineType FROM Flight_PromoCode WHERE AgentCategory=@GroupName
	END
	if(@ServiceType='PricingCode/Tourcode/Commission')
	BEGIN
		SELECT AirlineType FROM Flight_Commission WHERE AgentCategory=@GroupName
	END
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAirlineCodeFromGroup] TO [rt_read]
    AS [dbo];

