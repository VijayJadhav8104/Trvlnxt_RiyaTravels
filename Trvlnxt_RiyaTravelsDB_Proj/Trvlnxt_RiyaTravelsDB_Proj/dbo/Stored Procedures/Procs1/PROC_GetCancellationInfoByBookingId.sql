CREATE PROCEDURE PROC_GetCancellationInfoByBookingId  
@book_Id VARCHAR(50)  
AS  
BEGIN  
 SELECT CancellationCharge,PolicyCode, AppliedAgentCharges   
 FROM Hotel_BookMaster WHERE BookingReference=@book_Id  
END  

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[PROC_GetCancellationInfoByBookingId] TO [rt_read]
    AS [dbo];

