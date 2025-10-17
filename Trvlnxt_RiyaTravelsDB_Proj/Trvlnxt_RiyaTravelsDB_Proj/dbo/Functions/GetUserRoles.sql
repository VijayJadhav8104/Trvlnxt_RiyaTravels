CREATE FUNCTION [dbo].[GetUserRoles](@UserId UNIQUEIDENTIFIER)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Roles NVARCHAR(MAX);

    SELECT @Roles = 
        STUFF((
            SELECT ', ' + ANR.Name
            FROM AspNetUserRoles ANU
            JOIN AspNetRoles ANR ON ANU.RoleId = ANR.Id
            WHERE ANU.UserId = @UserId
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '');

    RETURN @Roles;
END;

