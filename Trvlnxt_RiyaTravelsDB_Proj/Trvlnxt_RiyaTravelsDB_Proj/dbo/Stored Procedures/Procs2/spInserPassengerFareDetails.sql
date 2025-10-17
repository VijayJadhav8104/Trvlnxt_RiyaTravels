CREATE PROC [dbo].[spInserPassengerFareDetails]	
	@OrderId	varchar(100)
	,@fkBookMaster	int
	,@paxid	int
	,@BaseAmount	decimal(18, 2)
	,@Commission	decimal(18, 2)
	,@Discount	decimal(18, 2)
	,@GrossAmount	decimal(18, 2)
	,@Incentive	decimal(18, 2)
	,@PLBAmount	decimal(18, 2)
	,@Paxtype	varchar(50)
	,@ServiceFee	decimal(18, 2)
	,@ServiceFeeGST	decimal(18, 2)
	,@Servicecharge	decimal(18, 2)
	,@TDS	decimal(18, 2)
	,@TotalTaxAmount	decimal(18, 2)
	,@IsSSOUser	bit

AS
BEGIN
	SET NOCOUNT ON;
		
	INSERT INTO tblPassengerFareDetails
	(OrderId
		,fkBookMaster
		,paxid
		,BaseAmount
		,Commission
		,Discount
		,GrossAmount
		,Incentive
		,PLBAmount
		,Paxtype
		,ServiceFee
		,ServiceFeeGST
		,Servicecharge
		,TDS
		,TotalTaxAmount
		,IsSSOUser
		,InsertedDate)
	VALUES
	(@OrderId
		,@fkBookMaster
		,@paxid
		,@BaseAmount
		,@Commission
		,@Discount
		,@GrossAmount
		,@Incentive
		,@PLBAmount
		,@Paxtype
		,@ServiceFee
		,@ServiceFeeGST
		,@Servicecharge
		,@TDS
		,@TotalTaxAmount
		,@IsSSOUser
		,GETDATE())
END