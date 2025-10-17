
-- =============================================
-- Author:		<Author,,Abhishek>
-- Create date: <Create Date,,>
-- Description:	<Description,,> exec Proc_DeviceRecognitionValidity '139','UDK4V1','1'
-- =============================================
CREATE PROCEDURE [dbo].[Proc_DeviceRecognitionValidity]
	@UserID VARCHAR(30)=Null,
    @OTP VARCHAR(50)=null,
	@UserType VARCHAR(100)=null
	AS
BEGIN
    -- Check if the OTP already exists for the username
	-- Check if the OTP is 15 Minutes old 
	DECLARE @ValidTimeLimit INT = 15; -- 15 minutes
	DECLARE @getOTPTime INT= 0;
	IF (@UserType = 1) 
		BEGIN
			SELECT ID FROM mUser WHERE ID = @UserID and OTPGenerated = @OTP and datediff(minute, OTPTime, getDate())<=15
		END

	IF (@UserType = 2 or @UserType=3)
		BEGIN 
			SELECT UserID as ID FROM AgentLogin WHERE UserID = @UserID and OTPGenerated = @OTP and datediff(minute, OTPTime, getDate())<=15
		END 
	
END 





--AS
--BEGIN
--    -- Check if the OTP already exists for the username
--	-- Check if the OTP is 15 Minutes old 
--	DECLARE @ValidTimeLimit INT = 15; -- 15 minutes @uid
--	DECLARE @getOTPTime INT= 0;
--	IF (@UserType = 1) 
--    BEGIN
--        -- Check if the OTP is valid and update CheckBoxTime if true
--        IF EXISTS (SELECT ID FROM mUser WHERE ID = @UserID AND OTPGenerated = @OTP AND DATEDIFF(MINUTE, OTPTime, GETDATE()) <= @ValidTimeLimit)
--        BEGIN
--            UPDATE tblLoginHistory
--            SET CheckBoxTime = GETDATE() -- Update CheckBoxTime column with current datetime
--            WHERE UserID = @UserID;
            
--            SELECT 1 AS result; --  success
--        END
--        ELSE
--        BEGIN
--            SELECT 0 AS result; --  failure
--        END
--    END

--    IF (@UserType = 2 OR @UserType = 3)
--    BEGIN 
--        -- Check if the OTP is valid and update CheckBoxTime if true
--        IF EXISTS (SELECT UserID FROM AgentLogin WHERE UserID = @UserID AND OTPGenerated = @OTP AND DATEDIFF(MINUTE, OTPTime, GETDATE()) <= @ValidTimeLimit)
--        BEGIN
--            UPDATE tblLoginHistory
--            SET CheckBoxTime = GETDATE() -- Update CheckBoxTime column with current datetime
--            WHERE UserID = @UserID;
            
--            SELECT 1 AS result; --  success
--        END
--        ELSE
--        BEGIN
--            SELECT 0 AS result; --  failure
--        END
--    END
--END 


