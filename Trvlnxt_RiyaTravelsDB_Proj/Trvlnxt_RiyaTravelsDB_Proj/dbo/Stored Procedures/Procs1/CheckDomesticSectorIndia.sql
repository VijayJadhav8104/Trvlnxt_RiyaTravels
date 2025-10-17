--exec CheckDomesticSectorIndia 'BOM','Del'

CREATE procedure CheckDomesticSectorIndia
@Travelfrom nvarchar(20),
@Travelto nvarchar(20)
as
begin

declare @FromCountryCode nvarchar(20)
declare @ToCountryCode nvarchar(20)
set @FromCountryCode=(select Country from tblAirportCity where code=@Travelfrom)
set @ToCountryCode=(select Country from tblAirportCity where code=@Travelto)

if(@FromCountryCode='IN' and @ToCountryCode='IN')
begin
select 'True' as Flag
end
else
begin
select 'False' as Flag
end

end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CheckDomesticSectorIndia] TO [rt_read]
    AS [dbo];

