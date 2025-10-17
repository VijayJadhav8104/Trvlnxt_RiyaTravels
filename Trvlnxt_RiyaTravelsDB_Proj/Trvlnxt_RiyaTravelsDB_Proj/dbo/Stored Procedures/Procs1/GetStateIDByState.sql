CREATE PROC [dbo].[GetStateIDByState]
	@State VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	Select top 1 ID  from mState Where StateName=@State
END