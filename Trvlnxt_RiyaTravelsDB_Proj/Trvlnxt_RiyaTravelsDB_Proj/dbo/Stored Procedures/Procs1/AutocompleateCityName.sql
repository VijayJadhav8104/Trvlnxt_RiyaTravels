    
    
CREATE PROCEDURE [dbo].[AutocompleateCityName]              
 -- Add the parameters for the stored procedure here              
               
 @city varchar(500)=null,              
 @HotelName nvarchar(500)=null,              
 @Nationality nvarchar(200)=null,              
 @Action varchar(200),              
 @Hotel_CountryCode nvarchar(500)='',              
 @Hotel_CityCode nvarchar(500)='',     
 @Hotel_CityCode2 nvarchar(500)=''     
              
AS              
BEGIN              
               
 if(@Action ='CityName')              
 Begin              
              
 select top 50 CM.CityCode,              
  --a.HotelName,              
  CM.CityName as cityname,           
   CM.ID as CityPKId,          
  a.CountryCode as countrycode,            
  b.ID as countrycodePKId,          
  CM.RealCityName as AmadeusCityName,              
  b.SmallCode AS AmadeusCountryCode,              
  CM.CityName +', '+ b.CountryName  as Label,              
  'City' as datatype,              
  COUNT(a.CityCode) as HotelCount              
                
  from Hotel_List_Master a              
  join Hotel_CountryMaster b on a.CountryCode=b.CountryCode             
            
  left join Hotel_City_Master CM on a.CityCode=CM.CityCode          
  where         
          
  (a.name like '%'+@city+'%' or b.CountryName like '%'+@city+'%')        
          
  and a.CityCode is not null  and CM.ID is not null          
  group by CM.CityCode,CM.CityName,CM.ID,a.CountryCode,b.ID,CM.CityName +', '+ b.CountryName,CM.RealCityName,b.SmallCode         
        
  order by COUNT(a.CityCode) desc        
          
  --union all              
              
  --select top 50 a.CityCode,              
  ----a.HotelName,              
  --a.name as cityname,          
  -- CM.ID as CityPKId,          
  --a.CountryCode as countrycode,            
  --b.ID as countrycodePKId,          
  --AC.SEARCHNAME as AmadeusCityName,                
  --cc.A1 AS AmadeusCountryCode,              
  --a.HotelName+', '+a.name +', '+ b.CountryName  as Label,              
  --'Hotel' as datatype,              
  --COUNT( a.CityCode) as HotelCount           
          
              
              
  --from Hotel_List_Master a              
  --join Hotel_CountryMaster b on a.CountryCode=b.CountryCode              
  --left join tblAirportCity AC on a.name=AC.SEARCHNAME              
  --left JOIN Country cc ON cc.A1 =AC.COUNTRY              
  --left join Hotel_City_Master CM on a.CityCode=CM.CityCode          
  --where a.HotelName like ''+@city+'%' and a.CityCode is not null    and CM.ID is not null            
  --group by a.CityCode,a.name,CM.ID,a.CountryCode,b.ID,a.HotelName+', '+a.name +', '+ b.CountryName,AC.SEARCHNAME,cc.A1         
          
              
  --union all              
              
  --select top 50 a.CityCode,              
  ----a.HotelName,              
  --a.name as cityname,           
  -- CM.ID as CityPKId,          
  --a.CountryCode as countrycode,             
  --b.ID as countrycodePKId,          
  --AC.SEARCHNAME as AmadeusCityName,               
  --cc.A1 AS AmadeusCountryCode,               
  --a.address+', '+a.name +', '+ b.CountryName  as Label,              
  --'Address' as datatype,              
  --COUNT(a.CityCode) as HotelCount              
              
  --from Hotel_List_Master a              
  --join Hotel_CountryMaster b on a.CountryCode=b.CountryCode              
  --left join tblAirportCity AC on a.name=AC.SEARCHNAME              
  --left JOIN Country cc ON cc.A1 =AC.COUNTRY              
  --left join Hotel_City_Master CM on a.CityCode=CM.CityCode          
  --where a.address like ''+@city+'%' and a.CityCode is not null  and CM.ID is not null              
  --group by a.CityCode,a.name,CM.ID,a.CountryCode,b.ID,a.address+', '+a.name +', '+ b.CountryName,AC.SEARCHNAME,cc.A1        
  --order by COUNT(a.CityCode) desc        
                 
               
 End              
               
 if(@Action ='HotelName')              
 Begin              
  
 if(@Hotel_CityCode = '64440')  
 BEGIN  
set @Hotel_CityCode2 = '106_19750-BOM_3293'   
 END  
  
  
 select a.HotelName+' - '+ a.name as HotelName,              
   a.Hotel_id          
  from Hotel_List_Master a     
  LEFT JOIN Hotel_City_Master HC ON a.CityCode = HC.CityCode      
  where HotelName like '%'+@HotelName+'%'         
  and (a.CityCode=@Hotel_CityCode or @Hotel_CityCode='' or a.CityCode = @Hotel_CityCode2)          
  and (a.CountryCode=@Hotel_CountryCode or @Hotel_CountryCode='' )           
  order by HotelName              
               
 End              
              
 if(@Action = 'Nationality')              
 Begin              
  select top 50 a.Id,              
      a.ISOCode,          
      a.Nationality,              
      a.Code,              
      a.Code + '_' + a.ISOCode as bindValue,              
   b.CountryName              
              
  from Hotel_Nationality_Master a              
  left join Hotel_CountryMaster b on a.Code=b.CountryCode              
              
  where a.Nationality like '%'+@Nationality+'%'              
  order by Nationality              
 End              
              
END     
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AutocompleateCityName] TO [rt_read]
    AS [dbo];

