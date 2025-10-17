-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procEDURE [dbo].[Sp_InsertConti_Country] 
	-- Add the parameters for the stored procedure here
	@Continent_Id int,
	@CountryName varchar(50),
	@Adjective nvarchar(max),
	@Rate float,
	--@Image nvarchar(max),
	--@Banner_Image nvarchar(max),
	--@Incredible nvarchar(max),
	--@UrlStructure nvarchar(max),
	@Url nvarchar(max),
	@MetaTitle nvarchar(max),
	@MetaDescription nvarchar(max),
	@Keywords nvarchar(max),
	--@Date datetime,
	@IsActive bit,
	@GoogleAnalytics nvarchar(max),
	@Action nvarchar(50),
	@ID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if(@Action='insert')
	begin
	Insert Into Conti_Country 
	(
	 Continent_Id,
	 CountryName,
	 Adjective,
	 Rate, 
	 Url,
	 MetaTitle,
	 MetaDescription,
	 Keywords,
	 IsActive,
	 GoogleAnalytics
	)
	Values (@Continent_Id,@CountryName,@Adjective,@Rate,
	@Url,@MetaTitle,@MetaDescription,@Keywords,@IsActive,@GoogleAnalytics)
	end

	else if(@Action='getGridData')
	begin
	select ID,CountryName from Conti_Country where IsActive=0
	end

	
	else if(@Action='update')
	begin
	update Conti_Country set Continent_Id=@Continent_Id,
	       CountryName=@CountryName,
		   Adjective=@Adjective,
		   Rate=@Rate,
		   Url=@Url,
		   MetaTitle=@MetaTitle,
		   MetaDescription=@MetaDescription,
		   Keywords=@Keywords,
		   GoogleAnalytics=@GoogleAnalytics
		   where Id=@ID
	end

	if(@Action='delete')
	begin
	update Conti_Country set IsActive='1' where Id=@ID 
	end
	
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_InsertConti_Country] TO [rt_read]
    AS [dbo];

