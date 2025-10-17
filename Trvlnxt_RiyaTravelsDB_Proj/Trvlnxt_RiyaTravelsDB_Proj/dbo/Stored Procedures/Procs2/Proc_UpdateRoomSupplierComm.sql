CREATE Procedure Proc_UpdateRoomSupplierComm  
@Booking_Id int=0,  
@Roomid int=0,  
@SupplierbaseRate float=0,
@SupplierpublishedBaseRate float=0,
@SuppliertotalRate float=0,
@SupplierpublishedRate float=0,
@SupplierSupplierCommission float=0,
@SupplierStaxes float=0
As  
Begin  
  Update Hotel_Room_master Set baseRate=@SupplierbaseRate,publishedBaseRate=@SupplierpublishedBaseRate,
  totalRate=@SuppliertotalRate,
  publishedRate=@SupplierpublishedRate,
  SupplierCommission=@SupplierSupplierCommission,
  Staxes=@SupplierStaxes
  where Room_Id=@Roomid and book_fk_id=@Booking_Id  
End