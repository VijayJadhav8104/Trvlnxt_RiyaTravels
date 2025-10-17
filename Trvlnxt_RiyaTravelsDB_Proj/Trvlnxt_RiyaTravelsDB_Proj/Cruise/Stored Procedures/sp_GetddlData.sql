



--============================================      
-- Author : Sana      
-- Crated Date : 12/05/2022      
-- Description : To get Cruise Sevice/ fee / quotation / gst      
-- Sp_GetCruiseDiscountDetails null, null      
--============================================      
      
      
  
CREATE PROC [Cruise].[sp_GetddlData]  
As     
Begin    
 select ID,Category,[Value] from [Cruise].mCommonCruise  
End

GO
GRANT VIEW DEFINITION
    ON OBJECT::[Cruise].[sp_GetddlData] TO [rt_read]
    AS [DB_TEST];

