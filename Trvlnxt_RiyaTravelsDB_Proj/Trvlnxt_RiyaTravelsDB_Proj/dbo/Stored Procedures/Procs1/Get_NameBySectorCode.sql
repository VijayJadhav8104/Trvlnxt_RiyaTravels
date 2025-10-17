-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_NameBySectorCode]
	@Code varchar(10)
AS
BEGIN
	
	SELECT TOP 1 NAME  From tblAirportCity where CODE=@Code

END
