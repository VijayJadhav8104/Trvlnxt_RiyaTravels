-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- execute ss.SS_GetAllSupplierAgentOnMaped 51354  
-- =============================================  
CREATE PROCEDURE [SS].[SS_GetAllSupplierAgentOnMaped]  
 -- Add the parameters for the stored procedure here  
 @AgentId int=0   
  
AS  
BEGIN  
   
 Declare @AgentPkID int=0;  
 set @AgentPkID = (select PKID from B2BRegistration where FKUserID=@AgentId)  
  
 select SP.SupplierId,  
        SP.AgentId,  
        SP.IsActive,  
     HS.SupplierName,  
     HS.Username,  
     HS.[Password],
	 HS.RhSupplierId
   
 from AgentSupplierProfileMapper SP  
 inner join B2BHotelSupplierMaster HS on SP.SupplierId=HS.Id  
 where SP.AgentId =  @AgentPkID and SP.IsActive=1 and HS.IsActive=1  
	and SupplierType = 'Activity'
  
END  
