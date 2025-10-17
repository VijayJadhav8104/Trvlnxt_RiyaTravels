



CREATE PROC [dbo].[Search_CustomerDetails]

@FromDate date,
@ToDate date,
@Country varchar(50),
@Email varchar(50)=null

AS
BEGIN

--declare 
--@FromDate date= '11/1/2017 12:00:00 AM',
--@ToDate date='1/05/2018 12:00:00 AM',
--@Country varchar(50)='IN',
--@Email varchar(50)=null

SELECT
UserID,
UserCode,
UserName,
Password,
(FirstName + ' ' + LastName) as Name,
CONVERT(VARCHAR(50),InsertedDate,106) AS InsertedDate ,
IsActive,
MobileNumber,
NewsLetter,
Address,
City,
Country,
Pincode,
DrivingLicenceNo,
HomeNo,
Province,
case BookingCountry when 'IN' then 'India' when 'US' then 'USA' when 'CA' then 'Canada' else '' End as BookingCountry ,
 IsB2BAgent,
AgentApproved
FROM UserLogin

WHERE convert(date,InsertedDate) between @FromDate and @ToDate  
      AND BookingCountry=@Country 
	  AND ((@Email is not null and UserName like  @Email + '%' ) or (@Email is null))
	  and IsActive=1
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Search_CustomerDetails] TO [rt_read]
    AS [dbo];

