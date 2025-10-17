

-- =============================================
-- Author:		<Altamash,,Khan>
-- Create date: <31/05/2018>
-- Description:	<Insert Tags For Travels Dairies,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertTags] 
	-- Add the parameters for the stored procedure here
	
	@TagName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if not exists( select TagName from TagsMaster where TagName=@TagName) 
	begin
	 insert into TagsMaster(TagName,InsertDate)
		values(@TagName,(CONVERT(CHAR(15), GETDATE(), 106)))
		select 1;
	end
	else
	begin
		select 0;
	end

END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertTags] TO [rt_read]
    AS [dbo];

