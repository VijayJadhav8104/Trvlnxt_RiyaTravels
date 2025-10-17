Create Procedure Proc_InsertMakePaymentCommition
@FkBookId int=0,
@ModeOfPayment varchar(50),
@ConvenienFeeInPercent float=0,
@TotalCommission float=0,
@AmountBeforeCommission float=0,
@AmountWithCommission float=0,
@ProductType varchar(50)='',
@OrderId varchar(100)=''
As
Begin
	Insert into B2BMakepaymentCommission
	(FkBookId,
	ModeOfPayment,
	ConvenienFeeInPercent,
	TotalCommission,
	AmountBeforeCommission,
	CreateDate,
	AmountWithCommission,
	ProductType,
	OrderId) 
	values(@FkBookId,@ModeOfPayment,@ConvenienFeeInPercent,@TotalCommission,
	@AmountBeforeCommission,
	GETDATE(),
	@AmountWithCommission,
	@ProductType,
	@OrderId)
End