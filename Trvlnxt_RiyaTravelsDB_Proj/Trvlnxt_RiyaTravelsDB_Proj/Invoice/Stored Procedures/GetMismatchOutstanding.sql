-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[GetMismatchOutstanding]
	
AS
BEGIN
	
	SELECT Icast AS Code,Outstanding,Closing FROM Invoice.Outstanding_WY wy
	JOIN B2BRegistration b2b ON wy.Code = b2b.FKUserID
	WHERE Outstanding <> Closing

END
