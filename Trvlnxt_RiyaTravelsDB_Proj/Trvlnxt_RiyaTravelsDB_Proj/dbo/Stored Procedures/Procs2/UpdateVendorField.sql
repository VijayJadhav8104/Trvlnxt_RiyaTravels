CREATE PROC UpdateVendorField
	@ID INT,@FieldName VARCHAR(100),@NewFieldName VARCHAR(100)
AS
BEGIN
	DECLARE @Fields VARCHAR(MAX)
	Select TOP 1 @Fields=Fields from mVendor Where ID=@ID
	
	SET @Fields=REPLACE(@Fields,@FieldName,@NewFieldName)
	
	UPDATE mVendor SET Fields=@Fields WHERE ID=@ID

	UPDATE mVendorCredential SET FieldName=@NewFieldName Where VendorId=@ID AND FieldName=@FieldName
END
