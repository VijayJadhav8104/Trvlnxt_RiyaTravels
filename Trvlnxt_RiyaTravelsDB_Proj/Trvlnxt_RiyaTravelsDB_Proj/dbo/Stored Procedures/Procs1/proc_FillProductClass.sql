


CREATE proc [dbo].[proc_FillProductClass]

@AirLine varchar(50)

as
begin

select

ID,
AirLine,
ProductClass,
ProductClassValue


from mastProductClass

where AirLine= @AirLine


end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[proc_FillProductClass] TO [rt_read]
    AS [dbo];

