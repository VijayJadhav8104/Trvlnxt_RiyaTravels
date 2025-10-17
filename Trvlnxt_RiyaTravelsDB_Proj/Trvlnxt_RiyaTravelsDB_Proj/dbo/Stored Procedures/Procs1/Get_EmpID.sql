CREATE proc Get_EmpID--[dbo].[Get_EmpID] '180409'  
@EmployeeNo varchar(10)  
as                    
begin                            
 select [ID] from mUser where EmployeeNo = @EmployeeNo and isActive = 1  
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_EmpID] TO [rt_read]
    AS [dbo];

