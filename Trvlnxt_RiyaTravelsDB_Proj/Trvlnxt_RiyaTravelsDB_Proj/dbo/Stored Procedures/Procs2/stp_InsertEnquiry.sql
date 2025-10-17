


--Create table tbl_Enquiry (sName varchar(200), sEmail Varchar(200), sContactNo varchar(10), sMessage Varchar(MAX), dInsertedDate Datetime, sEnquirytype Varchar(100))

CREATE Procedure [dbo].[stp_InsertEnquiry] (
@Name Varchar(200),
@Email Varchar(200),
@ContactNo Varchar(200),
@Message Varchar(200),
@InsertedDate Datetime,
@Enquirytype Varchar(200)
)
as
Begin

Insert into tbl_Enquiry (sName,sEmail,sContactNo,sMessage,dInsertedDate,sEnquirytype)
Select @Name,@Email,@ContactNo,@Message,@InsertedDate,@Enquirytype


END


--Exec stp_InsertEnquiry @Name='ABC',@Email='ABC@abc.com',@ContactNo='1234567890',@Message='testing', @InsertedDate='2017-06-22', @Enquirytype='General'

--select * from tbl_Enquiry




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[stp_InsertEnquiry] TO [rt_read]
    AS [dbo];

