CREATE proc CheckCrossBorderOfficeID --'dfw' ,'us'
@cityCode varchar(3),
@CountryCode varchar(3)

As
BEGIN

declare @name varchar(50)	
select  @name= NAME from tblAirportCity where CODE=@cityCode and COUNTRY=@CountryCode

select  @name
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CheckCrossBorderOfficeID] TO [rt_read]
    AS [dbo];

