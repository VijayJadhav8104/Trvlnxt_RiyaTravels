

CREATE PROCEDURE [dbo].[fetchServiceCharges]
	-- Add the parameters for the stored procedure here
		@Status varchar(max)=null,
		@pid int =0,
		@ServiceChargeType int =null
AS
BEGIN
 SELECT  [PkId] as Id, A.FullName AS UserName,[amount]
      ,[AirCode]
      ,[insert_date]
	  ,[SectorType]
      ,[UserId]
    , ISNULL(REPLACE(CONVERT(varchar(11), modifiedDate, 106),' ','-'),'NA') as modifiedDate
	  ,case when [ServiceCharges].[IsActive]=1 then 'Active' when [ServiceCharges].[IsActive]=0 then 'Deactive' else '' end as [status]
	  ,case when [ServiceCharges].ServiceChargeType=0 then 'Per Pax' when [ServiceCharges].ServiceChargeType=1 then 'Per Booking' else '' end as  ServiceChargeType 
  FROM [ServiceCharges]
   JOIN adminMaster A ON A.ID = [ServiceCharges].[UserId]
   WHERE  [ServiceCharges].[IsActive]=@Status or @Status is null
   AND (PkId = @pid or @pid=0)
END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchServiceCharges] TO [rt_read]
    AS [dbo];

