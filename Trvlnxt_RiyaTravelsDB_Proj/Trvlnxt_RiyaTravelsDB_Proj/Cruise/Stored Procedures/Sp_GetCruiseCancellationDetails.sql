
--============================================            
-- Author : Sana            
-- Crated Date : 12/05/2022            
-- Description : To get Cruise Cancellation           
-- Sp_GetCruiseFlatDetails null, null            
--============================================            
            
            
CREATE PROC [Cruise].[Sp_GetCruiseCancellationDetails]           
AS            
BEGIN             
 select             
 Pkid,Policy,ChargesType,Cancellation_charges,Cancellation_Hours,CreatedDate,CD.IsActive,SupplierId,Fromdate,ToDate,CD.ServiceType,MU.UserName as 'CreatedBy'         
 from [Cruise].tblCruise_Cancellation  CD          
 left join mUser MU on Mu.ID=CD.CreatedBy          
 --where            
 -- (CD.UserType = @UserType or @UserType='' or @UserType=null ) and             
 -- (CD.MarketPoint = @MarketPoint or @MarketPoint='' or @MarketPoint=null )            
END 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[Cruise].[Sp_GetCruiseCancellationDetails] TO [rt_read]
    AS [DB_TEST];

