CREATE PROCEDURE [dbo].[UDP_ERWPOptionsDataINC]      
      
AS      
BEGIN      
 SELECT DISTINCT Country FROM mastCountry ORDER BY Country ASC   
  
 SELECT DISTINCT City FROM mastCountry ORDER BY City ASC   
END 