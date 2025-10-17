-- =============================================
-- Author:		Afifa
-- Create date: 01/aug/2020
-- Description:	To get Pkid using pnr
-- =============================================
CREATE PROCEDURE [dbo].sp_updateItenarytbl_AirlinePNR-- 'Quatation'
	-- Add the parameters for the stored procedure here
@pkid varchar(100),
@airlinepnr varchar(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	update tblBookItenary
	set airlinePNR=@airlinepnr
	where pkId=@pkid
	SET NOCOUNT ON;
	
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_updateItenarytbl_AirlinePNR] TO [rt_read]
    AS [dbo];

