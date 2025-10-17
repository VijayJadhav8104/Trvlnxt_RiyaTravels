
--exec [dbo].[Get_CitiesList] 
CREATE procedure [dbo].[Get_CitiesList]
	@Country varchar(100)
AS
BEGIN

	DECLARE @temp VARCHAR(MAX)
	SELECT @temp = COALESCE(@temp+', ' ,'') + Code 
	FROM [dbo].[mastCountry]
	where Country = @Country
	SELECT @temp as City 
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_CitiesList] TO [rt_read]
    AS [dbo];

