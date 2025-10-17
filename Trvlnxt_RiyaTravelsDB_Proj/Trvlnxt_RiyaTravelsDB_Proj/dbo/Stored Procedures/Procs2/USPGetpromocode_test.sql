-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  USPGetpromocode_test --'INTDXBA122','del','bom','2021-08-23 18:54:19.927','2021-08-23 18:54:19.927'
@OfficeId varchar(50),
@fromSector varchar(50),
@ToSector varchar(50),
@TrvlFrom date,
@Carrier varchar(20)
AS
BEGIN
	--DECLARE
	--if (SELECT count(*) FROM sectors s INNER JOIN tblPromoCode_trvlnxt t ON t.SectorExFrom=s.[Country Code] 
	--WHERE t.OfficeId=@OfficeId AND (s.Code=@fromSector or s.Code=@ToSector))=1
	if exists (SELECT * FROM sectors s INNER JOIN tblPromoCode_trvlnxt t ON t.SectorExFrom=s.[Country Code] 
	WHERE t.OfficeId=@OfficeId AND (s.Code=@fromSector))
	BEGIN
		SELECT * FROM tblPromoCode_trvlnxt 
		WHERE Salesfrom<=GETDATE() AND SalesTo>=GETDATE()
		AND TrvlFrom<=@TrvlFrom AND TrvlTo>=@TrvlFrom 
		AND OfficeId=@OfficeId  AND IsActive=1 and Carrier=@Carrier
		select * from tblBlockedAirlinePromoCode WHERE FromSector=@fromSector AND ToSector=@ToSector 
	 END
	-- else begin
	-- select 1 end
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USPGetpromocode_test] TO [rt_read]
    AS [dbo];

