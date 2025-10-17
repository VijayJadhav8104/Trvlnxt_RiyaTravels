CREATE proc ER.sp_GetddlData  
As     
Begin    
 select ID,Category,[Value] from [ER].[mCommonER] 
End
GO
GRANT VIEW DEFINITION
    ON OBJECT::[ER].[sp_GetddlData] TO [rt_read]
    AS [RiyaTravels];

