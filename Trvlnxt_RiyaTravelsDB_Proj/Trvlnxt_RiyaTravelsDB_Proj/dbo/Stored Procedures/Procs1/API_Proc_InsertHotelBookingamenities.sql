Create procedure API_Proc_InsertHotelBookingamenities  
@BookingFkid int=0,  
@Facilityid varchar(100)='0',  
@FacilityCode varchar(100)='0',  
@FacilityName varchar(100)=' ',  
@FacilityIcon varchar(100)=' '  
As  
Begin  
 Insert into HotelBookingAmenities(BookingFkid,Facilitiesid,FacilitieCode,FacilitieName,FaciliyieIcon)  
 values(@BookingFkid,@Facilityid,@FacilityCode,@FacilityName,@FacilityIcon)  
END