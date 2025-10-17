-- =============================================                  
-- Author:  <Author,,Name>                  
-- Create date: <Create Date,,>                  
-- Description: <Description,,>                
-- exec GetSSRDetailsAirLineWise 'I5','2022-01-30', '2022/01/30','Meal','EC'           
-- exec GetSSRDetailsAirLineWise 'I5','04/02/2022' ,'04/02/2022','Meal','EC'        
-- exec GetSSRDetailsAirLineWise 'I5','2021-10-06T01:50:00Z','2021-10-06T04:05:00Z' ,'Meal','EC'        
-- exec GetSSRDetailsAirLineWise 'I5','10/02/2022 05:20:00','10/02/2022 05:20:00' ,'Meal','EC'        
-- =============================================                  
CREATE PROCEDURE [dbo].[GetSSRDetailsAirLineWise] --'2021-10-06T01:50:00Z','2021-10-06T04:05:00Z'                  
@Carrier char(2),            
          
@Type varchar(10) null,          
@ProductClass varchar(5) null          
            
            
AS                  
BEGIN              
IF(@Type='Meal')  
IF(@Carrier='IX')
BEGIN
 select SSRCode, Description, Type from tblSSRListwithAbbreviation                   
 where  Carrier=@Carrier and  Type = 'Meal'               
  AND IsActive=1             
 END
 ELSE
 BEGIN
 select SSRCode, Description, Type from tblSSRListwithAbbreviation                   
 where  Carrier=@Carrier and  Type = 'Meal'               
  AND IsActive=1             
 and ProductClass =@ProductClass 
 END
--and   FromDate  <=GETDATE() and ToDate >=   GETDATE()       
 ELSE IF(@Type='Baggage')                 
  select SSRCode, Description, Type from tblSSRListwithAbbreviation                   
  where Carrier=@Carrier and Type='Baggage'                  
  AND IsActive=1   
 ELSE IF(@Type ='' or @Type is null)  
 select SSRCode, Description, Type from tblSSRListwithAbbreviation    
 where Carrier=@Carrier  AND IsActive=1  
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetSSRDetailsAirLineWise] TO [rt_read]
    AS [dbo];

