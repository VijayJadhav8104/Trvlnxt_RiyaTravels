CREATE PROC [dbo].[sp_InsertOTPHistory]
	@OTPStatus INT =NULL,
	@AgentID INT =NULL,
    @IPAddress VARCHAR(500) = NULL,
	@Source VARCHAR(20) = NULL,
	@OTP VARCHAR(20) = NULL
 AS
 BEGIN

       INSERT INTO tblOTPHistory(OTPStatus,OTPDate,AgentID,IPAddress,Source,OTP)
       VALUES(@OTPStatus,GETDATE(),@AgentID,@IPAddress,@Source,@OTP)

 END
      
      