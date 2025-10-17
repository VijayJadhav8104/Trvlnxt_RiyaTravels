  
-- =============================================  
-- Author:  <Akash Singh>  
-- Create date: <26/10/2021>  
  
-- =============================================  
CREATE PROCEDURE B2BMakepaymentCommissionById  
 @Id int=0   
   
AS  
BEGIN  
     
 select ModeOfPayment,TotalCommission from B2BMakepaymentCommission where FkBookId=@Id  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[B2BMakepaymentCommissionById] TO [rt_read]
    AS [dbo];

