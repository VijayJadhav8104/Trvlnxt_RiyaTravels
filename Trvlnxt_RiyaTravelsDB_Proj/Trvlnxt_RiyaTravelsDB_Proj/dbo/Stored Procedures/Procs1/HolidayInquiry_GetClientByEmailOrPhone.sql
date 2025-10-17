-- =============================================
-- Author:		<Aditya Joshi>
-- Create date: <15/10/2024>
-- Description:	Procedure to get client details
-- =============================================
CREATE PROCEDURE [dbo].[HolidayInquiry_GetClientByEmailOrPhone] 
    @Email NVARCHAR(150) = NULL,
    @PhoneNumber NVARCHAR(15) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1 
        ClientFirstName,
        ClientLastName,
		ClientMobile,
		ClientEmail
    FROM HolidayInquiry
    WHERE QueryType='Walk-in'
	AND (@Email IS NULL OR ClientEmail = @Email)
    OR (@PhoneNumber IS NULL OR ClientMobile = @PhoneNumber)
	Order by InquiryDateTime desc
END