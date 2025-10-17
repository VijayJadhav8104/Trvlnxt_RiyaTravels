

CREATE PROCEDURE [dbo].[InsertUSCATracker]
@Country  VARCHAR(2), 
@IP  VARCHAR(50), 
@Device  VARCHAR(50),
@RequestDate DateTime=null, 
@AdditionalInfo varchar(max)

AS
BEGIN
		
insert into USCATracker
(Country, IP, Device, RequestDate, AdditionalInfo)
values(@Country, @IP, @Device, @RequestDate, @AdditionalInfo)
		
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertUSCATracker] TO [rt_read]
    AS [dbo];

