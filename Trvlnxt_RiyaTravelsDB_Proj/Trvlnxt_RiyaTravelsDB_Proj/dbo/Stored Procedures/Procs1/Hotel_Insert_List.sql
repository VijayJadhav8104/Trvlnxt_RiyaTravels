CREATE PROCEDURE [dbo].[Hotel_Insert_List]
	@citycode varchar(max),
	@hotelname varchar(50),
	@countrycode int,
	@localid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if not exists(select * from [Hotel_List_Master] where [CityCode]=@citycode and [HotelName]=@hotelname and CountryCode=@countrycode )
	begin
    INSERT INTO [Hotel_List_Master]
         (
           [CityCode]
           ,[HotelName]
           ,[CountryCode])
     VALUES 
          ( 
				@citycode,
				@hotelname,
				@countrycode

          ) 
end
END







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Hotel_Insert_List] TO [rt_read]
    AS [dbo];

