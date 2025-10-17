CREATE proc [dbo].[GetVisaApplicantInfo]
@applicantId int
As
Begin
	Select Name,Email,Mobile,[State],Branch,VisaApplicantNo,CouponCode,OrderId,ActualAmt,DiscountedAmt,InvoiceNo from tblVisaAssurance where id=@applicantId
End

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetVisaApplicantInfo] TO [rt_read]
    AS [dbo];

