CREATE PROC GetUserTypeID
	@UserType VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	Select top 1 ID,Value from mCommon Where Category='UserType' AND Value=@UserType	
END
