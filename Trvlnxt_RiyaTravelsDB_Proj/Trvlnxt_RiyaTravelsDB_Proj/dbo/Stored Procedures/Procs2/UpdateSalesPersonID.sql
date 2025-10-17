CREATE PROC UpdateSalesPersonID
	@SalesPersonID VARCHAR(50),@ICUST VARCHAR(MAX),@SalesPersonName VARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE B2BRegistration SET SalesPersonId=@SalesPersonID,SalesPersonName=@SalesPersonName
	--WHERE AddrEmail=@ICUST
	WHERE RTRIM(LTRIM(Icast))=@ICUST
END
