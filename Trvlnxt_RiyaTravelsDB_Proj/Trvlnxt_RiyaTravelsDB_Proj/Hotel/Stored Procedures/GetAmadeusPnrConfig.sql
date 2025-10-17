CREATE PROCEDURE Hotel.GetAmadeusPnrConfig         
AS        
BEGIN        
 SELECT Pkid,AgentId,QueueNo,OfficeId,IsActive,CreatedDate FROM Hotel.AmadeusPnrConfig WHERE IsActive=1 --and Pkid=2 ORDER BY pkid DESC      
END 