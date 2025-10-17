

CREATE proc [dbo].[SP_InsertAgentDiscount_DrecFlat]

@ID int,
@dtflat Type_AgentDiscountFlat Readonly



as
begin

insert into FlightFlat_Drec
(
FKID,
Min,
Max,
Discount
)
select
@ID,
Min,
Max,
Discount
from  @dtflat
end




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_InsertAgentDiscount_DrecFlat] TO [rt_read]
    AS [dbo];

