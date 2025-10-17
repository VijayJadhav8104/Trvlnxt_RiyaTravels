CREATE PROC [dbo].[GetFareRuleLCC]
@Country varchar(50),
@VendorName varchar(50),
@OfficeId varchar(50),
@FareName varchar(50),
@UserType varchar(50),
@Cabin varchar(50)='',
@Sector varchar(50)=''
AS
BEGIN

  DECLARE @LocalCabin varchar(50);

  SET @LocalCabin = @Cabin;

  IF (@LocalCabin = 'Bussiness')
  BEGIN
     SET @LocalCabin = 'Business';
  END
 DECLARE @Cabinid varchar(50)=''                    
        
 SELECT @Cabinid = CONVERT(VARCHAR, ID) FROM mCommon WHERE Value=@LocalCabin

select  FareRule AS FareRuleInfo,OriginValue,DestinationValue,Origin,Destination from mFareRule
    where (Country = @Country or Country ='All')
    and VendorName = @VendorName
    and Officeid like '%' + @OfficeId + '%'
    and FareName =@FareName
	and UserType=@UserType
	and Cabin IN (SELECT Data FROM sample_split((@Cabinid), ','))  
	and (AirportType=@Sector or AirportType='B')
    and IsActive = 1
	 and IsDelete = 0
END