CREATE Procedure Proc_GetCityNameInMaster  
@CityName varchar(200)  
As  
Begin  
 select top 50 RealCityName,id from Hotel_City_Master Where RealCityName like '%'+@CityName+'%'  
End  