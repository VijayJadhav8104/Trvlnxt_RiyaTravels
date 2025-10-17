﻿CREATE PROC UpdateBannerURL
	@ID INT,
	@URL VARCHAR(MAX),
	@ModifyBy INT
AS
BEGIN
	SET NOCOUNT ON

	UPDATE mBannerImages SET [URL]=@URL,ModifiedBy=@ModifyBy,ModifiedOn=GETDATE()
	WHERE ID=@ID
	
END