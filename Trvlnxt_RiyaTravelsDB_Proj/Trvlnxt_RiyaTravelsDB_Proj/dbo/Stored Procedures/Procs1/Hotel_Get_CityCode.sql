-- =============================================
-- Author:		<Sandhya Gaikwad>
-- Create date: <3rd feb 2017>
-- Description:	<Get all countrycode>
-- =============================================
CREATE PROCEDURE [dbo].[Hotel_Get_CityCode]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --select CityCode,CountryID CountryCode from [dbo].[Hotel_City_Master]
	select HCM.CityCode,HC.CountryCode from Hotel_CountryMaster HC left join Hotel_City_Master HCM on HC.ID=hcm.CountryID	
	where CityCode is not null
   
END












GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Hotel_Get_CityCode] TO [rt_read]
    AS [dbo];

