  
  
  
CREATE proc Hotel.UpdateSupplierErrorMapping_Console  
  
@Id int=0,  
@UpdareMsg varchar(max)='',  
@UserId int=0  
as  
  
begin  
  
  
update Hotel.SupplierErrorMapping set ActualErrorMessage=@UpdareMsg, UpdatedBy=@UserId , UpdatedDate=GETDATE() where Id=@Id  
  
end