-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Hotel_getAllcities]
	
AS
BEGIN
	select * from Hotel_CountryMaster

END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Hotel_getAllcities] TO [rt_read]
    AS [dbo];

