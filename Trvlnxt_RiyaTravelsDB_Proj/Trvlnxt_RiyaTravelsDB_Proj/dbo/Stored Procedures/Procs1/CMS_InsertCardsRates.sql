
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CMS_InsertCardsRates]
	-- Add the parameters for the stored procedure here	
	@occupytype varchar(100),
	@price bigint,
	@aircost varchar(100),
	@landcost varchar(100)
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	

	--if not exists(select [PKID_int] from CMS_CardRates where inserteddt_dt = CAST(GETDATE() as date))
 --   -- Insert statements for procedure here
	--begin
	insert into CMS_CardRates(occupytype_ch,basicprice_int,aircost_vc,landcost_vc) values(@occupytype,@price,@aircost,@landcost)
	--end
	--else
	--begin

	--update CMS_CardRates set occupytype_ch = @occupytype,basicprice_int=@price,aircost_vc=@aircost,landcost_vc=@landcost,lastupdated_dt = GETDATE() where inserteddt_dt = CAST(GETDATE() as date)
	--end
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_InsertCardsRates] TO [rt_read]
    AS [dbo];

