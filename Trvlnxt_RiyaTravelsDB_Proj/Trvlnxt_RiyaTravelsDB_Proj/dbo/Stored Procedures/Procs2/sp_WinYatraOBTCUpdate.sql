-- =============================================
-- Author:		<Jishaan.S>
-- Create date: <04-08-2023>
-- Description:	<Insert or update winyatra obtcno>
-- =============================================
CREATE PROCEDURE [dbo].[sp_WinYatraOBTCUpdate]
	@OrderId varchar(50),
	@createdOn varchar(50),
	@ObtcNo varchar(10),
	@GDsPnr varchar(6)
AS
BEGIN
	IF exists (select * from mAttrributesDetails where OrderID = @OrderId)
		begin
			update mAttrributesDetails set OBTCno = @ObtcNo, WinYatraPush = 1 where OrderID = @OrderId
		end
	else
		begin
			insert into mAttrributesDetails (WinYatraPush,OBTCno,OrderID,GDSPNR,CreatedOn) values(1,@ObtcNo,@OrderId,@GDsPnr,@createdOn)
		end
END
