Create Procedure Proc_RequestForCancelled
@BookingReference varchar(100)=null,
@Pkid int=0
As
Begin
	Update Hotel_BookMaster Set RequestForCancelled='Yes' Where BookingReference=@BookingReference or pkId=@Pkid
End