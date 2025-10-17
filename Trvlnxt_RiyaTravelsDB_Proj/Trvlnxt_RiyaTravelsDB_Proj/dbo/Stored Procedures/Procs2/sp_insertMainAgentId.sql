-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
Create PROCEDURE [dbo].[sp_insertMainAgentId]  
 @id int = null,  
 @GDSPNR varchar(50) = null,  
 @officeId varchar(50) = null,  
 @ticketNum varchar(50) = null,  
 @mainAgentId varchar(50)  
AS  
BEGIN  
 IF (@id > 0) 
  update PNRRetrivalFromAudit set MainAgentId = @mainAgentId where Id = @id;  
 ELSE  
  update PNRRetrivalFromAudit set MainAgentId = @mainAgentId where Id = dbo.GetPNRRetrivalId(@GDSPNR,@ticketNum,@officeId);  
END  
  