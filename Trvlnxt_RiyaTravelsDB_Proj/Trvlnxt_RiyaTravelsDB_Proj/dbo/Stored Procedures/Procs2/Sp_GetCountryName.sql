    
-- =============================================    
-- Author: Satya
-- Description: Get Country
-- =============================================    
create PROCEDURE [dbo].[Sp_GetCountryName]    
 @Code varchar(10)    
AS    
BEGIN    
  
 select COUNTRY from tblAirportCity where CODE=@Code

END    

