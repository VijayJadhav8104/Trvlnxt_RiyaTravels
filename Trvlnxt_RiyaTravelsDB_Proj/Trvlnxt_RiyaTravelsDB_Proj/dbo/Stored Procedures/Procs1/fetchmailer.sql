

CREATE PROCEDURE [dbo].[fetchmailer]
	-- Add the parameters for the stored procedure here
	@sub varchar(200),
	@type char(1)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT fimg,simg,timg,mainimg,murl,furl,surl,turl from Mailer where subject=@sub and type_ch=@type
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchmailer] TO [rt_read]
    AS [dbo];

