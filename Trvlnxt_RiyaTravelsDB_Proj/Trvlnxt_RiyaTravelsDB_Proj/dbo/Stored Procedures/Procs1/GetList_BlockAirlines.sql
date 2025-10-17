CREATE Proc [dbo].[GetList_BlockAirlines]

as
begin

select * from BlockAirlinelist where btStatus=1


end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_BlockAirlines] TO [rt_read]
    AS [dbo];

