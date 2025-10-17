CREATE PROCEDURE [dbo].[GetFlightSearchBindData] --'D','BOMI228DS'
@Sector varchar(5) = NULL, 
@OfficeId varchar(20) = NULL,
@CompanyName varchar(10) = Null AS 
BEGIN
   SELECT
       NAME,
      SEARCHNAME,
      CODE,
      Country,
      UTC 
   from
      tblAirportCity 
   WHERE
      NAME LIKE '%]%';
SELECT
    [_CODE] AS Code,
   [_NAME] AS Name 
from
   [dbo].[AirlinesName];
--select Carrier,Sector,ProductClass,OtherConditions AS OtherConditions, OtherConditionsM from FareRule
select
   AirLine as Carrier,
   Sector,
   ProductClass,
   OtherCondition as OtherConditions,
   CancellationFee,
   ReschedullingFee,
   usertype,
   country 
from
   farerule 
where
   Status = 1 
   DECLARE @Country VARCHAR(2) 
SET
   @Country = 
   (
      SELECT
         TOP 1 CountryCode  FROM tblAmadeusOfficeID 
      WHERE
         OfficeID = @OfficeId
   )
   SELECT
      AIRLINE,
      CASE
         WHEN
            @Sector = 'D' 
         THEN
            domesticcomision 
         WHEN
            @Sector = 'I' 
         THEN
            intcommision 
      END
      AS [Percent]  FROM Comission 
   WHERE
      Country = @Country 
  SELECT
        distinct s.Airlinecode,a.type,
         Airlinename 
      FROM
         TblSTSAirLineMaster s
		 inner join AirlineCode_Console a on a.AirlineCode=s.AirlineCode
      where
         status = 1 
         and CompanyName = @CompanyName 
         select
            commoncode,
            code 
         from
            iatacode 
            SELECT
               * 
            FROM
               tblAmadeusOfficeID 
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetFlightSearchBindData] TO [rt_read]
    AS [dbo];

