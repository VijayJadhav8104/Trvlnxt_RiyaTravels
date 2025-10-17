-- =============================================
-- Author:		<Sandhya Gaikwad>
-- Create date: <5th feb 2017>
-- Description:	<Get all hotel id>
-- =============================================
CREATE PROCEDURE [dbo].[Hotel_Get_ID]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
			
    select ID from Hotel_List_Master
   
END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Hotel_Get_ID] TO [rt_read]
    AS [dbo];

