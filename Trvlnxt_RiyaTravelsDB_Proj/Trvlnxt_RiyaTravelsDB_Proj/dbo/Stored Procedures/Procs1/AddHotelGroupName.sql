-- sp_HelpText AddHotelGroupName            
            
CREATE PROC AddHotelGroupName            
@Name VARCHAR(200),            
@Product VARCHAR(20),            
--@AgentId INT=null,            
@FkUserId INT=null,          
@CreatedBy INT           
AS            
BEGIN            
   declare @AgentId int;        
        
   set @AgentId=(select top 1 PKID from B2BRegistration where FKUserID=@FkUserId)        
           
        
   IF(@AgentId  IS NOT NULL)        
   begin        
           --inserting agentid as fkuserid, fkuserid is agent  for now     
    INSERT INTO HotelApiClients(Name,AgentId,Status,CreatedBy,CreatedDate,Product,FKUserID)            
    VALUES(@Name,@AgentId,1,@CreatedBy,GETDATE(),@Product,@FkUserId);            
    SELECT SCOPE_IDENTITY();         
        
   end        
        
          
            
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[AddHotelGroupName] TO [rt_read]
    AS [dbo];

