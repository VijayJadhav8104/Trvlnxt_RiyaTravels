
CREATE PROC [dbo].[Get_TotalBookingCount]

@IP varchar(50)

AS
BEGIN


select count(IP) as Total
from tblBookMaster where IsBooked= 1 and IP=@IP and convert(varchar(50),inserteddate,103) = convert(varchar(50),GETDATE(),103)

 END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_TotalBookingCount] TO [rt_read]
    AS [dbo];

