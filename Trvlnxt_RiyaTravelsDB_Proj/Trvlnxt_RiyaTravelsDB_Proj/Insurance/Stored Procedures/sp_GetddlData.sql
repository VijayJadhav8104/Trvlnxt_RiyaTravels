CREATE PROCEDURE [Insurance].[sp_GetddlData]    
As       
Begin      
 select ID,Category,[Value] from [Insurance].mCommonInsurance  where Category!='UserType'  
  
 union all   
  
 select ID,Category,[Value] from dbo.mCommon where Category='UserType'  
  
End