

CREATE PROCEDURE [dbo].[fetchTaxData]
	-- Add the parameters for the stored procedure here
	@Status varchar(max)=null,
	@pid int =0
AS
BEGIN

SELECT  [Pk_Id] as Id, A.FullName AS UserName
      ,[TaxType]
      ,[taxPercent]
      ,[insert_date]
      ,[userId]
     , ISNULL(REPLACE(CONVERT(varchar(11), modifiedDate, 106),' ','-'),'NA') as modifiedDate
	  ,case when [Taxdetails].status='A' then 'Active' when [Taxdetails].status='D' then 'Deactive' else '' end as [status]
  FROM [Taxdetails]
   JOIN adminMaster A ON A.ID = [Taxdetails].userID
  WHERE  [Taxdetails].status=@Status or @Status is null
   AND (Pk_Id = @pid or @pid=0)
  END

  
  select * from adminMaster
  select * from [Taxdetails]







GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchTaxData] TO [rt_read]
    AS [dbo];

