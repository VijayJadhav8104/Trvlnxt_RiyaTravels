-- =============================================    
-- Author:  Afifa    
-- Create date: 30/sept/2021   
-- Description: To get Common Data For DropDown    
-- [dbo].[GetCommonDropDownData] 'UserType'    
-- =============================================    
CREATE PROCEDURE [dbo].[SelectAllICust]-- 'Quatation'    
 -- Add the parameters for the stored procedure here    
     
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
 --SELECT DISTINCT Icast as ICust  FROM B2BRegistration where Icast is not null  
 SELECT DISTINCT 
 b.Icast + '?' + a.UserName + '?' + CAST(a.UserID AS Varchar(50)) AS ICust
 FROM B2BRegistration b WITH(NOLOCK)
 INNER JOIN AgentLogin a WITH(NOLOCK) ON a.UserID=b.FKUserID
 WHERE Icast IS NOT NULL
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SelectAllICust] TO [rt_read]
    AS [dbo];

