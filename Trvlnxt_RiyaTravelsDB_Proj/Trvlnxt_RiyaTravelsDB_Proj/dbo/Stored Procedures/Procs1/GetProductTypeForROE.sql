-- =============================================
-- Author:		Jitendra Nakum
-- Create date: 01.02.2023
-- Description:	This Procedure is used to get All Product Type for ROE
-- =============================================
CREATE PROCEDURE GetProductTypeForROE 
AS
BEGIN
	SELECT 
	ID,
	ProductName
	FROM ProductTypeMasterForROE
END