
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[fetchTotalPrice]
	-- Add the parameters for the stored procedure here
		@pid varchar(50)= null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT basicFare, taxDesc ,totalTax,totalFare
	FROM tblBookMaster 
	WHERE OrderId=@pid
END









GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchTotalPrice] TO [rt_read]
    AS [dbo];

