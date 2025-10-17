


CREATE proc Hotel.getAgentCurrency
@Country varchar(200)='' 
as
begin

select Currency from  HotelContryCurrency WHERE Country=@Country
end