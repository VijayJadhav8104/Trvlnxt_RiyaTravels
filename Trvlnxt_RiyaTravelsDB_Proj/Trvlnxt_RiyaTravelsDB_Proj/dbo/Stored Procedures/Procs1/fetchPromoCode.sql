
CREATE PROCEDURE [dbo].[fetchPromoCode] 
	-- Add the parameters for the stored procedure here
	@Status char(10)=null,
	@pid int =0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT  [Pk_Id] as Id, A.FullName AS UserName
      ,[AirCode]
      ,[FareType]
       ,[salesFrm_date]
      ,[salesTo_date]
      ,[travelFrm_date]
      ,[travelTo_date]
      ,[Remark]
      ,[insertDate]
      ,SectorIncludeFrom
	  ,SectorIncludeTo,
	  SectorExcludeFrom,
	   SectorExcludeTo,
	  MinFareAmount,Discount,PromoCode,
	  CASE WHEN UserType=0 then 'Registered User' else 'Guest User' end AS UserType,UserType as UserTypeval,
	   CASE WHEN IncludeFlat  =0 then 'No' else 'Yes' end AS IncludeFlat,
	   CASE WHEN IncludeFlat  =0 then 'false' else 'true' end AS IncludeFlatval,
	   CASE WHEN PromoType  =0 then 'Multiple Times' else 'One Time' end AS PromoType,
	   CASE WHEN PromoType  =0 then 'false' else 'true' end AS PromoTypeval,
      ModifiedBy
	  ,b.fullname as ModifiedName,
ISNULL(REPLACE(CONVERT(varchar(11), modifiedDate, 106),' ','-'),'NA') as modifiedDate
	  ,case when PromoCode.IsActive=1 then 'Active' when PromoCode.IsActive=0 then 'Deactive' else '' end as [status],
	  GST
  FROM [dbo].PromoCode
  JOIN adminMaster A ON A.ID = PromoCode.userID
  left JOIN adminMaster B ON B.ID = PromoCode.ModifiedBy
  WHERE  (PromoCode.IsActive=@Status or @Status is null)
		AND (Pk_Id = @pid or @pid=0)
		order by AirCode
  
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchPromoCode] TO [rt_read]
    AS [dbo];

