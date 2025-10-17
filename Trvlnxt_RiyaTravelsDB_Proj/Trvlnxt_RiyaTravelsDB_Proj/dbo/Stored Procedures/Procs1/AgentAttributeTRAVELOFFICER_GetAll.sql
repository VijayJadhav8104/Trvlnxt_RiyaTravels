-- =============================================
-- Author:	
-- Create date: 13.11.2024
-- Description:	Get all TRAVELOFFICER For Display In Attributes Details
-- =============================================
CREATE PROCEDURE [dbo].[AgentAttributeTRAVELOFFICER_GetAll]
AS
BEGIN
	SET NOCOUNT ON;

    SELECT TRAVELOFFICER FROM tbl_AttributeTRAVELOFFICER
END
