
CREATE PROCEDURE [Rail].[sp_CheckTokenExists]
(
    @access_token NVARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 
        FROM [Rail].[Tokens]
        WHERE access_token = @access_token
    )
    BEGIN
        SELECT CAST(1 AS BIT) AS TokenExists;
    END
    ELSE
    BEGIN
        SELECT CAST(0 AS BIT) AS TokenExists;
    END
END
