
CREATE FUNCTION [dbo].[ConcatenateFlighSector](@PKID VARCHAR(MAX))    
RETURNS VARCHAR(MAX)AS     
 BEGIN         
      
  DECLARE @RtnStr VARCHAR(MAX)        
      
  SET @RtnStr = ( SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	AS Sector FROM tblBookItenary t where t.fkBookMaster=@PKID  GROUP BY t.orderId)
  
  RETURN @RtnStr     
 END 
