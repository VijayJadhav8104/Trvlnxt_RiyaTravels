-- =============================================
-- Author:		<Jishaan>
-- Create date: <28-02-2023>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SSRPushUpdate]
@erpticketnum varchar(100),
@action varchar(100),
@ERPRequest varchar(MAX),
@ERPResponse varchar(MAX),
@responseId varchar(MAX),
@error varchar(50)
AS
BEGIN
if(@action = 'Booking')
BEGIN
if(@error = 'CreateWOIns')
begin
	update tblSSRDetails set SSR_Request = @ERPRequest, SSR_Response = @ERPResponse, ERPPushStatus = 1, ERPResponseID = @responseId where ERPTicketNum = @erpticketnum
	end
Else
	begin
	update tblSSRDetails set SSR_Request = @ERPRequest, SSR_Response = @ERPResponse, ERPPushStatus = 0, ERPResponseID = @responseId where ERPTicketNum = @erpticketnum
	End
END
if(@action = 'Cancellation')
BEGIN
if(@error = 'CreateWOIns')
begin
	update tblSSRDetails set SSR_CanRequest = @ERPRequest, SSR_CanResponse = @ERPResponse, CancERPPuststatus = 1, CancERPResponseID = @responseId where ERPTicketNum = @erpticketnum
	end
Else
	begin
	update tblSSRDetails set SSR_Request = @ERPRequest, SSR_Response = @ERPResponse, ERPPushStatus = 0, CancERPResponseID = @responseId where ERPTicketNum = @erpticketnum
	End
END
END
