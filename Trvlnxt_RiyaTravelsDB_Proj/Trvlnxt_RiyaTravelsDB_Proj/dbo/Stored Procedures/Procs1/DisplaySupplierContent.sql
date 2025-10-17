-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Hide and show Permition wise like SUpplier filter and Supplier name,,>  
-- =============================================  
CREATE PROCEDURE DisplaySupplierContent  
 -- Add the parameters for the stored procedure here  
 @MainAgentId int,
 @AgentId int  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
   
 select FkmUserId,DisplayRights from SupplierDisplayRights where (FkmUserId=@MainAgentId or FKB2bRegistrationId=@AgentId) and IsActive=1  
  
  
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DisplaySupplierContent] TO [rt_read]
    AS [dbo];

