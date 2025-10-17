CREATE PROCEDURE [dbo].[MTTicketNumberEnable_GetAll]
	
AS
BEGIN
	SET NOCOUNT ON;

    SELECT VendorName FROM MTTicketNumberEnable WHERE IsActive = 1
END
