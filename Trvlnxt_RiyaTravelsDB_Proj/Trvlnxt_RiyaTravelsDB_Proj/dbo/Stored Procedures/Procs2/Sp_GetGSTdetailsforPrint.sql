









CREATE procedure Sp_GetGSTdetailsforPrint
@orderidnew nvarchar(50)
as
begin

select 
RegistrationNumber,	
CompanyName,
CAddress,
CState,
CContactNo,
CEmailID

 from tblBookMaster 
where orderId=@orderidnew

end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetGSTdetailsforPrint] TO [rt_read]
    AS [dbo];

