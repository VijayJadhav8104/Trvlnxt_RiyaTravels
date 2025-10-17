CREATE procedure [dbo].[Sp_UpdateAirlineStartDateCreditday]
@AirlineStartDate nvarchar(100)=null,
@CreditDay int=null,
@AgnecyID int=null
as
begin
update B2BRegistration set AirlineStartDate=@AirlineStartDate, AirlineCreditday=@CreditDay
where FKUserID=@AgnecyID
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_UpdateAirlineStartDateCreditday] TO [rt_read]
    AS [dbo];

