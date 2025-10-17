-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec GetSalesPersonEmail '50076'
CREATE PROCEDURE [dbo].[GetSalesPersonEmail]
    @FKUserID INT
AS
BEGIN

    DECLARE @SalesPersonId varchar(50)

    SELECT @SalesPersonId = SalesPersonId
    FROM B2BRegistration
    WHERE FKUserID = @FKUserID
    
    SELECT TOP 1 EmailID FROM mUser
    WHERE EmployeeNo = @SalesPersonId 
END
