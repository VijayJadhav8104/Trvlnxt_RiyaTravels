
CREATE PROCEDURE [dbo].[checkmailer] --'test usa'
	-- Add the parameters for the stored procedure here
	@sub varchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if  exists(select type_ch from Mailer where subject=@sub)
	begin
	select type_ch from Mailer where subject=@sub
	end
	else
	begin
	select 2 
	end

	end




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[checkmailer] TO [rt_read]
    AS [dbo];

