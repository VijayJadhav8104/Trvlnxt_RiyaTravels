-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE ExtensionSessionInsert  
  
 @OfficeId varchar (20),  
 @LoginId varchar (20),  
 @SessionData text  
   
AS  
BEGIN  
   
 INSERT INTO ExtensionSessions (OfficeId,LoginId,SessionData) VALUES(@OfficeId,@LoginId,@SessionData);  
 SELECT SCOPE_IDENTITY()  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[ExtensionSessionInsert] TO [rt_read]
    AS [dbo];

