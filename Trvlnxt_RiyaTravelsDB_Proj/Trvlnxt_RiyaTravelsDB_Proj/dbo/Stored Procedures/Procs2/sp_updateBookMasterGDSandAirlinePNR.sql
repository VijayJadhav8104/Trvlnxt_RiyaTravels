-- =============================================
-- Author:		Afifa
-- Create date: 23/july/2021
-- Description:	To get Pkid using pnr
-- =============================================
create PROCEDURE [dbo].sp_updateBookMasterGDSandAirlinePNR-- 'Quatation'
	-- Add the parameters for the stored procedure here
@pkid varchar(100),
@gdspnr varchar(50),
@airlinepnr varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	update tblBookMaster
	set IsBooked=1,GDSPNR=@gdspnr
	where pkId=@pkid
	update tblBookItenary
	set airlinePNR=@airlinepnr
	where fkBookMaster=@pkid
	SET NOCOUNT ON;
	
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_updateBookMasterGDSandAirlinePNR] TO [rt_read]
    AS [dbo];

