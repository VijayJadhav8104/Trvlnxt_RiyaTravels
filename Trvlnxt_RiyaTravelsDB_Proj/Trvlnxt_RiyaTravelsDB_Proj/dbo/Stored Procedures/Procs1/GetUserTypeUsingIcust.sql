  
CREATE procedure GetUserTypeUsingIcust  
@custId varchar(50) = ''  
  
AS       
begin  
  
declare @fkuserid varchar(20)  
  
select @fkuserid = FKUserID From B2BRegistration where CustomerCOde = @custId order by PKID desc  
  
select top 1 userTypeID From agentLogin where UserID in (@fkuserid)  
  
end