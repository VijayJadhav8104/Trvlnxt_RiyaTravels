      
      
CREATE proc [Hotel].GetNightlyRate      
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
 from  [hotel].Hotel_RoomRatesPerNight RR  WITH (NOLOCK)      
 left join  Hotel_Room_master HRM  WITH (NOLOCK) on RR.RoomId = HRM.room_class_id    
 left join Hotel_BookMaster HB  WITH (NOLOCK) on RR.FkBookingId = HB.pkId    
 where FkBookingId=@Pkid      
 order by date      
End 