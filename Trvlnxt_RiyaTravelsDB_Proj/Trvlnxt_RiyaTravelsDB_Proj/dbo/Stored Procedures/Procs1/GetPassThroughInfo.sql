
  CREATE PROCEDURE [dbo].[GetPassThroughInfo]
  @Airline			varchar(10)
  AS BEGIN

	  SELECT [AirlineName], [Percentage]
	  FROM [dbo].[PassThroughMaster]
	  WHERE AirlineName = @Airline
  END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPassThroughInfo] TO [rt_read]
    AS [dbo];

