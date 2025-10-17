CREATE PROCEDURE [dbo].[ViewPNR_InsertSSRDetails]
	@fkBookMaster BigInt
	,@fkPassengerid BigInt
	,@fkItenary BigInt
	,@ssrcode Varchar(50) = NULL
	,@amount decimal(18,2) = NULL
	,@type Varchar(10) = NULL
	,@EMDTicketNumber Varchar(30) = NULL
	,@EMDAirLineCode Varchar(50) = NULL
	,@ERPTicketNum Varchar(30) = NULL
	,@createdBy Int =0
	,@ParentOrderId Varchar(30) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	-- Meal
	BEGIN
		INSERT INTO tblSSRDetails (fkBookMaster,fkPassengerid,fkItenary,SSR_Type,SSR_Name,SSR_Code,SSR_Amount,SSR_Status,ERPTicketNum,EMDTicketNumber,EMDAirLineCode, createdDate,createdBy,ParentOrderId)
		VALUES (@fkBookMaster,@fkPassengerid,@fkItenary,@type,@ssrcode,@ssrcode,@amount,1,@ERPTicketNum,@EMDTicketNumber,@EMDAirLineCode, GETDATE(),@createdBy,@ParentOrderId)
	END

END