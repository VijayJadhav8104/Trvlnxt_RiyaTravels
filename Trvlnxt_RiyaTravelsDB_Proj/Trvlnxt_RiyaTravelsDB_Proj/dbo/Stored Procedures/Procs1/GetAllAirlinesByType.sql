
CREATE PROCEDURE [dbo].[GetAllAirlinesByType]
@p_sType varchar(20)
AS
BEGIN

if @p_sType='ALL'
begin

	select iD,_NAME,_CODE,ICAO,type from AirlinesName an inner join AirlineCode_Console acc
on an._CODE=acc.AirlineCode 
union all
select Id as iD ,
VendorName as _NAME, 
REPLACE(VendorName,'NDC','') _CODE ,
'' as ICAO,
FlightType type from tbl_FlightTypeFilter where FlightType='NDC'

end
else if @p_sType='NDC'
begin
select Id as iD ,
VendorName as _NAME, 
REPLACE(VendorName,'NDC','') _CODE ,
'' as ICAO,
FlightType type from tbl_FlightTypeFilter where FlightType='NDC'

select Id as iD,_NAME,_CODE,ICAO,type from AirlinesName an inner join AirlineCode_Console acc
on an._CODE=acc.AirlineCode where acc.type=@p_sType
end
else  
begin
select iD,_NAME,_CODE,ICAO,type from AirlinesName an inner join AirlineCode_Console acc
on an._CODE=acc.AirlineCode where acc.type=@p_sType
end

END
