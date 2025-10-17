
CREATE PROCEDURE [dbo].[sp_GetBookMasterData]
@frmSector Varchar(10),
@toSector VARCHAR(10),
@Sector VARCHAR(10)

AS
BEGIN
	 SELECT * FROM [B2C_India].[dbo].[tblBookMaster] 
	 WHERE frmSector=@frmSector
	 SELECT * FROM [B2C_India].[dbo].[tblBookMaster] 
	 WHERE toSector=@toSector
	 SELECT * FROM [B2C_India].[dbo].[tblBookMaster] 
	 WHERE frmSector=@Sector
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetBookMasterData] TO [rt_read]
    AS [dbo];

