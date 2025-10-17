-- =============================================
-- Author:		<Jitendra Nakum>
-- Create date: <09-02-2023>
-- Description:	<This Procedure is Used to get unique carrier from t>
-- =============================================   
CREATE PROCEDURE [dbo].[GetUniqueSector]
AS
BEGIN
	SELECT DISTINCT Carrier from tblAirlineSectors WHERE Carrier IS NOT NULL
END