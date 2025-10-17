create proc [Hotel].[GetSupplierRate]

@Pkid int=0 
As
Begin  
select 
  distinct RR.ID 
 ,HRM.RoomTypeDescription
 ,RR.Amount,taxIncluded
 ,RR.room_no 
 ,HotelTaxes
 ,HB.DisplayDiscountRate
 ,RR.Date as 'PerNightDate' 
 ,DATENAME(WEEKDAY,Date) as 'Date'  
 from  hotel.Hotel_SupplierRoomRatesPerNight RR   
 left join  Hotel_Room_master HRM on RR.RoomId = HRM.room_class_id
 left join Hotel_BookMaster HB on RR.FkBookingId = HB.pkId
 where FkBookingId=@Pkid  
 order by date  
End  