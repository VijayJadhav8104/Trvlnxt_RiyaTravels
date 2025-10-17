CREATE proc [dbo].[SearchUserName] --[SearchUserName] 'man'                                                                                         ','us'            
@UserName varchar(200)            
            
as            
begin            
select FullName as FullName,UserName as UserName,Id as Id from muser            
where (UserName  LIKE '%'+@UserName +'%' or FullName LIKE '%'+@UserName+'%')  and isActive=1     
end    

