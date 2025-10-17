CREATE Procedure SP_GetUrlList
AS
BEGIN
	SELECT dbo.udfTrim(APIUrl) as APIUrl FROM APIUrlList WHERE IsActive=1
END

--EXEC SP_GetUrlList
