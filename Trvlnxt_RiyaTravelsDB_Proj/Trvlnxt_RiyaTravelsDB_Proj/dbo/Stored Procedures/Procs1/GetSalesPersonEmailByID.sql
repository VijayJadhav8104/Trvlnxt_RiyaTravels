CREATE PROCEDURE [dbo].[GetSalesPersonEmailByID]
@SalesPersonID int  
AS
BEGIN
	SELECT spm.EmailID from mUser spm
	WHERE spm.ID=@SalesPersonID
END