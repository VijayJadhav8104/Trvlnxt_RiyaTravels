        
CREATE procedure FetchSTSLoginDetails        
@BussinessType varchar(20)      ,
@AgentId varchar(50)=''
        
As         
begin        
if @BussinessType='B2B'
begin
select * from STSLoginDetails where UserType=@BussinessType and CustomersId like '%' + @AgentId + '%'   and IsActive=1
end
else if @BussinessType !='B2B'
begin 
select * from STSLoginDetails where UserType=@BussinessType and IsActive=1
end
end