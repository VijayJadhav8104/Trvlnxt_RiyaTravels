Create procedure Proc_InsertHotelBookingamenities
@BookingFkid int=0,
@Facilitiesid varchar(100)='0',
@FacilitieCode varchar(100)='0',
@FacilitieName varchar(100)=' ',
@FaciliyieIcon varchar(100)=' '
As
Begin
	Insert into HotelBookingAmenities(BookingFkid,Facilitiesid,FacilitieCode,FacilitieName,FaciliyieIcon)
	values(@BookingFkid,@Facilitiesid,@FacilitieCode,@FacilitieName,@FaciliyieIcon)
END