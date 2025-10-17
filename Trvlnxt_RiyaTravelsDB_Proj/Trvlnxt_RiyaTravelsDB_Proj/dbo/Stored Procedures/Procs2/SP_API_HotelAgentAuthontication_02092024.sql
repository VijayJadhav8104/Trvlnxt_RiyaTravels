                          
CREATE PROCEDURE [dbo].[SP_API_HotelAgentAuthontication_02092024]                    
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
    WHERE APCM.ProductId = 2               
               
   and ACIP.IP=@ClientIP              
               
 )                                                                  
                        
 IF (@ipCheck>0)                      
 BEGIN                          
                        
  SELECT TOP 1 1 AS StatusCode, 'Authorized' as Message, AC.FKUserID as AgentID,Icast AS Icust                           
    FROM ApiProductClientMapping APCM WITH(NOLOCK)                           
     INNER JOIN ApiClients AC WITH(NOLOCK) ON AC.Id = APCM.ClientId                       
  INNER JOIN ApiClientsIPs ACIP WITH(NOLOCK) ON ACIP.ClientId = APCM.ClientId                        
      AND AC.SecretKey = @APIKEY AND AC.Status = 1 AND ACIP.Status=1                         
     INNER JOIN B2BRegistration B2BR WITH(NOLOCK) ON B2BR.PKID = AC.AgentId AND B2BR.Status = 1                          
    WHERE APCM.ProductId = 2            
         
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
                    
--[SP_API_HotelAgentAuthontication_02092024] 'fcd2592db7660190c9ff635290b6c2654e08bedc24786','122.165.138.155' 