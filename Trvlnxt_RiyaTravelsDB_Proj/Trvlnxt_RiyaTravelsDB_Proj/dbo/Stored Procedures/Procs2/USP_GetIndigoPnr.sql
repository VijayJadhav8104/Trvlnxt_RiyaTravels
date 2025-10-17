
-- ===================================================================================================    
-- Author:  Amruta P    
-- Create date: 14 JUN 2023    
-- Description: get pnr and officeid from   temp_indigo_pnr table 
-- ===================================================================================================    
    
CREATE PROCEDURE [dbo].[USP_GetIndigoPnr]    
   
AS    
BEGIN    
select pnr,officeid 
from temp_indigo_pnr
END