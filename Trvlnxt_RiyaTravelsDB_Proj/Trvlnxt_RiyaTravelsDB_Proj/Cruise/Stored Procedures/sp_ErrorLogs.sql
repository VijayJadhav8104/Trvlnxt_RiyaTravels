-- =============================================
-- Author:		<Jishaan Sayyed>
-- Create date: <07-10-2022>
-- Description:	<Insert Error Logs>
-- =============================================
CREATE PROCEDURE [Cruise].[sp_ErrorLogs]
@Request varchar(100)=null,
@Response varchar(100)=null,
@Error varchar(100)=null,
@StackTrace varchar(100)=null,
@URL varchar(100)=null,
@Remark varchar(100)=null,
@AgentId varchar(100)=null,
@AgentDevice varchar(100)=null,
@StatusCode varchar(100)=null
AS

BEGIN
INSERT INTO Cruise.tblErrorLogs(Request,Response,Error,StackTrace,URL,Remark,AgentId,AgentDevice,StatusCode)
						VALUES(@Request,@Response,@Error,@StackTrace,@URL,@Remark,@AgentId,@AgentDevice,@StatusCode)
END


