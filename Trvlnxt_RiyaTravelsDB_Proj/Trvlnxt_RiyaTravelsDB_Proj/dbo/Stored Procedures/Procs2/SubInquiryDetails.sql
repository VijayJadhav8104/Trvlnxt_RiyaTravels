
CREATE proc [dbo].[SubInquiryDetails]
@InquiryType varchar(100),
@SubInquiryType varchar(100)

As
Begin
select * from EmailConfiguration where ParentId in( select PKId from EmailConfiguration where InquiryType=@InquiryType) 
and InquiryType=@SubInquiryType
End

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SubInquiryDetails] TO [rt_read]
    AS [dbo];

