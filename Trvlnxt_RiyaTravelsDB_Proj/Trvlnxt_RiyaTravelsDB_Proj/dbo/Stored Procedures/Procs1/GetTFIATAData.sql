CREATE PROC GetTFIATAData
	@Country VARCHAR(20),@Airline VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IATA VARCHAR(200)
	Select TOP 1 @IATA=IATA from TFNdcIatamaster Where Country=@Country

	IF EXISTS(Select AgentLogin from TFNdcCredentialsmaster WHERE Airline=@Airline AND Country=@Country)
	BEGIN
		Select AgentLogin,Password,@IATA AS IATA,AgentIdentifier from TFNdcCredentialsmaster WHERE Airline=@Airline AND Country=@Country
	END
	ELSE
	BEGIN
		Select top 1 '' AS AgentLogin,'' AS Password,@IATA AS IATA,'' AS AgentIdentifier from TFNdcCredentialsmaster
	END
END
