CREATE PROC DeleteVendorField
	@ID INT,@FieldName VARCHAR(100)
AS
BEGIN
	DECLARE @Fields VARCHAR(MAX)
	Select TOP 1 @Fields=Fields from mVendor Where ID=@ID
	
	SET @Fields=REPLACE(@Fields,@FieldName,'')
	PRINT @Fields
	UPDATE mVendor SET Fields=@Fields WHERE ID=@ID

	delete from mVendorCredential Where VendorId=@ID AND FieldName=REPLACE(@FieldName,',','')
END
