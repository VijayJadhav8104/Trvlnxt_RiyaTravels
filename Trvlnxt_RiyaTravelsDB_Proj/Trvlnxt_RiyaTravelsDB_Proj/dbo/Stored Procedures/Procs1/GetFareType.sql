-- =============================================
-- Author:		Afifa
-- Create date: 13/March/2021
-- Description:	To get Data For DropDown
-- [dbo].[GetFaretype] 'FareType'
-- =============================================
CREATE PROCEDURE [dbo].[GetFareType]-- 'Quatation'
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     SELECT   Id,FareType,* FROM tblFareType
	 
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetFareType] TO [rt_read]
    AS [dbo];

