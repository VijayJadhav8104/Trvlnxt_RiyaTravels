-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE GetAgentWiseCommand   
 @CompanyName varchar(10)=null,  
 @OfficeId varchar(20)=null,  
 @AgentId varchar(10)=null  
AS  
BEGIN  
 select * from tblCrypticCommandAgentWise   
 where OfficeId=@OfficeId   
 and CompanyName=@CompanyName   
 and AgentID=@AgentId  
END  