-- =============================================              
-- Author:  <Author,,Name>              
-- Create date: <Create Date,,>              
-- Description: <Description,,>              
-- =============================================              
CREATE PROCEDURE [dbo].[USPGetMarinePromodetails] -- 1154,'SG'        
@AgentId VARCHAR(10)  ,        
@Carrier varchar(10)    ,    
@OfficeId varchar(50)    
AS              
BEGIN             
if(@OfficeId='corponline')    
begin     
    
 if exists(SELECT TOP 1 *  FROM tbl_marinepromodetails               
 WHERE OfficeId=@OfficeId AND Carrier=@Carrier AND IsActive=1 AND AgentID like '%' + @AgentID + '%')      
 begin      
  SELECT TOP 1 MarinePromoCode as PromoCode FROM tbl_marinepromodetails    
  WHERE OfficeId=@OfficeId AND Carrier=@Carrier AND IsActive=1 AND AgentID like '%' + @AgentID + '%'      
 end      
 else      
  SELECT TOP 1 MarinePromoCode as PromoCode FROM tbl_marinepromodetails    
  WHERE OfficeId=@OfficeId AND Carrier=@Carrier AND IsActive=1 AND AgentID ='0'         
end    
if(@OfficeId='BOMCI3FE')    
begin     
    
 if exists(SELECT TOP 1 *  FROM tbl_marinepromodetails               
 WHERE OfficeId=@OfficeId AND Carrier=@Carrier AND IsActive=1 AND AgentID like '%' + @AgentID + '%')      
 begin      
  SELECT TOP 1 MarinePromoCode as PromoCode FROM tbl_marinepromodetails    
  WHERE OfficeId=@OfficeId AND Carrier=@Carrier AND IsActive=1 AND AgentID like '%' + @AgentID + '%'      
 end      
 end  
else     
begin    
   IF EXISTS (SELECT * FROM tbl_marinepromodetails where IsActive=1 and AgencyCustID=(select top 1 CustomerCOde from B2BRegistration where FKUserID=@AgentId)  and Carrier=@Carrier)          
 BEGIN            
  SELECT TOP 1 MarinePromoCode as PromoCode FROM tbl_marinepromodetails           
  WHERE IsActive=1 and AgencyCustID=(SELECT TOP 1 CustomerCOde FROM B2BRegistration WHERE FKUserID=@AgentId) and Carrier=@Carrier          
 END          
 ELSE           
 BEGIN           
  SELECT TOP 1 MarinePromoCode as PromoCode FROM tbl_marinepromodetails WHERE IsActive=1 and AgencyCustID='ALL'  and Carrier=@Carrier        
 END          
END    
end    
     
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USPGetMarinePromodetails] TO [rt_read]
    AS [dbo];

