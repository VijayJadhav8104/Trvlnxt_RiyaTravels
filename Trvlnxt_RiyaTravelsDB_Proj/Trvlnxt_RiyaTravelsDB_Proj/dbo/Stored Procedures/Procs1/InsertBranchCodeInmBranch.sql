CREATE PROC InsertBranchCodeInmBranch
	@Code VARCHAR(50)
	,@State_Code VARCHAR(50)
	,@BranchCode VARCHAR(50)
	,@Name VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS(Select * from mBranch Where BranchCode=@BranchCode)
	BEGIN
		INSERT INTO mBranch
		(Code,State_Code,BranchCode,Name)
		VALUES
		(@Code,@State_Code,@BranchCode,@Name)
	END
END
