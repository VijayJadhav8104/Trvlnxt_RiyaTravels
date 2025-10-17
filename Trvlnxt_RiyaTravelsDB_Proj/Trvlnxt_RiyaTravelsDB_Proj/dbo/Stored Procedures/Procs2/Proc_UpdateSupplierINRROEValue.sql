Create procedure Proc_UpdateSupplierINRROEValue
@BookingPkid int=0,
@BookingReference varchar(100)=null,
@SupplierINRROEValue float=0
As
Begin
	Update Hotel_BookMaster Set SupplierINRROEValue=@SupplierINRROEValue Where pkId=@BookingPkid or BookingReference=@BookingReference
End