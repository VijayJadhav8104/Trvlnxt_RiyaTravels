CREATE PROCEDURE [dbo].[GetAllEmailForAgentLimitAlert]        
         
AS        
BEGIN        
         
 select Id,ToEmail,CcEmail from tblAgentLimitAlert where id=1
END 



