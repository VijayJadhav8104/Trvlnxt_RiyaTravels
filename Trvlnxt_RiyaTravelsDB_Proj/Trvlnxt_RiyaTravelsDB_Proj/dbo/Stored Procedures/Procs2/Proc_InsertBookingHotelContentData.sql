CREATE Procedure Proc_InsertBookingHotelContentData
@HotelId varchar(50)=null,
@HotelName varchar(500)=null,
@HotelAddress1 varchar(1000)=null,
@ContaintCityName varchar(50)=null,
@ContaintCountryName varchar(50)=null,
@DisplayDiscountRate varchar(500)=null,
@TotalNights int=0,
@TotalRoom  int=0,
@TotalAdultsCount varchar(50)=null,
@TotalChildCount varchar(50)=null,
@SupplierName varchar(100)=null,
@ChainName varchar(100)=null
AS
Begin
Declare @HotelBookingCount int=0;
Declare @totalCount int=0;
Select @HotelBookingCount=COUNT(HotelId) FROM BookingHotelContentData  where HotelId=@HotelId;  
set @totalCount= @HotelBookingCount + 1 ;

	Insert into BookingHotelContentData values(
	@HotelId,
	@HotelName,
	@HotelAddress1,
	@ContaintCityName,
	@ContaintCountryName,
	@DisplayDiscountRate,
	@TotalNights,
	@TotalRoom,
	@TotalAdultsCount,
	@TotalChildCount,
	@SupplierName,@ChainName,GETDATE(),@totalCount)
End