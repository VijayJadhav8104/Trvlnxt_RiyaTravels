-- =============================================
-- Author:		<JD>
-- Create date: <21.12.2022>
-- Description:	<Update BarCode By PID>
-- =============================================
CREATE PROCEDURE [dbo].[Update_BarCode_By_PID]
	-- Add the parameters for the stored procedure here
	@pid BigInt
	, @BarCode Varchar(MAX)
	, @PassengerID NVarchar(MAX) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	    
	UPDATE tblPassengerBookDetails 
	SET	BarCode = @BarCode, PassengerID = @PassengerID
	WHERE pid = @pid
END
