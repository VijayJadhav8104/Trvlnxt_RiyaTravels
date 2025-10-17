-- =============================================
-- Author:		Afifa
-- Create date: 01/April/2021
-- Description:	To get Pkid using pnr
-- =============================================
CREATE PROCEDURE [dbo].[sp_getPkidfromfkid] -- 'Quatation'
	-- Add the parameters for the stored procedure here
@fkid varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select pid from tblPassengerBookDetails
	where fkBookMaster=@fkid
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_getPkidfromfkid] TO [rt_read]
    AS [dbo];

