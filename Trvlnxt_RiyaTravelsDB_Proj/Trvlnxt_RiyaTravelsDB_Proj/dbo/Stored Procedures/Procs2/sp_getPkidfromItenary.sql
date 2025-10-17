-- =============================================
-- Author:		Afifa
-- Create date: 01/aug/2021
-- Description:	To get Pkid using pnr
-- =============================================
CREATE PROCEDURE [dbo].[sp_getPkidfromItenary] -- 'Quatation'
	-- Add the parameters for the stored procedure here
@fkid varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select pkId from tblBookItenary
	where fkBookMaster=@fkid
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_getPkidfromItenary] TO [rt_read]
    AS [dbo];

