CREATE proc Hotel.DestinationwiseCountry  
as  
  
begin  
select Countryid,CountryName from Hotel.DestinationwiseCountryList  where isactive=1
end