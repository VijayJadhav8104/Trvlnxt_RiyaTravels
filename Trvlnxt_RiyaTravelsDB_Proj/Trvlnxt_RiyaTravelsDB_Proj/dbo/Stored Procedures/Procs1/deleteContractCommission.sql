CREATE procedure deleteContractCommission

@ID int

as
begin

update tblContractCommission 
set status=0 where pkid=@id

end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[deleteContractCommission] TO [rt_read]
    AS [dbo];

