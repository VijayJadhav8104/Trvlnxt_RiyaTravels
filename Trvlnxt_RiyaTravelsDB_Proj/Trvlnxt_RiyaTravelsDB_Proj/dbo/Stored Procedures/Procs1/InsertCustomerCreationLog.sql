CREATE PROC InsertCustomerCreationLog
	@ICUST VARCHAR(100),@Status VARCHAR(500)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO tblCustomerCreationlog
	(ICUST,Status,EntryDate) VALUES (@ICUST,@Status,GETDATE())

	Update tblICust SET IsDone=1 Where ICust=@ICUST
END
