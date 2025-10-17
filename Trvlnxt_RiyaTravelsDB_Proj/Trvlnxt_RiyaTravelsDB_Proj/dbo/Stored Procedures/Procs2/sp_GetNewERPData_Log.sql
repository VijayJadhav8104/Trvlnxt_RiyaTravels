CREATE proc [dbo].[sp_GetNewERPData_Log]                          
@list StringList READONLY  
as                                                
BEGIN  
 select FK_tblbookmasterID,Response,Request,Type   
 from NewERPData_Log as ne   
 where FK_tblbookmasterID IN (select [Item] from @list)  
 order by id desc  
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetNewERPData_Log] TO [rt_read]
    AS [dbo];

