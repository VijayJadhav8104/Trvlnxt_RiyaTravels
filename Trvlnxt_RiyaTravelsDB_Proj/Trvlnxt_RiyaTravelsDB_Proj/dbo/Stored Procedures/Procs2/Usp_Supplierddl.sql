            
        
            
            
          
CREATE proc Usp_Supplierddl              
              
as              
              
              
begin              
SET NOCOUNT ON;                
              
select  CountryCode,CountryName from Hotel_CountryMaster where ID in (101,132,1,2,130,123)   ORDER BY CountryName       
           
--select  Distinct Value as 'CountryCode' FROM mCommon WHERE Category='Currency' and mCommon.Value  is not null              
              
 select  ID, Value  as 'CountryCode'  FROM mCommon WHERE Category='Currency' AND ID IN (65,107,185,191,196,170,165)      
     union        
 select  -1 ,'MULTI'        
    
  ORDER BY CountryCode     
end        
        
  


