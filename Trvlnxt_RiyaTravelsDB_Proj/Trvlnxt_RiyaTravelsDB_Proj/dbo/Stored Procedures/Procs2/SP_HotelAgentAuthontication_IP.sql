CREATE PROCEDURE [dbo].[SP_HotelAgentAuthontication_IP]     
 @APIKEY VARCHAR(250),      
 @AgentID INT,
 @ClientIP varchar(100) 
AS      
BEGIN      
 SET NOCOUNT ON;      
      
  Declare @Icast varchar(100)    
  Declare @BookingCountry varchar(100)  
  
 IF @APIKEY = 'Internal'      
 BEGIN      
  IF EXISTS(SELECT PKID FROM B2BRegistration WITH(NOLOCK) WHERE FKUserID = @AgentID AND Status = 1)      
  BEGIN    
    declare @ipCheck int=0 

	  set @ipCheck=(SELECT TOP 1 APCM.Id                                     
                    FROM ApiProductClientMapping APCM WITH(NOLOCK)                                     
				    INNER JOIN ApiClients AC WITH(NOLOCK) ON AC.Id = APCM.ClientId                                    
					INNER JOIN ApiClientsIPs ACIP WITH(NOLOCK) ON ACIP.ClientId = APCM.ClientId                                   
				    AND AC.SecretKey = @APIKEY AND AC.Status = 1 AND  ACIP.Status=1 WHERE APCM.ProductId = 2  and ACIP.IP=@ClientIP) 
					
	 IF (@ipCheck>0)                                
		BEGIN  
			SELECT @Icast= Icast FROM B2BRegistration WITH(NOLOCK) WHERE FKUserID = @AgentID AND Status = 1    
			SELECT @BookingCountry= BookingCountry FROM AgentLogin WITH(NOLOCK) WHERE UserID = @AgentID --AND IsActive = 1      
			SELECT 1 AS StatusCode, 'Authorized' as Message, @AgentID AS AgentID , @Icast as Icust,@BookingCountry as BookingCountry   

			insert into Hotel_API_AuthFail(secretkey,ipaddress,correlationid)                        
			values(@APIKEY,@ClientIP,'Success') 
		END 
	ELSE
		BEGIN
			SELECT 0 AS StatusCode, 'Authorization Failed. Invalid IP Address.' as Message 
			insert into Hotel_API_AuthFail(secretkey,ipaddress,correlationid)                        
			values(@APIKEY,@ClientIP,'Failed')
		END
  END      
  ELSE      
  BEGIN      
   SELECT 0 AS StatusCode, 'Authorization Failed. Agent is unavailable or inactive.' as Message      
  END      
 END      
 --ELSE      
 --BEGIN      
        
 -- IF EXISTS(SELECT Id FROM ApiClients WITH(NOLOCK) WHERE SecretKey = @APIKEY AND Status = 1)      
 -- BEGIN       
 --  IF EXISTS(SELECT APCM.Id       
 --   FROM ApiProductClientMapping APCM WITH(NOLOCK)       
 --    INNER JOIN ApiClients AC WITH(NOLOCK) ON AC.Id = APCM.ClientId       
 --     AND AC.SecretKey = @APIKEY AND AC.Status = 1      
 --   WHERE APCM.ProductId = 2)      
 --  BEGIN       
    
 --   --SELECT 1 AS StatusCode, 'Authorized' as Message, AC.FKUserID as AgentID   , '' as Icust    
 --   --FROM ApiProductClientMapping APCM WITH(NOLOCK)       
 --   -- INNER JOIN ApiClients AC WITH(NOLOCK) ON AC.Id = APCM.ClientId       
 --   --  AND AC.SecretKey = @APIKEY AND AC.Status = 1      
 --   -- --INNER JOIN B2BRegistration B2BR WITH(NOLOCK) ON B2BR.PKID = AC.AgentId AND B2BR.Status = 1      
 --   --WHERE APCM.ProductId = 2    
   
  
 -- SELECT TOP 1 1 AS StatusCode, 'Authorized' as Message, AC.FKUserID as AgentID,Icast AS Icust,B2BR.country,al.BookingCountry as BookingCountry--added on 21 July 2025 to get agent country code  
 --    FROM ApiProductClientMapping APCM WITH(NOLOCK)  
 --    INNER JOIN ApiClients AC WITH(NOLOCK) ON AC.Id = APCM.ClientId  
 --    INNER JOIN ApiClientsIPs ACIP WITH(NOLOCK) ON ACIP.ClientId = APCM.ClientId  
 --    AND AC.SecretKey = @APIKEY AND AC.Status = 1 AND ACIP.Status=1  
 --    INNER JOIN B2BRegistration B2BR WITH(NOLOCK) ON B2BR.PKID = AC.AgentId AND B2BR.Status = 1  
 --    INNER JOIN agentlogin al WITH(NOLOCK) ON B2BR.fkuserid=al.userid AND al.IsActive=1--added on 21 July 2025 to get agent country code  
 --    WHERE APCM.ProductId = 2  
    
 --  END      
 --  ELSE      
 --  BEGIN      
 --   SELECT 0 AS StatusCode, 'Authorization Failed. You are unable to authorized for hotels.' as Message      
 --  END      
 -- END      
 -- ELSE      
 -- BEGIN      
 --  SELECT 0 AS StatusCode, 'Authorization Failed. APIKEY is wrong.' as Message      
 -- END      
 --END      
      
END   
--[SP_HotelAgentAuthontication_IP] 'Internal',21958,'::1'   