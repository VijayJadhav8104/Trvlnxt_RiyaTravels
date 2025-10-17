CREATE PROCEDURE [dbo].[InsertAmadeusSessionLogs] 
	@OfficeId varchar(50)=null,
	@sessionID varchar(50)=null,
	@SessionData varchar(MAX)=null,
	@Type varchar(50)=null,
	@SourceName varchar(50)=null
AS
BEGIN
	Insert into mAmadeusSessionLog (OfficeId,sessionID,SessionData,Type,SourceName) values
	(@OfficeId,@sessionID,@SessionData,@Type,@SourceName)
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertAmadeusSessionLogs] TO [rt_read]
    AS [dbo];

