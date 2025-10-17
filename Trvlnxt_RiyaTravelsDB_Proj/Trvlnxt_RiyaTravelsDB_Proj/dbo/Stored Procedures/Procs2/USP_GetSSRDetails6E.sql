  
  
  
    
 CREATE Procedure USP_GetSSRDetails6E      
@Carrier varchar(10)      
AS      
BEGIN      
    if(@Carrier = 'IX' or @Carrier = 'I5')  
 begin   
  SELECT * FROM tblSSRListwithAbbreviation where (Carrier = 'IX' or Carrier = 'I5')  and IsActive=1    
 end   
 else   
 begin  
  SELECT * FROM tblSSRListwithAbbreviation where Carrier = @Carrier  and IsActive=1    
  end  
--WHERE SSRCode       
--IN (      
--     SELECT t.c.value('.', 'VARCHAR(20)')      
--     FROM (      
--         SELECT x = CAST('<t>' +       
--               REPLACE(@SSRCode, ',', '</t><t>') + '</t>' AS XML)      
--     ) a      
--     CROSS APPLY x.nodes('/t') t(c))       
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_GetSSRDetails6E] TO [rt_read]
    AS [dbo];

