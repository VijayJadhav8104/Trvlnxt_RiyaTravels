-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_SelectTimeZone]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT id,(Timezone+' '+Locations) zone,Timezone FROM Tbl_Timezone
	select * from Tbl_Timezone
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_SelectTimeZone] TO [rt_read]
    AS [dbo];

