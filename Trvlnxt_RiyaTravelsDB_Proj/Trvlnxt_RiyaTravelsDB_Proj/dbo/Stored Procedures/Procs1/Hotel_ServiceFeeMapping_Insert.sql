create PROCEDURE [dbo].[Hotel_ServiceFeeMapping_Insert]
	@AgentID INT,
	@ServiceFeeTypeDomestic INT,
	@ServiceFeeDomestic DECIMAL(18,2),
	@ServiceFeeTypeInternational INT,
	@ServiceFeeInternational DECIMAL(18,2)
AS
BEGIN
	
	IF NOT EXISTS (SELECT * FROM [dbo].[Hotel_AgentServiceFeeMapping] WHERE AgentID = @AgentID)
	BEGIN
		INSERT INTO [dbo].[Hotel_AgentServiceFeeMapping](AgentID,
			ServiceFeeTypeDomestic , ServiceFeeDomestic,
			ServiceFeeTypeInternational	, ServiceFeeInternational,
			CreateDate, ModifyDate)
		VALUES(@AgentID, @ServiceFeeTypeDomestic, @ServiceFeeDomestic, 
			@ServiceFeeTypeInternational, @ServiceFeeInternational,
			GETDATE(), GETDATE())
	END
	ELSE 
	BEGIN
		UPDATE  [dbo].[Hotel_AgentServiceFeeMapping] SET  			
			ServiceFeeTypeDomestic = @ServiceFeeTypeDomestic,
			ServiceFeeDomestic = @ServiceFeeDomestic,
			ServiceFeeTypeInternational = @ServiceFeeTypeInternational,
			ServiceFeeInternational = @ServiceFeeInternational,
			[ModifyDate] = GETDATE()
		WHERE 
			AgentID= @AgentID
	END


END



