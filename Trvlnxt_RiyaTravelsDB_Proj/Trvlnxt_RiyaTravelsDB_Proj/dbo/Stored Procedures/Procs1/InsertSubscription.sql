

CREATE PROCEDURE [dbo].[InsertSubscription]
@EmailID varchar(50), 
@MobileNo varchar(50)=null, 
@IP varchar(50), 
@browser varchar(50), 
@device varchar(50), 
@Country varchar(2)=null, 
@InquiryType varchar(50)=null,
@SubInquiry varchar(50)=null

AS
BEGIN


Insert into tblSubscription
(EmailID, MobileNo, IP, browser, device, Country, InquiryType,SubInquiry)
values (@EmailID, @MobileNo, @IP, @browser,  @device, @Country, @InquiryType,@SubInquiry)

END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertSubscription] TO [rt_read]
    AS [dbo];

