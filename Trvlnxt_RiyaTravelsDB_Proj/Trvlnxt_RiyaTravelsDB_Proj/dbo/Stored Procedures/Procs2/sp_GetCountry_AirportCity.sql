CREATE proc [dbo].[sp_GetCountry_AirportCity]   
@FromCityCode varchar(MAX) = ''   
,@ToCityCode varchar(MAX) = ''   
AS          
begin    
	
	declare @fromCity_Country varchar(MAX) = ''  
	Declare @toCity_Country varchar(MAX) = ''  
  
  if(@ToCityCode != '')
  begin

	   select @fromCity_Country = COUNTRY from tblAirportCity  where CODE =  @FromCityCode       
	   select @toCity_Country = COUNTRY from tblAirportCity  where CODE =  @ToCityCode       
  
	   if(@fromCity_Country = @toCity_Country)  
	   begin  
		  select 1   
	   end  
	   else  
	   begin  
		   select 2  
	   end 
   end

   else 
   begin       	   
	   select COUNTRY from tblAirportCity  where CODE IN  ( select Data from sample_split(@FromCityCode,',')) 
   end




end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetCountry_AirportCity] TO [rt_read]
    AS [dbo];

