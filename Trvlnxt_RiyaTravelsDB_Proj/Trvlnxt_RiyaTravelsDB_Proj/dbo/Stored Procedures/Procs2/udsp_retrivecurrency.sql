CREATE proc [dbo].[udsp_retrivecurrency] 
@CityCode varchar(10)=''
As
BEGIN
	
	if(@CityCode!='')
	begin
		select CurrencyCode,CountryCode from tblAirportCity a inner join mCountryCurrency c
on a.COUNTRY =c.CountryCode where A.CODE  = @CityCode
	end
	
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[udsp_retrivecurrency] TO [rt_read]
    AS [dbo];

