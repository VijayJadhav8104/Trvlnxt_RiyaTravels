CREATE PROCEDURE GetPasswordByUsername
    @Username NVARCHAR(100)
AS
BEGIN
    SELECT ISNULL(PasswordEncrypt,Password) Password
    FROM AgentLogin
    WHERE Username = @Username
END