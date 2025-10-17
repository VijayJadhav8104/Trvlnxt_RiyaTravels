CREATE proc [dbo].[GetListFareRuleLCC]

as
begin
SELECT
FareRule.ID,
AirLine,
CancellationFee,
CancellationRemark,
ReschedullingFee,
ReschedullingRemark,
Sector,
ProductClass,
replace(replace(OtherCondition,'#VAL1',CancellationFee),'#VAL2',ReschedullingFee) as OtherCondition,
FareRule.Status,
convert(varchar(50),AddedDate,106) as AddedDate,
FareRule.UserName,
ad.FullName,UserType,Country



FROM FareRule

left join mUser ad on ad.Id = FareRule.UserName

where FareRule.status=1 and FareRule.AirLine!='GDS'
and UserType='B2C' 
order by FareRule.ID desc


end





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetListFareRuleLCC] TO [rt_read]
    AS [dbo];

