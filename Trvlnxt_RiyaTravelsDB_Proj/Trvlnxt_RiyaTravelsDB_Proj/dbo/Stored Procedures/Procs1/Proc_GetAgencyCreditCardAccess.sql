--Proc_GetAgencyCreditCardAccess 21958
CREATE Procedure Proc_GetAgencyCreditCardAccess
@AgentId int=0
AS
Begin
	Select CreditLimitPaymentMode from HotelAgencyCreditLimitRestrictions where AgencyFKUserId=@AgentId
END