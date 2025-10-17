-- =============================================      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>      
-- execute AddmUserForDisplaySupplierRights   13,46,'Agent'  
-- =============================================      
CREATE PROCEDURE AddmUserForDisplaySupplierRights -- Add the parameters for the stored procedure here      
 @id INT = NULL  
 ,@UserId INT = NULL  
 ,@Action VARCHAR(50) = NULL  
AS  
BEGIN  
 IF (@Action = 'mUser')  
 BEGIN  
  IF NOT EXISTS (  
    SELECT FkmUserid  
    FROM SupplierDisplayRights  
    WHERE FkmUserId = @id  
    )  
  BEGIN  

  

   INSERT INTO SupplierDisplayRights (  
    FkmUserId  
    ,DisplayRights  
    ,CreatedBy  
    ,UserType  
    )  
   VALUES (  
    @id  
    ,1  
    ,@UserId  
    ,'mUser'  
    )  
  END  
  ELSE IF EXISTS (  
    SELECT FkmUserid  
    FROM SupplierDisplayRights  
    WHERE FkmUserId = @id  
    )  
  BEGIN 
  
 

   UPDATE SupplierDisplayRights  
   SET DisplayRights = CASE   
     WHEN DisplayRights = 1  
      THEN 0  
     WHEN DisplayRights = 0  
      THEN 1  
     END  
    ,modifiedBy = @UserId  
    ,modifiedOn = GETDATE()  
   WHERE Id = @id  
  END  
 END  



 ELSE IF (@Action = 'Agent')  
 BEGIN  

  IF NOT EXISTS (  
    SELECT fkB2bRegistrationId  
    FROM SupplierDisplayRights  
    WHERE fkB2bRegistrationId = @id  
    )  
  BEGIN  

  select 'NOT EXISTS'
   INSERT INTO SupplierDisplayRights (  
    fkB2bRegistrationId  
    ,DisplayRights  
    ,CreatedBy  
    ,UserType  
    )  
   VALUES (  
    @id  
    ,1  
    ,@UserId  
    ,'Agent'  
    )  
  
      
  END    
  
  ELSE IF EXISTS (  
    SELECT FKB2bRegistrationId  
    FROM SupplierDisplayRights  
    WHERE FKB2bRegistrationId = @id  
    )  
  BEGIN 


   select 'EXISTS'
   UPDATE SupplierDisplayRights  
   SET DisplayRights = CASE   
     WHEN DisplayRights = 1  
      THEN 0  
     WHEN DisplayRights = 0  
      THEN 1  
     END  
    ,modifiedBy = @UserId  
    ,modifiedOn = GETDATE()  
   WHERE Id = @id  
  
     
  END  
 END  
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AddmUserForDisplaySupplierRights] TO [rt_read]
    AS [dbo];

