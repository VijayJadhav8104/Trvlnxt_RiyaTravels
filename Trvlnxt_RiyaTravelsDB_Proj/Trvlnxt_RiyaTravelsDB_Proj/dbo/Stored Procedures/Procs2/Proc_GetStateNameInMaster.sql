Create Procedure Proc_GetStateNameInMaster  
@StateName varchar(200)  
As  
Begin  
 select id,GSTState from mGSTState Where GSTState like '%'+@StateName+'%'  
End