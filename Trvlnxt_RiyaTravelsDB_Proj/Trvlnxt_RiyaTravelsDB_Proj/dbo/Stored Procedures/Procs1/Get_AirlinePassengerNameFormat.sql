

CREATE procedure [dbo].[Get_AirlinePassengerNameFormat] 

@AirlineCode varchar(10)

as
begin

SELECT AirlineCode,AirlineName,FirstName,LastName,Remarks
FROM [dbo].[AirlinePassengerNameFormat]
where AirlineCode = @AirlineCode

end

