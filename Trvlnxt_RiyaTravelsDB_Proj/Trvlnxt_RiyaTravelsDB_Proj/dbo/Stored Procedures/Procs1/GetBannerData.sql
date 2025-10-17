-- =============================================
-- Author:		Bansi
-- Create date: 29.01.2024
-- Description:	Get All
-- =============================================

--exec GetBannerData '1,2,3,5,192','IN,US,CA,AE,UK','ALL','Flights'
--exec GetBannerData '2','IN','ALL','Flights'
CREATE PROCEDURE [dbo].[GetBannerData]
	@UserType Varchar(50),
	@Country Varchar(50),
	@AgencyId Varchar(50),
	@Product Varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	IF(@AgencyId ='ALL')
    
		BEGIN
		CREATE  TABLE #tmp(ID INT);
		insert into #tmp(ID)(SELECT  ID FROM mBanner WHERE
	                         (UserType  IN  ( select Data from sample_split(@UserType,','))) 
							 AND (Country  IN ( select Data from sample_split(@Country,',')))
							-- AND (@AgencyId IN(select Data from sample_split(AgencyId,',')))
							 AND IsRiyaStaff='1'
							 AND Product=@Product 
							 AND FromDateTime <= GETDATE() 
							 AND ToDateTime >= GETDATE()
							 AND IsActive=1)

		SELECT DISTINCT ImageName, ImageByte,CotentType,URL FROM mBannerImages where BannerId IN (select ID from #tmp) AND IsActive=1

		DROP TABLE  #tmp
		END

	ELSE
		BEGIN
		DECLARE @Agency Varchar(20) = ''
	SELECT TOP 1 @Agency = AgencyId FROM  mBanner WHERE (@AgencyId IN(select Data from sample_split(AgencyId,',')) and IsActive=1)
		
	if(@Agency != '')
	BEGIN
	CREATE  TABLE #tmp2(ID INT);
	insert into #tmp2(ID)(SELECT  ID FROM mBanner WHERE
	                        (UserType  IN  ( select Data from sample_split(@UserType,','))) 
							AND (Country  IN ( select Data from sample_split(@Country,',')))
							AND (@AgencyId IN(select Data from sample_split(AgencyId,','))  )
							AND Product=@Product 
							AND FromDateTime <= GETDATE() 
							AND ToDateTime >= GETDATE()
							AND IsActive=1)

	SELECT DISTINCT ImageName,ImageByte,CotentType,IsActive, URL FROM mBannerImages where BannerId IN (select ID from #tmp2)
	                AND IsActive=1

	DROP TABLE  #tmp2
	END

	ELSE
	BEGIN
	CREATE  TABLE #tmp3(ID INT);
	insert into #tmp3(ID)(SELECT  ID FROM mBanner WHERE
	                        (UserType  IN  ( select Data from sample_split(@UserType,','))) 
							AND (Country  IN ( select Data from sample_split(@Country,',')))
							AND (AgencyId='All')
							AND Product=@Product 
							AND FromDateTime <= GETDATE() 
							AND ToDateTime >= GETDATE()
							AND IsActive=1)

	SELECT DISTINCT ImageName,ImageByte,CotentType,IsActive,URL FROM mBannerImages where BannerId IN (select ID from #tmp3) AND IsActive=1

	DROP TABLE  #tmp3
	END
	END
	
END