CREATE PROCEDURE sp_InsertBannerImage 
	@CotentType VARCHAR(MAX),
    @ImageByte VARBINARY(MAX),
    @BannerId INT,
    @IsActive BIT,
    @ImageOrder INT,
    @ModifiedOn DATETIME= NULL,
    @ModifiedBy INT= NULL,
    @CreatedOn DATETIME= NULL,
    @CreatedBy INT = NULL,
    @URL NVARCHAR(255)=NULL,
    @ImageName NVARCHAR(255)=NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO mBannerImages (CotentType,       
        ImageByte,
        BannerId,
        IsActive,
        ImageOrder,
        ModifiedOn,
        ModifiedBy,
        CreatedOn,
        CreatedBy,
        [URL],
        ImageName
    )
    VALUES (@CotentType,    
        @ImageByte,
        @BannerId,
        @IsActive,
        @ImageOrder,
        @ModifiedOn,
        @ModifiedBy,
        @CreatedOn,
        @CreatedBy,
        @URL,
        @ImageName
    )
END