
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[fetchMarkupData]
	-- Add the parameters for the stored procedure here
		@Status varchar(max)=null,
		@pid int =0
AS
BEGIN
 SELECT  [Pk_Id] as Id, A.FullName AS UserName,[amount]
      ,[AirCode]
      
      ,[insert_date], ChargeType
      ,[userId]
    , ISNULL(REPLACE(CONVERT(varchar(11), modifiedDate, 106),' ','-'),'NA') as modifiedDate
	  ,case when [markUpMaster].status='A' then 'Active' when [markUpMaster].status='D' then 'Deactive' else '' end as [status]
  FROM markUpMaster
   JOIN adminMaster A ON A.ID = [markUpMaster].userID
   WHERE  [markUpMaster].status=@Status or @Status is null
   AND (Pk_Id = @pid or @pid=0)
END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchMarkupData] TO [rt_read]
    AS [dbo];

