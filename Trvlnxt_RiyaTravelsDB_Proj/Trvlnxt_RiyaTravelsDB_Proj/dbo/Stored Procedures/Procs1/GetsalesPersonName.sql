CREATE PROC GetsalesPersonName
	@SalesPersonId VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	Select top 1 FullName from mUser Where EmployeeNo=@SalesPersonId
END