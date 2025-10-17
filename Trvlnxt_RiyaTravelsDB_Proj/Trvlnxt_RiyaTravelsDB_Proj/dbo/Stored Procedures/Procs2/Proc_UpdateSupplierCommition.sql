CREATE Procedure Proc_UpdateSupplierCommition  
@FKBookingId int,  
@GSTAmount float=0,  
@SupplierCommission float=0,  
@RiyaCommission float=0,  
@TDSDeductedAmount float=0,  
@FinalEarningAmount float=0  
As  
Begin  
	Declare @FK_book_ID int=0
	Declare @SuPcOMMITION float=0
	
	Select @FK_book_ID=Fk_BookId,@SuPcOMMITION=SupplierCommission from B2BHotel_Commission Where Fk_BookId=@FKBookingId

	if(@FK_book_ID=@FKBookingId)
	Begin
		if(@SuPcOMMITION !=@SupplierCommission)
		Begin
		update B2BHotel_Commission Set GSTAmount=@GSTAmount, SupplierCommission=@SupplierCommission,  
		RiyaCommission=@RiyaCommission, TDSDeductedAmount=@TDSDeductedAmount,  
		EarningAmount=@FinalEarningAmount Where Fk_BookId=@FKBookingId  
		End
	End
End
