
CREATE Procedure [dbo].[GetMtopMenuAccess]        
  @UserId int,  
  @IsUser bit = null
  AS  
  BEGIN        
          
  IF(@UserId != 0 and @IsUser = 0)  
  BEGIN  
  SELECT  MenuName,Menulink FROM mtopMenuAccess WHERE AgentID=@UserId  and Isstaff=0
  END  
  ELSE  
   BEGIN  
  SELECT  MenuName,Menulink FROM mtopMenuAccess WHERE Isstaff=1 and AgentID=@UserId  
  END  
          
  END