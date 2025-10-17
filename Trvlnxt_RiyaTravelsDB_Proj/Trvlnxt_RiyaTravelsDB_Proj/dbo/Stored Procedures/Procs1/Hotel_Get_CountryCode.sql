-- =============================================
-- Author:		<Sandhya Gaikwad>
-- Create date: <3rd feb 2017>
-- Description:	<Get all countrycode>
-- =============================================
CREATE PROCEDURE [dbo].[Hotel_Get_CountryCode]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
			
    select CountryCode from Hotel_CountryMaster
   
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Hotel_Get_CountryCode] TO [rt_read]
    AS [dbo];

