CREATE PROCEDURE [dbo].[GetCountryUnderContinent]
	-- Add the parameters for the stored procedure here
	@Id nvarchar(500),
	@TypeName nvarchar(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if(@TypeName = 'Continent')
	select * from Conti_Country where Continent_Id=@Id and IsActive=0

	else if(@TypeName = 'Country')
	select * from TblCity tc
	inner join Conti_Country cc on tc.CountryName=cc.CountryName
	where cc.Id=@Id and cc.IsActive=0

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetCountryUnderContinent] TO [rt_read]
    AS [dbo];

