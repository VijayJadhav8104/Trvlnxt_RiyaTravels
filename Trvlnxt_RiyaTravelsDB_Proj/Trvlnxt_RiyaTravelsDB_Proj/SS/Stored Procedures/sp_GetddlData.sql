create proc [SS].sp_GetddlData    
As       
Begin      
 select ID,Category,[Value] from [SS].[mCommonSightSeeing]  
End
GO
GRANT VIEW DEFINITION
    ON OBJECT::[SS].[sp_GetddlData] TO [rt_read]
    AS [DB_TEST];

