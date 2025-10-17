
CREATE PROCEDURE [dbo].[insertaccount] --'HOSHIYAR','S','ashvini.gawde@gmail.com',null,'44','inh','122112122'
	-- Add the parameters for the stored procedure here
	--@fname varchar(100),
	--@lname varchar(100)=null,
	@email varchar(150)= null,
	--@phone varchar(15)= null,
	--@code varchar(50)=null,
		--@country varchar(50)=null,
	@pass varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @count int
	--set @count=0;
	
	Select @count= count(*) from [Account_login] WHERE [Email]=@email
	
	BEGIN
	 IF (@count=0)
		BEGIN
		-- Insert statements for procedure here
			INSERT INTO [dbo].[Account_login]
				   (
				   [Email]
				   
				   ,[passwords])VALUES(@email,@pass)
			Select 1
		end
	else
		begin
				update [dbo].[Account_login]
				set  passwords=@pass
				WHERE [Email] =@email
				select 2
		end
END
end







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insertaccount] TO [rt_read]
    AS [dbo];

