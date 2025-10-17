
-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: <01/06/2018>
-- Description:	<Insert Country Name from Country Master page,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertCountry] 
	-- Add the parameters for the stored procedure here
	@CountryName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if not exists( select CountryName from CountryMaster where CountryName=@CountryName) 
	begin
	 insert into CountryMaster(CountryName,InsertDate)
		values(@CountryName,(CONVERT(CHAR(15), GETDATE(), 106)))
		select 1;
	end
	else
	begin
		select 0;
	end

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertCountry] TO [rt_read]
    AS [dbo];

