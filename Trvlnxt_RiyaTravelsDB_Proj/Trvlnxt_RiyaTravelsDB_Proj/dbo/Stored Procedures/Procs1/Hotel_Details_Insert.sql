CREATE PROCEDURE [dbo].[Hotel_Details_Insert]
    @ID int=NULL,
	@HotelName varchar(255),
    @rating varchar(50),
    @latitude varchar(50),
    @longitude varchar(50),         
    @phone varchar(50),
    @address varchar(250),
    @Fax varchar(50),
    @short_desc varchar(max),
    @website varchar(50),
    @EmailID varchar(50),
    @main_image varchar(255),
	@Optional_Image varchar(255),
    @long_desc varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if exists(select * from [Hotel_List_Master] where ID=@ID)
	-- [HotelName]=@hotelname and [rating]=@rating and [latitude]=@latitude and [longitude]=@longitude 
	--and [phone]=@phone and [address]=@address and Fax=[Fax] and [short_desc]=@short_desc and [website]=@website and [EmailID]=@EmailID and [main_image]=@main_image 
	--and [Optional_Image]=@Optional_Image and [long_desc]=@long_desc)

	begin    
	Update Hotel_List_Master set [HotelName]=@HotelName,[rating]=@rating,[latitude]=@latitude,[longitude]=@longitude,[phone]=@phone,
		[address]=@address,[Fax]=@Fax,[short_desc]=@short_desc,[website]=@website,[EmailID]=@EmailID,[main_image]=@main_image,
		[Optional_Image]=@Optional_Image,[long_desc]= @long_desc where ID=@ID
			  	select 1 
    end
	 
 
end







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Hotel_Details_Insert] TO [rt_read]
    AS [dbo];

