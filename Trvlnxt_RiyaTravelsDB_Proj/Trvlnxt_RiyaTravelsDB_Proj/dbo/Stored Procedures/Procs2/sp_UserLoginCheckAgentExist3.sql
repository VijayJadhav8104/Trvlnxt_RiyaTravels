CREATE PROCEDURE [dbo].[sp_UserLoginCheckAgentExist3]   
 @UserName varchar(500) = NULL  
 , @Password varchar(300) = NULL  
 , @opr int  
 , @Device VARCHAR(50) = NULL  
 , @IPAddress VARCHAR(50) = NULL  
 , @Browser VARCHAR(50) = NULL  
 , @Country VARCHAR(2) = NULL  
AS  
BEGIN  
     DECLARE @UserID INT, @UserType varchar(10)    
    SELECT @UserID = ID  FROM mUser WHERE UserName = @UserName AND isActive = 1 --AND Password = @EncryptPassword      
            
     IF(@UserID IS NULL)            
     BEGIN            
       SELECT @UserID = UserID  FROM AgentLogin WHERE UserName = @UserName AND IsActive = 1            
       SET @UserType = 'Agent'            
     END            
     ELSE            
     BEGIN            
        SET @UserType = 'User'            
     END   
 IF(@UserName IS NOT NULL)  
 BEGIN  
  --IF(EXISTS(SELECT ID FROM mUser WHERE UserName = @UserName or EmailID = @UserName))  
  --BEGIN  
  -- SELECT EmailID AS EmailId  
  --   , UserName AS Username  
  --   , MobileNo AS MobileNo  
  -- FROM mUser  
  -- WHERE UserName = @UserName or EmailID = @UserName;  
  --END  
  --ELSE   
  IF(EXISTS(SELECT UserID FROM agentLogin WHERE UserName = @UserName))  
  BEGIN  
    if(@UserType = 'User')  
    BEGIN  
   SELECT b2b.AddrEmail AS EmailID  
     , agent.UserName AS UserNames  
     , agent.MobileNumber AS MobileNo  
     ,agent.UserID AS AgentID  
   FROM B2BRegistration AS b2b  
   INNER JOIN agentLogin agent ON agent.UserID = b2b.FKUserID    
   WHERE FKUserID IN (SELECT UserID FROM agentLogin WHERE UserName = @UserName)  
          END  
    ELSE  
    BEGIN  
   --SELECT b2b.AddrEmail AS EmailID  
   --  , agent.UserName AS UserNames  
   --  , agent.MobileNumber AS MobileNo  
   --  ,agent.UserID AS AgentID  
   --FROM B2BRegistration AS b2b  
   --INNER JOIN agentLogin agent ON agent.UserID = b2b.FKUserID    
   --WHERE FKUserID IN (SELECT UserID FROM agentLogin WHERE UserName = @UserName)  
   -- OR FKUserID IN (SELECT ParentAgentID FROM agentLogin WHERE UserName = @UserName)
   
   select al.UserID as AgentID, al.UserName AS UserNames,
isnull(b.AddrEmail,al.SubUserEmail) AS EmailID,
al.MobileNumber AS MobileNo
 from agentlogin al with (nolock)
 left join B2BRegistration b with (nolock) on b.FKUserID=al.UserID
 left join B2BRegistration b1 with (nolock) on b1.FKUserID=al.ParentAgentID 
where al.UserName=@UserName
          END  
  END  
  ELSE IF(EXISTS(SELECT PKID FROM B2BRegistration WHERE AddrEmail = @UserName))  
  BEGIN  
   DECLARE @fkId int  
  
   --SET @fkId = (SELECT FKUserID from B2BRegistration   
   --    WHERE AddrEmail = @UserName)  
  
   -- BUGFIX: Change by hardik 10.09.2023 SubQuery bug fix  
   SELECT TOP 1 @fkId = FKUserID from B2BRegistration WHERE AddrEmail = @UserName  
     
   SELECT a.UserName AS UserNames  
     , b.AddrEmail AS EmailID  
     , a.MobileNumber AS MobileNo   
     ,a.UserID AS AgentID   
   FROM agentLogin a   
   INNER JOIN B2BRegistration b ON a.UserID = b.FKUserID  
   WHERE UserID = @fkId    
  END  
 END  
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UserLoginCheckAgentExist3] TO [rt_read]
    AS [dbo];

