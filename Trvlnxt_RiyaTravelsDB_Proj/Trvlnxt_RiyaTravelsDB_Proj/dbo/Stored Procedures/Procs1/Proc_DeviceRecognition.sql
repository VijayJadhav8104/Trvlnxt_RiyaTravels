
-- =============================================
-- Author:		<Author,,Abhishek>
-- Create date: <Create Date,,>
-- Description:	<UPDATING OTP AND OTP TIME IN TABLE,,> 
-- =============================================
CREATE PROCEDURE [dbo].[Proc_DeviceRecognition]
	@UserID VARCHAR(30)=NULL,
    @OTP VARCHAR(50)=NULL,
	@UserType VARCHAR(100)=NULL
AS
BEGIN
	IF (@UserType = 1)
		BEGIN
			UPDATE mUser     
			SET OTPGenerated = @OTP,
			OTPTime = GETDATE()
			WHERE ID = @UserID
		END
	IF(@UserType = 2)
		BEGIN
			UPDATE AgentLogin     
			SET OTPGenerated = @OTP,
			OTPTime = GETDATE()
			WHERE UserID = @UserID
		END
	IF(@UserType = 3)
		BEGIN
			UPDATE AgentLogin     
			SET OTPGenerated = @OTP,
			OTPTime = GETDATE()
			WHERE UserID = @UserID
		END
END


