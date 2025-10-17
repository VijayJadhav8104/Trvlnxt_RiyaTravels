



CREATE proc [dbo].[GetRecord_DrecFlat]
@ID int

as
begin

select
FKID,
Min,
Max,
Discount
from 
FlightFlat_Drec

where FKID = @ID

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecord_DrecFlat] TO [rt_read]
    AS [dbo];

