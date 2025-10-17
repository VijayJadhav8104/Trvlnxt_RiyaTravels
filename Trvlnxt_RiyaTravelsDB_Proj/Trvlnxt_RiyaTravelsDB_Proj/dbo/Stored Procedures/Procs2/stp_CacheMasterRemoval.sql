

--Select * from tblCacheMaster where convert (DATE,expiredOn,105) < CAST( '2017-06-21 13:29:49.880' as date)



CREATE PROCEDURE [dbo].[stp_CacheMasterRemoval] 
AS
BEGIN
DELETE FROM tblCacheMaster WHERE CAST ( expiredOn as date )  < CAST( GETDATE() as date)
DELETE FROM tblCacheMasterRemoveItems WHERE CAST ( expiredOn as date )  < CAST( GETDATE() as date)
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[stp_CacheMasterRemoval] TO [rt_read]
    AS [dbo];

