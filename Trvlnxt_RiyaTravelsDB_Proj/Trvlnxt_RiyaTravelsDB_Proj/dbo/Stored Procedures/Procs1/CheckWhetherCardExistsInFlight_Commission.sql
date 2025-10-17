CREATE PROC [dbo].[CheckWhetherCardExistsInFlight_Commission]
@Pkid INT
AS
BEGIN
	 SELECT COUNT(Id) FROM  Flight_Commission WHERE CardMapping1=@Pkid OR 
	 CardMapping2=@Pkid OR CardMapping3=@Pkid OR CardMapping4=@Pkid OR CardMapping5=@Pkid;
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CheckWhetherCardExistsInFlight_Commission] TO [rt_read]
    AS [dbo];

