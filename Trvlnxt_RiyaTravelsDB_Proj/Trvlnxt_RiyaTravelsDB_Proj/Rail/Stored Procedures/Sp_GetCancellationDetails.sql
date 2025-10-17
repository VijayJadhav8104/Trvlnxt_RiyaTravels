--============================================          
-- Author : Sana          
-- Crated Date : 12/05/2022          
-- Description : To get Cruise Cancellation         
-- Sp_GetCancellationDetails null, null          
--============================================          
          
          
CREATE proc [Rail].[Sp_GetCancellationDetails]         
AS          
BEGIN           
 select           
 Pkid,Policy,ChargesType,Cancellation_charges,Cancellation_Hours,CreatedDate,CD.IsActive,AgentId,SupplierId,Fromdate,ToDate,CD.ServiceType,MU.UserName as 'CreatedBy'       
 from [Rail].[tbl_Cancellation]  CD        
 left join mUser MU on Mu.ID=CD.CreatedBy        
 --where          
 -- (CD.UserType = @UserType or @UserType='' or @UserType=null ) and           
 -- (CD.MarketPoint = @MarketPoint or @MarketPoint='' or @MarketPoint=null )          
END 
