
CREATE proc Sp_GetMealDetails
@Flag varchar(50)=null,
@Id int=null,
@Meal varchar(100)=null,
@CreatedBy nvarchar(50)=null,
@ModifiedBy nvarchar(50)=null
AS
BEGIN
 if(@Flag='Get')
 BEGIN
  select RiyaMeal_Id,Meal,MU.UserName as 'UserName', CreatedDate as 'Date' from Riya_Meal RM left join mUser MU on mu.id=rm.CreatedBy where RM.IsActive=1
  
  select VendorMeal_Id,Meal,MU.UserName as 'UserName', CreatedDate as 'Date' from Vendor_meal VM left join mUser MU on mu.id=VM.CreatedBy where VM.IsActive=1
  END
 if(@Flag='InsertRiyaMeal')
 BEGIN
	Insert into Riya_Meal(Meal,CreatedBy,IsActive,CreatedDate) values (@Meal,@CreatedBy,1,GETDATE())  
 END

 if(@Flag='InsertVendorMeal')
 BEGIN
	Insert into Vendor_Meal(Meal,CreatedBy,IsActive,CreatedDate) values (@Meal,@CreatedBy,1,GETDATE())  
  
 END

  if(@Flag='UpdateRiyaMeal')
 BEGIN
    update Riya_Meal set Meal=@Meal, ModifiedBy=@ModifiedBy, ModifiyDate=GETDATE() where RiyaMeal_Id=@Id
 END


 if(@Flag='UpdateVendorMeal')
 BEGIN
     update Vendor_Meal set Meal=@Meal, ModifiedBy=@ModifiedBy, ModifiyDate=GETDATE() where VendorMeal_Id=@Id
 END

 
 if(@Flag='DeleteRiyaMeal')
 BEGIN
     update Riya_Meal set  Isactive=0 where RiyaMeal_Id=@Id
 END

 if(@Flag='DeleteVendorMeal')
 BEGIN
   update Vendor_Meal set  Isactive=0 where VendorMeal_Id=@Id
 END

 if(@Flag='GetRiyaEdit')
 BEGIN
   select meal from Riya_Meal where RiyaMeal_Id=@id;
 END

 if(@Flag='GetVendorEdit')
 BEGIN
   select meal from Vendor_Meal where VendorMeal_Id=@id;
 END
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetMealDetails] TO [rt_read]
    AS [dbo];

