--Select * from tblLoginHistory
create PROC [dbo].[Insert_tblLoginHistory]
	@USERID  INT    
    ,@Device VARCHAR(100) =NULL
    ,@IPAddress VARCHAR(100)=NULL
    ,@Browser VARCHAR(100)=NULL           
    ,@SessionId VARCHAR(500)=NULL
    ,@visitorId VARCHAR(500)=NULL 
    ,@deviceinfo VARCHAR(MAX)=NULL  
	,@CheckBoxTime DATETIME=NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO tblLoginHistory       
       ( USERID,Device, IPAddress, Browser, Status, SessionId, visitorId, deviceinfo, CheckBoxTime)      
     VALUES (@UserID, @Device, @IPAddress, @Browser, 1, @SessionID, @visitorId, @deviceinfo, @CheckBoxTime) 
END