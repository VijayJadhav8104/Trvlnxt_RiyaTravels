-- =============================================
-- Author:		<Dhanraj Bendale>
-- Create date: <06-06-2018>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UserPermssionController_hotel]
	 
AS
BEGIN
	 select Id,UPPER(Action) as Action from Hotel_MenuNew
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UserPermssionController_hotel] TO [rt_read]
    AS [dbo];

