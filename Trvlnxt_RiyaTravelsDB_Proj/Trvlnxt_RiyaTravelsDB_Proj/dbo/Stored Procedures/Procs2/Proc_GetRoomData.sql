CREATE Procedure Proc_GetRoomData  
@BookingPki_Id int=0 ,
@RoomConter int=0
As  
Begin  
  Select Room_Id from Hotel_Room_master Where book_fk_id=@BookingPki_Id  and room_no=@RoomConter
End 