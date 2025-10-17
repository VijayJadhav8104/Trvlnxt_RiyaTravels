Create procedure Proc_InsertHoldBookingOffset
@Bookingref varchar(200)='',
@Pkid int=0,
@Offset varchar(500)='0'
As
Begin
  Update Hotel_BookMaster set HotelOffsetGMT=@Offset where BookingReference=@Bookingref and pkId=@Pkid
End