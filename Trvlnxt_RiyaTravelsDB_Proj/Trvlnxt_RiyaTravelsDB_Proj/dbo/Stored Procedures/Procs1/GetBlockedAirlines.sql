 CREATE procedure [dbo].[GetBlockedAirlines]

  @WebService nvarchar (50)

as
begin
 select * from BlockedAirlines where Status=1 and WebService=@WebService
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetBlockedAirlines] TO [rt_read]
    AS [dbo];

