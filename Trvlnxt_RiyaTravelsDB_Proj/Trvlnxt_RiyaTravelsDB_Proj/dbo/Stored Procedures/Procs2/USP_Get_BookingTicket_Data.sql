CREATE Procedure USP_Get_BookingTicket_Data
As
Begin
	SELECT HSM.Status,hsh.FkStatusId, * FROM Hotel_BookMaster HB
	INNER JOIN B2BRegistration BR ON HB.RiyaAgentID = BR.FKUserID  
	left JOIN Hotel_Status_History hsh on hsh.FKHotelBookingId=HB.pkId and hsh.IsActive=1
	Left JOIN Hotel_Status_Master HSM on hsh.FkStatusId=HSM.Id
	WHERE HSM.Status in('On Request','Confirmed','Vouchered','Reject','Cancelled','Sold Out','Pending','Failed')  and HB.CheckInDate>=GETDATE() ORDER BY HB.pkId desc           
End
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_Get_BookingTicket_Data] TO [rt_read]
    AS [dbo];

