CREATE proc Get_ErpReport_Error
@Id int=null,
@Flag Varchar(30)=null

as 
if(@flag='ErrorResponse')
begin
  select top 1 Response from NewERPData_Log where id=@Id order by createdon desc 
end

 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_ErpReport_Error] TO [rt_read]
    AS [dbo];

