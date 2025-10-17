
CREATE   PROCEDURE [Rail].[sp_GetToken]
(
    @RiyaUserId BIGINT,
    @AgentId    BIGINT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        Id,
        access_token,
        token_type,
        expires_in,
        created_on,
        RiyaUserId,
        AgentId,
        CreatedDate,
        ModifiedDate
    FROM [Rail].[Tokens]
    WHERE RiyaUserId = @RiyaUserId
      AND AgentId    = @AgentId;
END
