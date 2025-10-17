
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[fetchCancellationData]
	-- Add the parameters for the stored procedure here
		@Status varchar(max)=null,
		@pid int =0,
		@CancellationChargeType int=null
AS
BEGIN
 SELECT  [Pk_Id] as Id, A.FullName AS UserName
      ,[AirCode]
      ,[amount]
      ,[insert_date]
      ,[userId]
    , ISNULL(REPLACE(CONVERT(varchar(11), modifiedDate, 106),' ','-'),'NA') as modifiedDate
	  ,case when [CancellationCharges].status='A' then 'Active' when [CancellationCharges].status='D' then 'Deactive' else '' end as [status]
	  ,case when [CancellationCharges].CancellationChargeType=0 then 'Per Pax' when [CancellationCharges].CancellationChargeType=1 then 'Per Sector' else '' end as  CancellationChargeType 

  FROM [dbo].[CancellationCharges]
   JOIN adminMaster A ON A.ID = [CancellationCharges].userID
   WHERE  [CancellationCharges].status=@Status or @Status is null	
    AND (Pk_Id = @pid or @pid=0)
END










GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchCancellationData] TO [rt_read]
    AS [dbo];

