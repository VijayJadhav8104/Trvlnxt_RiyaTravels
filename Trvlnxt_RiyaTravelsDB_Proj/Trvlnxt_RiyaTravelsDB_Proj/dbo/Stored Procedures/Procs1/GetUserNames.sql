CREATE proc [dbo].[GetUserNames] --[GetUserNames] 'man'                                                                                         ','us'            
@UserName varchar(200)            
            
as            
begin            
select FullName as FullName,UserName as UserName,Id as Id from muser            
where (UserName  LIKE '%'+@UserName +'%' or FullName LIKE '%'+@UserName+'%')  and isActive=1 and SelfBalance=1          
end    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetUserNames] TO [rt_read]
    AS [dbo];

