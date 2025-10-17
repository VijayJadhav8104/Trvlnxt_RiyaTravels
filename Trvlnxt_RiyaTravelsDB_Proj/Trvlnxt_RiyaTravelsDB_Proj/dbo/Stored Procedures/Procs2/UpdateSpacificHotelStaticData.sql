-- =============================================
-- Author:		<Altamash Khan>
-- Create date: <Create Date,,>
-- Description:	<Update static hotel data ,,>
-- =============================================
CREATE PROCEDURE UpdateSpacificHotelStaticData
	-- Add the parameters for the stored procedure here
	
	@HotelName varchar(200),
	@CityName varchar(200),
	@Address varchar(1000)='',
	@Description varchar(max)=''

AS
BEGIN
	
	declare @Id int;

	set @Id = (select top 1 ID from Hotel_List_Master where HotelName=@HotelName and name=@CityName )

	
	if(@Id is not null)
	BEGIN
		update Hotel_List_Master 
			set address = CASE 
		                      WHEN address = ''
		                           THEN @Address 
		                      ELSE address
		                 END ,
			short_desc = CASE 
		                      WHEN short_desc = ''
		                           THEN @Description 
		                      ELSE short_desc
		                 END 
		where ID=@Id
		select @Id as Id;
	End

	else
	BEGIN
		select 0 as Id;
	End
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateSpacificHotelStaticData] TO [rt_read]
    AS [dbo];

