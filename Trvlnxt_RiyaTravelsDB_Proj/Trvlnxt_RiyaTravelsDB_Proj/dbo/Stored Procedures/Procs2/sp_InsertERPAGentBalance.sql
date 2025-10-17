-- =============================================
-- Author:		Pradeep Pandey
-- Create date: 01 August 2020
-- Description:	To Update the ERP Agent Balance
-- =============================================
CREATE PROCEDURE [dbo].[sp_InsertERPAGentBalance] 
	-- Add the parameters for the stored procedure here
	@CustId varchar(100),
	@PreviousBalance Decimal,
	@NewBalance Decimal,
	@UserID int,
	@requestXML varchar(max)=null,
	@responseXML varchar(max)=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Insert into tblERPAgentBalance(CustID,PreviousBalance,NewBalance,InsertDate,UserID)
							Values(@CustId,@PreviousBalance,@NewBalance,GETDATE(),@UserID)

    update AgentLogin
	set AgentBalance=@NewBalance,
	BalanceUpdateDate=GETDATE()
	where UserID=@UserID

	if(@requestXML!='')
	begin
	insert into ERPBalanceLog
	(RequestXML,ResponseXML,CustNo)
	values(@requestXML,@responseXML,@CustId)
	end
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_InsertERPAGentBalance] TO [rt_read]
    AS [dbo];

