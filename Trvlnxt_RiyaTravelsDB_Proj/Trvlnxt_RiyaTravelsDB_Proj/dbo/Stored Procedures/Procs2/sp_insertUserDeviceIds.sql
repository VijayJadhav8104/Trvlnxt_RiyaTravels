-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_insertUserDeviceIds]
 @UserID VARCHAR(30)=NULL,      
 @UserDeviceID VARCHAR(100)=NULL,      
 @UserType VARCHAR(100)=NULL,  
 @IPAddress VARCHAR(100)=NULL,
 @MatchedPara VARCHAR(100)=NULL,
 @BrowserName VARCHAR(50)=NULL,
 @BrowserVer VARCHAR(50)=NULL,
 @PdfViewerEnabled VARCHAR(50)=NULL, @DeviceMemoryRam VARCHAR(50) = NULL, 
 @ProcessorCores VARCHAR(50) = NULL, @WindowsHeight VARCHAR(50) = NULL,
 @WindowsWidth VARCHAR(50) = NULL, @DeviceStorage VARCHAR(50) = NULL,
 @UserLoginCountry VARCHAR(50) = NULL
AS
BEGIN	 
  INSERT INTO UserDeviceIDs (UserID, UserType ,UserDeviceID, MatchedParameter ,IPAddress, CreatedDate, 
			   BrowserName, BrowserVer,PdfViewerEnabled, DeviceMemoryRam, ProcessorCores,WindowsHeight,WindowsWidth,DeviceStorage, UserLoginCountry)  
        VALUES (@UserID, @UserType,@UserDeviceID,@MatchedPara, @IPAddress, GETDATE(), 
		@BrowserName, @BrowserVer, @PdfViewerEnabled, @DeviceMemoryRam, @ProcessorCores, @WindowsHeight,@WindowsWidth,@DeviceStorage,@UserLoginCountry)    
END
