    
    
CREATE proc B2B_GetCityBasedOnCountry        
@CountryID nvarchar(200)=null        
        
AS        
BEGIN        
 --select  ID,CityName         
 --from Hotel_City_Master       
       
 --where(CountryID IN (select Data from sample_split(@CountryID,',')))         
 --order by CityName asc        
      
 select  city.ID,CityName         
 from Hotel_City_Master city      
 join Hotel_CountryMaster cm on city.CountryID=cm.CountryCode       
 --where cm.Id IN (select Data from sample_split(@CountryID,','))      
  where cm.CountryCode IN (select Data from sample_split(@CountryID,',')) order by CityName     
END        
      
--select * from Hotel_City_Master where CountryID=106      
--Select * from Hotel_CountryMaster where id=101      
   





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[B2B_GetCityBasedOnCountry] TO [rt_read]
    AS [dbo];

