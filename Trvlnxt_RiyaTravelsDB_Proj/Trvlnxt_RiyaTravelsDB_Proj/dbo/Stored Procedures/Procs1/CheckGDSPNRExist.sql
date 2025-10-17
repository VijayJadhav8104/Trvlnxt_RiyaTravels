-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CheckGDSPNRExist]
	-- Add the parameters for the stored procedure here
	@PNR varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT top 1 orderId,riyaPNR from tblBookMaster where GDSPNR=@PNR
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CheckGDSPNRExist] TO [rt_read]
    AS [dbo];

