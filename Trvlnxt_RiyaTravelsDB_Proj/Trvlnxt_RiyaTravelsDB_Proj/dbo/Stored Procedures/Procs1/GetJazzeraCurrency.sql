
CREATE proc [dbo].GetJazzeraCurrency 
@CityCode varchar(10)=''
As
BEGIN
	DECLARE @Result varchar(10) 
	if(@CityCode!='')
	begin
		set @Result = (select CurrencyCode from JazzeraOperatingCityDetails where AirportCode =@CityCode)
	end
	Select @Result
	
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetJazzeraCurrency] TO [rt_read]
    AS [dbo];

