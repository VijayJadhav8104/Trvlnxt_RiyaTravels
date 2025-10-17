-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetmFareType] 
	-- Add the parameters for the stored procedure here
	@Country varchar(20),
	@Airline varchar(max),
	@AirportType varchar(20),
	@UserType varchar(20),
	@AgencyName varchar(max),
	@LoginIds varchar(max),
	@CabinIds varchar(max),
	@InFareIds varchar(max),
	@Status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT mft.[ID]
	,[UserType]
	,[Country]
	,[Airline]
	,[LoginId]
	,[AirportType]
	,[AgencyId]
	,[AgencyName]
	--,[Cabin]
	--,[IncludeFare]
	,[ExcludeFare]
	,[Origin]
	,[OriginValue]
	,[Destination]
	,[DestinationValue]
	,[RBD]
	,[RBDValue]
	,[TravelValidityFrom]
	,[TravelValidityTo]
	,[SaleValidityFrom]
	,[SaleValidityTo]
	,[Blocked]
	,[CreatedOn]
	,[CreatedBy]
	,[ModifiedBy]
	,[ModifiedOn]
	,[IsActive],
	case when mft.Cabin='ALL' then 'ALL' else (select stuff((select ',' + com.Value from mCommon AS com where Category='classtype'
	and PATINDEX('%,'+convert(varchar,com.ID)+',%',','+mft.Cabin+',')>0
	for xml path('')),1,1,'')) end as Cabin,
	case when mft.IncludeFare='ALL' then 'ALL' else (select stuff((select ',' + tft.FareType from tblFareType tft 
	where PATINDEX('%,'+convert(varchar,tft.ID)+',%',','+mft.IncludeFare+',')>0
	for xml path('')),1,1,'')) end as IncludeFare

	FROM mFareType AS mft
	--LEFT JOIN mCommon AS com ON com.ID in (SELECT Data FROM sample_split(mft.Cabin, ','))  AND Category='ClassType'
	--LEFT JOIN tblFareType AS tft ON tft.ID in (SELECT Data FROM sample_split(mft.IncludeFare, ','))
	WHERE ((@Country = '') or (Country=@Country))
	--((@Airline = '') or (Airline=@Airline)) and
	AND ((@Airline = '') or (Airline in (SELECT Data FROM sample_split(@Airline, ','))))
	AND ((@AirportType = '') or (AirportType=@AirportType))
	AND ((@UserType = '') or (UserType=@UserType))
	AND ((@AgencyName = '') or (AgencyName=@AgencyName)) 
	AND ((@LoginIds = '') or (LoginId in (SELECT Data FROM sample_split(@LoginIds, ','))))
	AND ((@CabinIds = '') or (mft.Cabin in (SELECT Data FROM sample_split(@CabinIds, ','))))
	AND ((@InFareIds = '') or (mft.IncludeFare in (SELECT Data FROM sample_split(@InFareIds, ','))))
	AND mft.IsActive=@Status
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetmFareType] TO [rt_read]
    AS [dbo];

