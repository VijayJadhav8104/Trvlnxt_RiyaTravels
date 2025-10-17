
CREATE proc [dbo].[GetAirlines]

as
Begin
SELECT AirlineName,AirlineCode + ',' + AirlineCode1  as AirlineCode FROM TblSTSAirLineMaster WHERE Status=1
and AirlineCode not in ('6E','SG','G8')
End


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAirlines] TO [rt_read]
    AS [dbo];

