
CREATE proc [dbo].[GetAirportCountryBySector]

@FromLocation varchar(50),
@ToLocation varchar(50)

as
begin

select * from [dbo].[tblAirportCity] where code= @FromLocation or code=@ToLocation

end