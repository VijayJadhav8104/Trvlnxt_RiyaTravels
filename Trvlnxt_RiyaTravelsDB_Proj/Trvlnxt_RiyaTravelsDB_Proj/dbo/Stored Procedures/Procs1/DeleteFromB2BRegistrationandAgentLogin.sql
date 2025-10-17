  
CREATE procedure [dbo].[DeleteFromB2BRegistrationandAgentLogin]  
@Pkid int,  
@UserId bigint  
  
as  
begin  
  
  
delete from B2BRegistration where PKID= @Pkid  
  
delete from AgentLogin where UserID= @UserId  

select 1
  
end  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[DeleteFromB2BRegistrationandAgentLogin] TO [rt_read]
    AS [dbo];

