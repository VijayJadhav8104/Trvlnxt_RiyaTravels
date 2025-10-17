Create Procedure Proc_GetHotelHoldBookingOffsetData
As
Begin
Select HB.BookingReference,HB.inserteddate,HB.HotelOffsetGMT,HB.B2BPaymentMode,HSH.FkStatusId,HB.Lat,HB.Lang, * from 
Hotel_BookMaster HB
left join 
Hotel_Status_History HSH
On HSH.FKHotelBookingId=HB.pkId and HSH.IsActive=1 
Where 
HSH.FkStatusId=3
and HB.HotelOffsetGMT is null
End



