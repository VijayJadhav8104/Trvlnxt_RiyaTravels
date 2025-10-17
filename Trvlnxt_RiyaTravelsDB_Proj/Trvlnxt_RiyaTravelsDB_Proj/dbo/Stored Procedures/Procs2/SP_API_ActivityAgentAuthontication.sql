  
-- [SP_API_ActivityAgentAuthontication]  '234tgfvdertytgfvcdergfdertgvfedcvbgfrdesergfderthgfertgvfdytredwsa',                                
CREATE PROCEDURE [dbo].[SP_API_ActivityAgentAuthontication]                          
 @APIKEY VARCHAR(250),                                
 --@AgentID INT=0,                              
 @ClientIP varchar(100)                              
AS                                
BEGIN                                
 SET NOCOUNT ON;                                
                              
                              
                               
 declare @ipCheck int=0                              
                              
 set @ipCheck=(SELECT TOP 1 APCM.Id                                 
    FROM ApiProductClientMapping APCM WITH(NOLOCK)                                 
     INNER JOIN ApiClients AC WITH(NOLOCK) ON AC.Id = APCM.ClientId                                
 INNER JOIN ApiClientsIPs ACIP WITH(NOLOCK) ON ACIP.ClientId = APCM.ClientId                               
      AND AC.SecretKey = @APIKEY                     
                       
                       
   AND AC.Status = 1 AND                     
                       
                       
   ACIP.Status=1                       
                       
                    
   --AND AC.FKUserID=@AgentID                              
    WHERE APCM.ProductId = 7                     
                     
   and ACIP.IP=@ClientIP                    
                     
 )                              
                              
--DECLARE @IpExists BIT=0                
--IF EXISTS(SELECT @ClientIP WHERE @ClientIP LIKE '10.212.134.2%' OR @APIKEY='fcd2592db7660190c9ff635290b6c2654e08bedc98765')--AND @APIKEY='fcd2592db7660190c9ff635290b6c2654e08bedc11324'                
--BEGIN                
--SET @IpExists=1                
--END                           
                              
 IF (@ipCheck>0 /*OR @IpExists=1*/)                            
 BEGIN                                
                              
  SELECT TOP 1 1 AS StatusCode, 'Authorized' as Message, AC.FKUserID as AgentID,Icast AS Icust,B2BR.country                                 
    FROM ApiProductClientMapping APCM WITH(NOLOCK)                                 
     INNER JOIN ApiClients AC WITH(NOLOCK) ON AC.Id = APCM.ClientId                             
  INNER JOIN ApiClientsIPs ACIP WITH(NOLOCK) ON ACIP.ClientId = APCM.ClientId                              
      AND AC.SecretKey = @APIKEY AND AC.Status = 1 AND ACIP.Status=1                               
     INNER JOIN B2BRegistration B2BR WITH(NOLOCK) ON B2BR.PKID = AC.AgentId AND B2BR.Status = 1                                
    WHERE APCM.ProductId = 7                  
               
 insert into Hotel_API_AuthFail(secretkey,ipaddress,correlationid)                    
   values(@APIKEY,@ClientIP,'Success')               
                                 
 END                                
  ELSE                               
                              
  BEGIN                              
                               
   SELECT 0 AS StatusCode, 'Authorization Failed. Invalid APIKEY or IP Address.' as Message                         
                       
   insert into Hotel_API_AuthFail(secretkey,ipaddress,correlationid)                    
   values(@APIKEY,@ClientIP,'Failed')                    
                              
  END                              
END                           
                          
--[SP_API_HotelAgentAuthontication] 'fcd2592db7660190c9ff635290b6c2654e08bedc24786','122.165.138.155' 