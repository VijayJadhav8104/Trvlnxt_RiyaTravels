-- =============================================
-- Author:		Afifa
-- Create date: 23/July/2021
-- Description:	To get Pkid using pnr
-- =============================================
create PROCEDURE [dbo].[sp_getPkid]-- 'Quatation'
	-- Add the parameters for the stored procedure here
@riyaPNR varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select pkid from tblBookMaster
	where riyaPNR=@riyaPNR
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_getPkid] TO [rt_read]
    AS [dbo];

