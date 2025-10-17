CREATE PROCEDURE GetActualErrorMessage
@Provider VARCHAR(500) NULL,
@ErrorMessage VARCHAR(1700) NULL,
@MethodName VARCHAR(200) NULL,
@ProviderMessage VARCHAR(1700) NULL
AS
BEGIN
	SELECT ActualErrorMessage FROM Hotel.SupplierErrorMapping 
	WHERE PROVIDER=@Provider AND ErrorMessage=@ErrorMessage AND MethodName=@MethodName AND ProviderMessage=@ProviderMessage
END

