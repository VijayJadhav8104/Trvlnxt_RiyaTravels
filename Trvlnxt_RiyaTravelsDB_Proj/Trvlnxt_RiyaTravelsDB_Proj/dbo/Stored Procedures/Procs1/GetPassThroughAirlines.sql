
CREATE Procedure [dbo].[GetPassThroughAirlines]
@AirlinrCode NVARCHAR(255),
@Country NVARCHAR(2)=NULL
as
begin
	SELECT COUNT(Id) FROM PassThroughMaster WHERE Airlinename=@AirlinrCode 
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPassThroughAirlines] TO [rt_read]
    AS [dbo];

