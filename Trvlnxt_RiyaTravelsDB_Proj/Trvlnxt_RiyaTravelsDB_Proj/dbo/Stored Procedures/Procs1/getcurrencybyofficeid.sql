CREATE procedure getcurrencybyofficeid  
@OfficeID varchar(50)  
as  
begin  
  
select Currency from tblOwnerCurrency where OfficeID=@OfficeID  
end  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getcurrencybyofficeid] TO [rt_read]
    AS [dbo];

