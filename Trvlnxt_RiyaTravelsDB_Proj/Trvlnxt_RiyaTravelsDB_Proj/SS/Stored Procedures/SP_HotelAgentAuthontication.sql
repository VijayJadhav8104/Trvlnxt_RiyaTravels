
  
CREATE PROCEDURE [SS].[SP_HotelAgentAuthontication]  
 @APIKEY VARCHAR(250),  
 @AgentID INT  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 IF @APIKEY = 'Internal'  
 BEGIN  
  IF EXISTS(SELECT PKID FROM B2BRegistration WITH(NOLOCK) WHERE FKUserID = @AgentID AND Status = 1)  
  BEGIN   
   SELECT 1 AS StatusCode, 'Authorized' as Message, @AgentID AS AgentID   
  END  
  ELSE  
  BEGIN  
   SELECT 0 AS StatusCode, 'Authorization Failed. Agent is unavailable or inactive.' as Message  
  END  
 END  
 ELSE  
 BEGIN  
    
  IF EXISTS(SELECT Id FROM ApiClients WITH(NOLOCK) WHERE SecretKey = @APIKEY AND Status = 1)  
  BEGIN   
   IF EXISTS(SELECT APCM.Id   
    FROM ApiProductClientMapping APCM WITH(NOLOCK)   
     INNER JOIN ApiClients AC WITH(NOLOCK) ON AC.Id = APCM.ClientId   
      AND AC.SecretKey = @APIKEY AND AC.Status = 1  
    WHERE APCM.ProductId = 2)  
   BEGIN   
    SELECT 1 AS StatusCode, 'Authorized' as Message, AC.FKUserID as AgentID   
    FROM ApiProductClientMapping APCM WITH(NOLOCK)   
     INNER JOIN ApiClients AC WITH(NOLOCK) ON AC.Id = APCM.ClientId   
      AND AC.SecretKey = @APIKEY AND AC.Status = 1  
     --INNER JOIN B2BRegistration B2BR WITH(NOLOCK) ON B2BR.PKID = AC.AgentId AND B2BR.Status = 1  
    WHERE APCM.ProductId = 2  
   END  
   ELSE  
   BEGIN  
    SELECT 0 AS StatusCode, 'Authorization Failed. You are unable to authorized for hotels.' as Message  
   END  
  END  
  ELSE  
  BEGIN  
   SELECT 0 AS StatusCode, 'Authorization Failed. APIKEY is wrong.' as Message  
  END  
 END  
  
END  
