CREATE procedure SP_DeleteSearchAPITime  
@Id int=null  
as  
begin  


delete from SearchTimeAPI where id=0;  

end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_DeleteSearchAPITime] TO [rt_read]
    AS [dbo];

