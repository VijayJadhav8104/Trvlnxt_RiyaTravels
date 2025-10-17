CREATE PROCEDURE [dbo].[FetchSalesPersonEmail]
	@Key Varchar(200)        
AS         
BEGIN            
	SELECT         
	TOP 100 ID as PKID,         
	EmailID
	FROM mUser 
	WHERE 
	EmailID like '%' + @Key+ '%'
END