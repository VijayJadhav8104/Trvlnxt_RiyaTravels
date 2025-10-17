

CREATE PROCEDURE [dbo].[sp_TestingPurpose]	-- [dbo].[sp_TestingPurpose] 'BOM,DXB'
	@AirportList varchar(1000) 
AS
BEGIN
	SELECT Distinct *
	FROM [dbo].[111] 
	WHERE Code in (SELECT Element FROM [dbo].func_Split(@AirportList, ','))
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_TestingPurpose] TO [rt_read]
    AS [dbo];

