-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FetchmVendor]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 SELECT Split.a.value('.', 'VARCHAR(100)')  AS office_Id, A.ID ,  
     Split.a.value('.', 'VARCHAR(100)') +' / '+ vendorname +' / '+ CONVERT(varchar(max),A.ID)  AS officeId  
 FROM  (SELECT  Id, vendorname,
         CAST ('<M>' + REPLACE(officeId, ',', '</M><M>') + '</M>' AS XML) AS String  
     FROM  mVendor where IsActive=1 and IsDeleted=0) AS A CROSS APPLY String.nodes ('/M') AS Split(a);
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchmVendor] TO [rt_read]
    AS [dbo];

