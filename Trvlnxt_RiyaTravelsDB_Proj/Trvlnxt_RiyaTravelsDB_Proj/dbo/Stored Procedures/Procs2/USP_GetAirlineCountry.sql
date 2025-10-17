CREATE proc [dbo].[USP_GetAirlineCountry]-- 'cok','6e' ,'del'    
 @fromsector varchar(10),      
 @Carrier varchar(10) ,    
@ToSectors varchar(5)=null    
 as       
 begin      
 IF @Carrier in('QP' ,'I5'   ,'IX'  ,'SG'  ,'G8'  ,'6E'  ,'J9'  ,'G9','TF','3L','FZ' ,'OV')
 BEGIN     
 SELECT * FROM tblAirlineSectors       
 where Carrier=@Carrier       
 AND fromSector=@fromsector    
 and ToSector=@ToSectors    
 END    
 ELSE    
 BEGIN    
   SELECT * FROM tblAirlineCountry       
   WHERE Carrier=@Carrier       
   AND CountryCode=(SELECT TOP 1 COUNTRY FROM tblAirportCity WHERE CODE = @fromsector )      
   END    
 END

 --select * from tblAirlineSectors where Carrier='6e' and fromSector='blr'
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_GetAirlineCountry] TO [rt_read]
    AS [dbo];

