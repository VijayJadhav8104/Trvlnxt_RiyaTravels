-- =============================================
-- Author:		RahulAgrahari	
-- Create date: 25-07-2020
-- Description:	Get State Quarantine Policy Details
-- =============================================
CREATE PROCEDURE SP_StateQuarantine
	-- Add the parameters for the stored procedure here
	@StateId varchar(50)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from RiyaTravels.dbo.StateQuarantine where State=@StateId;
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_StateQuarantine] TO [rt_read]
    AS [dbo];

