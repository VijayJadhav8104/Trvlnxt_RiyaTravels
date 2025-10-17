-- =============================================  
-- Author:  Aditya  
-- Create date: 23.10.2024  
-- Description: Get Holiday Cities  
-- =============================================  
CREATE PROCEDURE [dbo].[HolidayCities_Get_V2]  
 @City Varchar(50)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 SELECT DISTINCT 
    CASE 
       WHEN City = State AND State = Country THEN City + ' , ' + Country  -- If City, State, and Country are all the same
       WHEN City = State THEN City + ' , ' + Country                      -- If City and State are the same, return City, Country
       WHEN State = Country THEN City + ' , ' + State                     -- If State and Country are the same, return City, State
       ELSE City + ' , ' + State + ' , ' + Country                        -- Default: return City, State, Country
    END AS City  
 FROM HolidayCities  
 WHERE City LIKE '%' + @City + '%'; 
  
END