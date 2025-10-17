


create proc [dbo].[Flight_DrecFlatDelete]

@ID int

as
begin

delete from FlightFlat_Drec where FKID = @ID



end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Flight_DrecFlatDelete] TO [rt_read]
    AS [dbo];

