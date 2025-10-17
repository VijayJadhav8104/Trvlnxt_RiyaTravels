
CREATE PROCEDURE [SS].[SP_GetAllNationality]
AS
BEGIN
	SELECT  
	  a.Id AS [NationalityId],  	  
      a.Nationality,                    
      b.CountryName ,
	  b.ID AS [CountryId]	  
          
  FROM 
		Hotel_Nationality_Master a          
       JOIN Hotel_CountryMaster b ON a.Code=b.CountryCode                    
  
  ORDER BY Nationality    
END




        
