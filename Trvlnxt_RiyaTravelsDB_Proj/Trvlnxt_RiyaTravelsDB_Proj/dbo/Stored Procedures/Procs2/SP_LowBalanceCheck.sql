CREATE PROCEDURE SP_LowBalanceCheck
@agentID varchar(50),
@checkBalance money
AS
BEGIN

	DECLARE @ClosingBalance money
	DECLARE @IsLowBalance bit
	DECLARE @AgencyName varchar(300)

		SET @ClosingBalance=(SELECT top 1 CloseBalance 
							 FROM tblAgentBalance 
		                     WHERE AgentNo=@agentID order by PKID desc)

		IF(@ClosingBalance < @checkBalance)
		BEGIN
			SET @IsLowBalance=1
			SET @AgencyName=(select top 1 AgencyName +' ( ' + CustomerCOde +' )'  from B2BRegistration where FKUserID = @agentID)
		END
		ELSE
		BEGIN
			SET @IsLowBalance=0
		END

		IF(@IsLowBalance = 1)
		BEGIN 
			SELECT @IsLowBalance as IsLowBalance,@ClosingBalance as CloseBalance,@AgencyName as AgencyName
		END
END