
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[fetchairport] 
	-- Add the parameters for the stored procedure here
	@Status varchar(max)=null,
	@pid int =0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  [City_Name]
      ,[airport_name]+','+[City_Name] as [airport_name],[airpoty_code] from Marine_City 

	  select  [Airport Name] , [Itinerary Type] , [Code] from sectors 

	  select [airline],[domesticcomision],[intcommision] from [dbo].[Comission]

	  SELECT  [_CODE],[_NAME] from [dbo].[AirlinesName]

	  SELECT  [Pk_Id] as Id, A.FullName AS UserName,[amount],[AirCode],[insert_date], ChargeType,[userId]
		, ISNULL(REPLACE(CONVERT(varchar(11), modifiedDate, 106),' ','-'),'NA') as modifiedDate
		,case when [markUpMaster].status='A' then 'Active' when [markUpMaster].status='D' then 'Deactive' else '' end as [status]
	  FROM markUpMaster
	  JOIN adminMaster A ON A.ID = [markUpMaster].userID
	  WHERE  [markUpMaster].status=@Status or @Status is null AND (Pk_Id = @pid or @pid=0)

END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchairport] TO [rt_read]
    AS [dbo];

