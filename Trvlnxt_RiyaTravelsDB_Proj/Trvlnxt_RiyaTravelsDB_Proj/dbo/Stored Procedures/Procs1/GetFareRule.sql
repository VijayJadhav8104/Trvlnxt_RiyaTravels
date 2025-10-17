
CREATE PROCEDURE [dbo].[GetFareRule]
@Sector Varchar(10) 
AS BEGIN

SELECT OtherCondition FROM FareRule WHERE AirLine='GDS' and Sector=@Sector


--select OtherConditions from FareRule WHERE Carrier='GDS' and Sector=@Sector
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetFareRule] TO [rt_read]
    AS [dbo];

