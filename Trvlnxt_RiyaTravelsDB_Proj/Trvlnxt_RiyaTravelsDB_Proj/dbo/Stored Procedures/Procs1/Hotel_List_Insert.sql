CREATE PROCEDURE [dbo].[Hotel_List_Insert]
	@citycode varchar(max)=NULL,
	@hotelname varchar(50),
	@countrycode int=NULL,
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if not exists(select * from [Hotel_List_Master] where [CityCode]=@citycode and [CountryCode]=@countrycode and [HotelName]=@hotelname  and [ID]=@id)
	begin
    INSERT INTO [Hotel_List_Master]
         (
           [CityCode],
            [HotelName]
           ,[CountryCode]
		   ,[ID])
     VALUES 
          ( 
				@citycode,
				@hotelname,
				@countrycode,
				@id

          ) 
end
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Hotel_List_Insert] TO [rt_read]
    AS [dbo];

