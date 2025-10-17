CREATE PROCEDURE [dbo].[GetSalesPersonDetails]
    @FKUserID INT
AS
BEGIN

    DECLARE @SalesPersonId varchar(50)

    SELECT @SalesPersonId = SalesPersonId FROM B2BRegistration WHERE FKUserID = @FKUserID
    
    SELECT TOP 1 FullName,EmailID,MobileNo FROM mUser 
	WHERE EmployeeNo = @SalesPersonId 
END