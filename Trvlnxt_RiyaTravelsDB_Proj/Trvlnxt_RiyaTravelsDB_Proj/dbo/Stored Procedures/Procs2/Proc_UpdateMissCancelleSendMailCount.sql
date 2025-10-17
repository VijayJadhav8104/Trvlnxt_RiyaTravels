CREATE Procedure Proc_UpdateMissCancelleSendMailCount
@BookingReference varchar(100)=null,
@Pkid int=0
As
Begin
	insert into MissCancelleSendMailCount(BookingPkid,MissBookingReferenceid,InsertedDate) values(@Pkid,@BookingReference,Getdate())
End