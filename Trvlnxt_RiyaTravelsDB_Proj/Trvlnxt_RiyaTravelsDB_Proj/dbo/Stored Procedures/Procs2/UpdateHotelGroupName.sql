CREATE PROC UpdateHotelGroupName        
@Name VARCHAR(200),        
--@AgentId INT=null,       
@FkUserId INT=null,         
@Id INT,      
@Product VARCHAR(20)      
AS        
BEGIN       
declare @AgentId int;      
      
   set @AgentId=(select top 1 PKID from B2BRegistration where FKUserID=@FkUserId)      
     IF(@AgentId  IS NOT NULL)      
   begin      
     UPDATE HotelApiClients SET [Name]=@Name,AgentId=@AgentId,FKUserID=@FkUserId, Product=@Product WHERE Id=@Id;        
         
   end    
    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateHotelGroupName] TO [rt_read]
    AS [dbo];

