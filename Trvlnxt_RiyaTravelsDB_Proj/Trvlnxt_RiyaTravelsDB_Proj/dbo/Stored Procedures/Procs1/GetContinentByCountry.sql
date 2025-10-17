-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetContinentByCountry]
	-- Add the parameters for the stored procedure here
	@CountryName nvarchar(500)=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select cc.Id
		  ,cc.Continent_Id
		  ,co.ContinentName
		  ,CountryName 
		  
	from Conti_Country cc 
	join Continent co on co.Id=cc.Continent_Id
	where CountryName=@CountryName
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetContinentByCountry] TO [rt_read]
    AS [dbo];

