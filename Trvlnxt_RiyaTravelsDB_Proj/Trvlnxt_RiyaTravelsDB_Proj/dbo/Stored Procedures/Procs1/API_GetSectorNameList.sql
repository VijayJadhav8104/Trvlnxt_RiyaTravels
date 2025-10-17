                 
CREATE PROCEDURE [dbo].[API_GetSectorNameList]
@SectorName varchar(255) = ''          
            
AS                    
BEGIN                

select CODE,[NAME],[Country] From tblAirportCity where [NAME] like '%'+@SectorName+'%'
   
END 


