CREATE proc [dbo].[GetAllEnquiryTypes]

as
begin

	select distinct(InquiryType) from Feedback where InquiryType is not null

end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllEnquiryTypes] TO [rt_read]
    AS [dbo];

