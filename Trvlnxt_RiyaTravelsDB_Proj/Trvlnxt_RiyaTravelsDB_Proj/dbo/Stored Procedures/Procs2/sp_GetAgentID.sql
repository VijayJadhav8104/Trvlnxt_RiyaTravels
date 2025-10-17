CREATE PROCEDURE [dbo].[sp_GetAgentID]               
 @Icast varchar(50)             
AS              
BEGIN          
           
 SELECT FKUserID FROM B2BRegistration where [Icast] = @Icast and (FKUserID != null OR FKUserID is not null)
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetAgentID] TO [rt_read]
    AS [dbo];

