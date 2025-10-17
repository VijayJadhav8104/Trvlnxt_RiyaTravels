-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE USPGetSkipAirline_Mystify
	 @ServiceName varchar(100)
AS
BEGIN
	 select * from tblSkipAirlineMaster where ServiceFlag=@ServiceName and IsActive=1
	
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USPGetSkipAirline_Mystify] TO [rt_read]
    AS [dbo];

