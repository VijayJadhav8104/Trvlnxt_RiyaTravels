CREATE PROC GetStateID
	@state_code VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT top 1 S.ID from tblStateCode C
	JOIN mState S ON C.State=S.StateName where StateCode=@state_code
	
END
