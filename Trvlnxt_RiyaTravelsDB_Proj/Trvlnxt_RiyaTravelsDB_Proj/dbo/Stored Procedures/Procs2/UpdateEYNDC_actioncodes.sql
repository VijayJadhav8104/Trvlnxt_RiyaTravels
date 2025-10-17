CREATE PROCEDURE [dbo].[UpdateEYNDC_actioncodes]
	-- Add the parameters for the stored procedure here
@airlinepnr varchar(100),
@Actioncodes varchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @action varchar(max);
    -- Insert statements for procedure here
	If exists(select 1 from tblBookMaster where GDSPNR=@airlinepnr)
	begin
	--select @action=Actioncodes_EY from tblBookMaster where GDSPNR=@airlinepnr
	--if(@action is not null)
	--begin
	--update tblBookMaster set Actioncodes_EY=@action+','+@Actioncodes
	--end
	--else
	--begin
	--update tblBookMaster set Actioncodes_EY=@Actioncodes
	--end
	insert into tblactionCodes_EY (Code,GDSPnr)
	values(@Actioncodes,@airlinepnr)
	end
END