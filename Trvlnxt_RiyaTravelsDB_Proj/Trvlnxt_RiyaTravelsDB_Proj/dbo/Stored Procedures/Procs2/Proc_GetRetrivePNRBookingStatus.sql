CREATE Procedure Proc_GetRetrivePNRBookingStatus
@FKBookingId int=0
As
Begin
	Select HSM.Status,HB.FkStatusId from 
	Hotel_Status_History HB
	left Join
	Hotel_Status_Master HSM
	ON HB.FkStatusId=HSM.Id
	WHERE HB.IsActive=1 and HB.FKHotelBookingId=@FKBookingId
End