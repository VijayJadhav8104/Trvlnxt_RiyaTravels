
create procedure [dbo].[GetContractCommissionValueFromMUser]  
@userId int,
@isUserTypeValue int
as  
  
begin  
  if @isUserTypeValue=0
  begin
     select ISNULL(ContractCommission,0) as 'ContractCommission'  from mUser where ID=@userId
  end
  else 
  begin
	  select Value,ID from mCommon where  ID in(select UserTypeId from mUserTypeMapping where UserId=@userId) and Category='UserType'
  end
    
end  