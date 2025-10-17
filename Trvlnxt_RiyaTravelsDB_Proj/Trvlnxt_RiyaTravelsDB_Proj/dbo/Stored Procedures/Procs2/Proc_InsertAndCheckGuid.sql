
-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,> exec Proc_InsertAndCheckGuid 'NITISH','a6482b7a-75f2-40c0-b7cb-7d6632c10c79','0'    
-- =============================================    
CREATE PROCEDURE [dbo].[Proc_InsertAndCheckGuid]    
 @UserID VARCHAR(30)=NULL,    
 @UserDeviceID VARCHAR(100)=NULL,  
 @IPAddress VARCHAR(100)=NULL,
 @UserType VARCHAR(100)=NULL   
AS    
BEGIN    

    -- Check if the UserDeviceID(GUID) already exists and Update.    
	IF (@UserType = 1)    
		BEGIN     
			UPDATE mUser         
			SET UserDeviceID = @UserDeviceID,   
			UserDeviceIdTime = GETDATE(),
			OTPGenerated = '',
			OTPTime = NULL
			WHERE ID = @UserID    
        End    
	IF(@UserType = 2 or @UserType = 3)    
		BEGIN    
			UPDATE AgentLogin         
			SET UserDeviceID = @UserDeviceID,  
			UserDeviceIdTime = GETDATE(),
			OTPGenerated = '',
			OTPTime = NULL
			WHERE UserID = @UserID    
		END    
  
END    
    
