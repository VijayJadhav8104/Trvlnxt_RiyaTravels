CREATE PROC UpdateBannerImages
	@Id INT
AS
BEGIN
	SET NOCOUNT ON;

	Delete from mBannerImages Where ID=@Id
END