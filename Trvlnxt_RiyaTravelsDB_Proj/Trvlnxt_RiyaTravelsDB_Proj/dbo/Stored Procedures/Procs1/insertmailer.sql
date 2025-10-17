
CREATE PROCEDURE [dbo].[insertmailer]
	-- Add the parameters for the stored procedure here
	@type char(1),
	@mainimg varchar(100),
	@murl varchar(200),
	@fimg varchar(100),
	@furl varchar(200),
	@simg varchar(100),
	@surl varchar(200),
	@timg varchar(100),
	@turl varchar(200),
	@sub varchar(200)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if not exists(select PKID_in from Mailer where subject=@sub)
    begin
	insert into Mailer(type_ch,mainimg,murl,fimg,furl,simg,surl,timg,turl,subject) 
	values(@type,@mainimg,@murl,@fimg,@furl,@simg,@surl,@timg,@turl,@sub)
	select 1
	end
	else
	begin
	select 2
	end
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insertmailer] TO [rt_read]
    AS [dbo];

