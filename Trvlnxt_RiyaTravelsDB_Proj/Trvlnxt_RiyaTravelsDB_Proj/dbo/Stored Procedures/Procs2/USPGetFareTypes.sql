 CREATE procedure USPGetFareTypes

as
begin
 select * from tblFareTypeFilter where IsActive=1 and ProductClass is not null
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USPGetFareTypes] TO [rt_read]
    AS [dbo];

