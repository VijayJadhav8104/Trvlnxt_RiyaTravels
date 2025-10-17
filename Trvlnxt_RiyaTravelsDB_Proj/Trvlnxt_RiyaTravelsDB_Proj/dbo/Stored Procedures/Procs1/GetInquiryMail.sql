


CREATE PROCEDURE [dbo].[GetInquiryMail]
@InquiryType	VARCHAR(20)
AS BEGIN
	SELECT InquiryType, ToEmailID, CCEmailID
	FROM EmailConfiguration 
	WHERE InquiryType=@InquiryType
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetInquiryMail] TO [rt_read]
    AS [dbo];

