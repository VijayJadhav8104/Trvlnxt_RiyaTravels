CREATE proc [dbo].[InsertIdealPersonDetails]

@Name varchar(100),
@ContactNum numeric(18,0),
@EmailID varchar(50),
@IP varchar(50),
@Browser varchar(50),
@Country varchar(50),
@Device varchar(50)

as
begin

Insert into IdealPersonDetails
(
FullName,
ContactNum,
EmailID,
IP,
Browser,
Country,
InsertedDate,
Device
)

values
(
@Name ,
@ContactNum ,
@EmailID ,
@IP ,
@Browser ,
@Country ,
GETDATE(),
@Device
)


SELECT InquiryType, ToEmailID, CCEmailID
	FROM EmailConfiguration 
	WHERE InquiryType='Ideal' AND Country = @Country



end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertIdealPersonDetails] TO [rt_read]
    AS [dbo];

