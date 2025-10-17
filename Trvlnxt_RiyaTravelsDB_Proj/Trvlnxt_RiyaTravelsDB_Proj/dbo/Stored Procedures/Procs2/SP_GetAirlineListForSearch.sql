 --exec SP_GetAirlineListForSearch 'sg'  
 CREATE Procedure SP_GetAirlineListForSearch  
 @AirlineKey Nvarchar(100)=null  
 as  
 begin  
 
 IF EXISTS(SELECT * FROM AirlinesName WHERE _CODE=@AirlineKey)
 BEGIN
  SELECT DISTINCT _CODE,_NAME+'-'+_CODE as _NAME FROM AirlinesName where _CODE like  '%' + CAST(@AirlineKey as nvarchar(50)) + '%' 
 END

 ELSE
 BEGIN
 SELECT DISTINCT _CODE,_NAME+'-'+_CODE as _NAME FROM AirlinesName where   
 _NAME like  '%' + CAST(@AirlineKey as nvarchar(50)) + '%' ;      
   
END

END