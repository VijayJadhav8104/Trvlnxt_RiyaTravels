-- =============================================  
-- Author:  <Jishaan>  
-- Create date: <28-02-2023>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[sp_SSRPushUpdate1]  
@erpticketnum varchar(100),
@emdticketnum varchar(100),
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
 IF (@erpticketnum IS NOT NULL AND @erpticketnum <> '')
BEGIN
    UPDATE tblSSRDetails
    SET 
        SSR_Request = @ERPRequest,
        SSR_Response = @ERPResponse,
        ERPPushStatus = 1,
        ERPResponseID = @responseId
    WHERE ERPTicketNum = @erpticketnum;
END
ELSE IF (@emdticketnum IS NOT NULL AND @emdticketnum <> '')
BEGIN
    -- Fallback to EMDTicketNumber if ERPTicketNum is blank
    UPDATE tblSSRDetails
    SET 
        SSR_Request = @ERPRequest,
        SSR_Response = @ERPResponse,
        ERPPushStatus = 1,
        ERPResponseID = @responseId
    WHERE EMDTicketNumber = @emdticketnum;
END
 end  
Else  
 begin  
 IF (@erpticketnum IS NOT NULL AND @erpticketnum <> '')
BEGIN
    UPDATE tblSSRDetails
    SET 
        SSR_Request = @ERPRequest,
        SSR_Response = @ERPResponse,
        ERPPushStatus = 0,
        ERPResponseID = @responseId
    WHERE ERPTicketNum = @erpticketnum;
END
ELSE IF (@emdticketnum IS NOT NULL AND @emdticketnum <> '')
BEGIN
    -- Fallback update based on EMDTicketNumber if ERPTicketNum is blank
    UPDATE tblSSRDetails
    SET 
        SSR_Request = @ERPRequest,
        SSR_Response = @ERPResponse,
        ERPPushStatus = 0,
        ERPResponseID = @responseId
    WHERE EMDTicketNumber = @emdticketnum;
END
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