CREATE proc [dbo].[sp_GetCountry_FromSectorAndToSector]       
@FromCityCode varchar(50) = ''       
,@ToCityCode varchar(50) = ''  
AS              
begin

    select (select top 1 COUNTRY as toCity_Country from tblAirportCity  where CODE =  @FromCityCode) as fromCity_Country,
	(select top 1 COUNTRY as toCity_Country from tblAirportCity  where CODE =  @ToCityCode) as toCity_Country           
    
end