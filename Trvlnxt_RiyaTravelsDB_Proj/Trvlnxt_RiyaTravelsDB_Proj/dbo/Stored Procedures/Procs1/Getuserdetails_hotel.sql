-- =============================================
-- Author:		<Dhanraj Bendale>
-- Create date: <06-06-2018>
-- Description:	<Fetch User hotel>
-- =============================================
CREATE PROCEDURE [dbo].[Getuserdetails_hotel] 
	 
AS
BEGIN
	 select * from Hotel_UserMaster where Status=1
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Getuserdetails_hotel] TO [rt_read]
    AS [dbo];

