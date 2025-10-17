CREATE PROCEDURE [dbo].[InsertInquiry] 
@Name	varchar(50),
@Email	varchar(100),
@Feedback	varchar(1000)=NULL,
@IP	varchar(50),
@Browser	varchar(50),
@ContactNo	varchar(50),
@Device	varchar(50),
@InquiryType	varchar(50)=null,
@Country	varchar(5)=null,
@SubInquiry	varchar(500) =NULL,
@City	varchar(50) =NULL,
@Traveldate     datetime=null,
@IntrestIn    varchar(500) = null,
@BCCEmailId   varchar(1000) = null,
@BookingID   nvarchar(1000) = null,
@Rating   int=null,
@OrganisationName varchar(100)=null,
@DestlookingFor varchar(100)=null,
@DeptArvlDates varchar(100)=null,
@GroupSize int=null,
@VisaCountry nvarchar(50)=null,
@Landline NVARCHAR(50)=NULL
AS BEGIN


--INSERT INTO Feedback(Name,Email,Feedback,IP,Browser) VALUES(@Name,@Email,@Feedback,@IP,@Browser)
INSERT INTO Feedback
(Browser, Email, Feedback, IP, Name, ContactNo, Device,InquiryType,Country,SubInquiry,City,Traveldate,IntrestIn,BookingID,Rating,OrganisationName,DestlookingFor,DeptArvlDates,GroupSize,VisaCountry,CorporateLandLine)
VALUES(@Browser, @Email, @Feedback, @IP, @Name, @ContactNo, @Device,@InquiryType,@Country,@SubInquiry,@City,@Traveldate,@IntrestIn,@BookingID,@Rating,@OrganisationName,@DestlookingFor,@DeptArvlDates,@GroupSize,@VisaCountry,@Landline)

SELECT top 1 InquiryType, ToEmailID, CCEmailID, BCCEmailId BCCEmailId
FROM EmailConfiguration
WHERE InquiryType=@InquiryType AND Country = @Country AND ParentId is null


END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertInquiry] TO [rt_read]
    AS [dbo];

