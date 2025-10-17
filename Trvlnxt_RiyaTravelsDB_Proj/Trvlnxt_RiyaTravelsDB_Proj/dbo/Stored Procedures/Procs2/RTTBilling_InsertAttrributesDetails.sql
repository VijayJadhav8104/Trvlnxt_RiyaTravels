CREATE PROCEDURE [dbo].[RTTBilling_InsertAttrributesDetails] 
	 @OrderID Varchar(50) = NULL
	,@GDSPNR Varchar(50) = NULL
	,@Bookedby Varchar(15) = NULL
	,@OBTCno	Varchar(50) = NULL
	,@CreatedBy Int = NULL
	,@fkPassengerid BigInt = NULL
	,@PaxName Varchar(255) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO mAttrributesDetails (orderId
	,GDSPNR
	,Bookedby
	,CreatedOn
	,CreatedBy
	,OBTCno
	,fkPassengerid
	,PaxName) 
	VALUES (@OrderID
	,@GDSPNR
	,@Bookedby
	,GETDATE()
	,@CreatedBy
	,@OBTCno
	,@fkPassengerid
	,@PaxName)
   
	SELECT SCOPE_IDENTITY();
END