 --=============================================
 --Author:		<Author,,Name>
 --Create date: <Create Date,,>
 --Description:	<Description,,>
 --=============================================
CREATE PROCEDURE UpdateQuickModify  
	-- Add the parameters for the stored procedure here
	
	@Id int=0,
	@HotelAddress nvarchar(max)='',
	@HotelPhoneNo nvarchar(500)='',
	@ExpirationDate nvarchar(200)='',
	@CancellationPolicy nvarchar(max)='',
	@AdminNote nvarchar(200)=''

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	update Hotel_BookMaster set
		HotelAddress1 = @HotelAddress,
		HotelPhone = @HotelPhoneNo,
		ExpirationDate = @ExpirationDate,
		CancellationPolicy = @CancellationPolicy,
		AdminNote=@AdminNote
		where pkId=@Id


END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateQuickModify] TO [rt_read]
    AS [dbo];

