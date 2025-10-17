            
CREATE PROCEDURE [dbo].[SP_API_HotelAgentAuthontication_bkp]       
 @APIKEY VARCHAR(250),            
 --@AgentID INT=0,          
 @ClientIP varchar(100)          
AS            
BEGIN            
 SET NOCOUNT ON;            
          
          
           
 declare @ipCheck int=0          
          
 set @ipCheck=(SELECT APCM.Id             
    FROM ApiProductClientMapping APCM WITH(NOLOCK)             
     INNER JOIN ApiClients AC WITH(NOLOCK) ON AC.Id = APCM.ClientId            
  INNER JOIN ApiClientsIPs ACIP WITH(NOLOCK) ON ACIP.ClientId = APCM.ClientId           
      AND AC.SecretKey = @APIKEY AND AC.Status = 1 AND ACIP.Status=1     
   --AND AC.FKUserID=@AgentID          
    WHERE APCM.ProductId = 2 
	
   and ACIP.IP=@ClientIP
	
	)          
          
          
          
 IF @ipCheck>0          
 BEGIN            
          
  SELECT TOP 1 1 AS StatusCode, 'Authorized' as Message, AC.FKUserID as AgentID             
    FROM ApiProductClientMapping APCM WITH(NOLOCK)             
     INNER JOIN ApiClients AC WITH(NOLOCK) ON AC.Id = APCM.ClientId         
  INNER JOIN ApiClientsIPs ACIP WITH(NOLOCK) ON ACIP.ClientId = APCM.ClientId          
      AND AC.SecretKey = @APIKEY AND AC.Status = 1 AND ACIP.Status=1           
     INNER JOIN B2BRegistration B2BR WITH(NOLOCK) ON B2BR.PKID = AC.AgentId AND B2BR.Status = 1            
    WHERE APCM.ProductId = 2            
             
 END            
  ELSE           
          
  BEGIN          
           
   SELECT 0 AS StatusCode, 'Authorization Failed. Invalid APIKEY or IP Address.' as Message            
          
  END          
END       
      
--[SP_API_HotelAgentAuthontication] '5c9f70f322383608e6959f99c5a345dd82db965cc41d29e05d53fcd2592db7660190c9ff635290b6c2654e08bedcf5a95732',20726,'106.193.156.208' 