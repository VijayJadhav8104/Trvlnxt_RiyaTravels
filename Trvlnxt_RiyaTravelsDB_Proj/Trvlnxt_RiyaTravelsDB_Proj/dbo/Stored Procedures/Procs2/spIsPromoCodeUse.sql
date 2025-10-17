-- =============================================
-- Author:	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[spIsPromoCodeUse] --[spIsPromoCodeUse] 'qa@riya.travel','welcome'
-- Add the parameters for the stored procedure here
@Username varchar(100),
@promoCode varchar(100)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

    -- Insert statements for procedure herezl
select * from tblBookMaster where emailId=@Username and promoCode=@promoCode and GDSPNR is not null

END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spIsPromoCodeUse] TO [rt_read]
    AS [dbo];

