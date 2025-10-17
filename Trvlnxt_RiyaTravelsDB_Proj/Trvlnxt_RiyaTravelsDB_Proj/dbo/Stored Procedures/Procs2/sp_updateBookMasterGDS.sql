-- =============================================
-- Author:		Afifa
-- Create date: 01/aug/2020
-- Description:	To get Pkid using pnr
-- =============================================
create PROCEDURE [dbo].sp_updateBookMasterGDS-- 'Quatation'
	-- Add the parameters for the stored procedure here
@pkid varchar(100),
@gdspnr varchar(50)


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	update tblBookMaster
	set IsBooked=1,GDSPNR=@gdspnr
	where pkId=@pkid
	
	SET NOCOUNT ON;
	
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_updateBookMasterGDS] TO [rt_read]
    AS [dbo];

