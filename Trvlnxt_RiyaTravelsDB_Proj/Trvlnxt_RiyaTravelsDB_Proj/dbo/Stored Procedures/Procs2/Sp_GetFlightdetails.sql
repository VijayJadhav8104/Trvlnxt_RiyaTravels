create Procedure [dbo].[Sp_GetFlightdetails]
@OrderNo nvarchar(50)
as
begin
select
t.airCode,
t.airName,
t.flightNo,
t.operatingCarrier,
t.fromAirport,
t.deptTime,
t.depDate,
t.fromTerminal,

t.toAirport,
t.arrivalTime,
t.arrivalDate,
t.toTerminal,
t.farebasis,

CONVERT(varchar(5), DATEADD(minute, DATEDIFF(MINUTE, t.deptTime,t.arrivalTime), 0), 114) as Traveldifference,
t.cabin

from tblBookItenary t
--left join tblBookItenary tbi on tbi.orderid=t.orderid
where t.orderid=@OrderNo


end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetFlightdetails] TO [rt_read]
    AS [dbo];

