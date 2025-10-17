-- =============================================
-- Author:		Hardik Deshani
-- Create date: 05.07.2023
-- Description:	Add Agent Topup Log Entry
-- =============================================
CREATE PROCEDURE AgentTopupLog_Insert
	@UserID Int
	,@Amount Numeric(18,2)
	,@PaymentGatewayMode Varchar(50)
	,@ConvenienceFeeCharges Numeric(18,2)
	,@ConvenienceFeeAmount Numeric(18,2)
	,@PayableAmount Numeric(18,2)
	,@CardNo Varchar(50) = NULL
	,@ExpiryDate Varchar(50) = NULL
	,@AgentCountry Varchar(50) = NULL
	,@UserType Varchar(50) = NULL
	,@AgentCurrency Varchar(50) = NULL
	,@AgencyContactNo Varchar(50) = NULL
	,@AgencyEmail Varchar(200) = NULL
	,@AgencyName Varchar(50) = NULL
	,@ICUST Varchar(50) = NULL
	,@FirstName Varchar(50) = NULL
	,@LastName Varchar(50) = NULL
	,@TransactionID Varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ParentAgentID Int

	SELECT @ParentAgentID = ISNULL(ParentAgentID,0) FROM AgentLogin WHERE UserID = @UserID

    INSERT INTO AgentTopupLog (UserID
	,Amount
	,PaymentGatewayMode
	,ConvenienceFeeCharges
	,ConvenienceFeeAmount
	,PayableAmount
	,CardNo
	,ExpiryDate
	,AgentCountry
	,UserType
	,AgentCurrency
	,AgencyContactNo
	,AgencyEmail
	,AgencyName
	,ICUST
	,FirstName
	,LastName
	,TransactionID
	,ParentAgentID)
	VALUES (@UserID
	,@Amount
	,@PaymentGatewayMode
	,@ConvenienceFeeCharges
	,@ConvenienceFeeAmount
	,@PayableAmount
	,@CardNo
	,@ExpiryDate
	,@AgentCountry
	,@UserType
	,@AgentCurrency
	,@AgencyContactNo
	,@AgencyEmail
	,@AgencyName
	,@ICUST
	,@FirstName
	,@LastName
	,@TransactionID
	,@ParentAgentID)
END