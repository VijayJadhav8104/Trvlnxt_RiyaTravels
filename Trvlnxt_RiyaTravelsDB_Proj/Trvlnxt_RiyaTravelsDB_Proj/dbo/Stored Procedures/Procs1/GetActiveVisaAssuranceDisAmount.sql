-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetActiveVisaAssuranceDisAmount] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select  Id,
			ActualCost,
			DiscountedCost 

	from tblVisaAssuranceAmount
	where IsActive=1
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetActiveVisaAssuranceDisAmount] TO [rt_read]
    AS [dbo];

