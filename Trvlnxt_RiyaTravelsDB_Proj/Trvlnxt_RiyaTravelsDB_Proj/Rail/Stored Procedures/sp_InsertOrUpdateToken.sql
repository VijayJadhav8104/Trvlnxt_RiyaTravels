
CREATE PROCEDURE [Rail].[sp_InsertOrUpdateToken]
(
    @access_token   VARCHAR(500),
    @token_type     VARCHAR(100),
    @expires_in     VARCHAR(100),
    @created_on     VARCHAR(100),
    @RiyaUserId     BIGINT,
    @AgentId        BIGINT
)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 
        FROM [Rail].[Tokens] 
        WHERE RiyaUserId = @RiyaUserId AND AgentId = @AgentId
    )
    BEGIN
        -- Update existing record
        UPDATE [Rail].[Tokens]
        SET access_token = @access_token,
            token_type   = @token_type,
            expires_in   = @expires_in,
            created_on   = @created_on,
            ModifiedDate = GETDATE()
        WHERE RiyaUserId = @RiyaUserId
          AND AgentId    = @AgentId;
    END
    ELSE
    BEGIN
        -- Insert new record
        INSERT INTO [Rail].[Tokens]
        (
            access_token, token_type, expires_in, created_on,
            RiyaUserId, AgentId, CreatedDate
        )
        VALUES
        (
            @access_token, @token_type, @expires_in, @created_on,
            @RiyaUserId, @AgentId, GETDATE()
        );
    END
END
