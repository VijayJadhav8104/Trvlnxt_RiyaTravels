-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_sessioncheck]
@Session varchar(50)
AS
BEGIN
	select top 1 * from ASPState.dbo.ASPStateTempSessions where SessionId = @Session order by 1 desc
END
