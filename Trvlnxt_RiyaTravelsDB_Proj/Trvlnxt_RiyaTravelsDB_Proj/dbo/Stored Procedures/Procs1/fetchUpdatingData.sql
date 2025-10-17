
CREATE PROCEDURE [dbo].[fetchUpdatingData] 
	-- Add the parameters for the stored procedure here
	@Status varchar(max)=null,
	@pid int =0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT  [Pk_Id] as Id, A.FullName AS UserName
      ,[AirCode]
      ,[FareType]
      ,[Iata_Percent]
      ,IsIATAOnBasic
      ,[Econ_PLB]
      ,[Prem_PLB]
      ,[Busn_PLB]
      ,[First_PLB]
      ,IsPLBOnBasic
      ,[salesFrm_date]
      ,[salesTo_date]
      ,[travelFrm_date]
      ,[travelTo_date]
      ,[Issue_PCC]
      ,[Remark]
      ,[insertDate]
      ,[userID]
      ,[tour_code]
	  ,ModifiedBy
	 
	  ,b.fullname as ModifiedName
	  ,FlatDiscount
	--  ,	  [Exclude_On]
	  
	  ,Rbd_exc_PLB
           ,[Soto_exc_PLB]
           ,[Sector_exc_PLB]
		   ,Rbd_exc_IATA
           ,[Soto_exc_IATA]
           ,[Sector_exc_IATA],
ISNULL(REPLACE(CONVERT(varchar(11), modifiedDate, 106),' ','-'),'NA') as modifiedDate
	  ,case when [DiscountMaster].IsActive='A' then 'Active' when [DiscountMaster].IsActive='D' then 'Deactive' else '' end as [status]
	  ,case when [DiscountMaster].CommissionType=0 then 'Per Pax' when [DiscountMaster].CommissionType=1 then 'Per Sector' else '' end as  CommissionType
  FROM [dbo].[DiscountMaster]
  JOIN adminMaster A ON A.ID = [DiscountMaster].userID
  left JOIN adminMaster B ON B.ID = [DiscountMaster].ModifiedBy
  WHERE  ([DiscountMaster].IsActive=@Status or @Status is null)
		AND (Pk_Id = @pid or @pid=0)

  
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchUpdatingData] TO [rt_read]
    AS [dbo];

