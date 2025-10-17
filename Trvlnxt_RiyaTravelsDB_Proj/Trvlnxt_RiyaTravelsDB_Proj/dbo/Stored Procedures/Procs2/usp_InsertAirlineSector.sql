-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_InsertAirlineSector
	@fromsector varchar(10),
	@tosector varchar(10),
	@carrier varchar(10)
AS
BEGIN
	if exists(select top 1 * from tblAirlineSectors where Carrier = @carrier and fromSector = @fromsector and toSector = @tosector)
	BEGIN
	return 1;
	END
	ELSE
	BEGIN
	insert into tblAirlineSectors values(@carrier,@fromsector,@tosector,1)
	END
END
