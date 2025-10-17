CREATE proc [dbo].[GetList_Airlinelist]

@Airline varchar(50)

as
begin


select * from  TblSTSAirLineMaster where (AirlineCode=@Airline OR AirlineCode1=@Airline )and Status=1

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_Airlinelist] TO [rt_read]
    AS [dbo];

