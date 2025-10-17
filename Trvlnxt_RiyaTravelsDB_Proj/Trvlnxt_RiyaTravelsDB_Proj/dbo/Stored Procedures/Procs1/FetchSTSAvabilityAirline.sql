        
CREATE procedure FetchSTSAvabilityAirline        
@BussinessType varchar(20)        
        
As         
begin        
SELECT STUFF          
            (          
                (          
                    SELECT ',' + P.Carrier FROM tblSTSAvaibilityAirline P          
                    WHERE BussinessType in ('MN','ALL')     and IsActive=1    
                    FOR XML PATH('')          
                )         
            ,1,1,'') as Carrier      
    
--select * from tblSTSAvaibilityAirline WHERE BussinessType='MN'         
end 