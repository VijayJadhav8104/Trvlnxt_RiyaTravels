--select * from mealmapping        
        
CREATE Proc [dbo].[Sp_MealMapping]        
@Flag varchar(50)=null,        
@id int=null,        
@Riyaid int=null,        
@Vendorid int=null,        
@CreatedBy int =null        
        
AS        
BEGIN        
        
  if(@Flag='fillddl')        
 Begin        
   Select RiyaMeal_Id,Meal from Riya_Meal where IsActive=1;        
   --Select VendorMeal_Id,Meal from Vendor_Meal where IsActive=1;        
   select top 2000 VendorMeal_Id,Meal from Vendor_Meal where VendorMeal_Id not in (select VendorMeal_Id from MealMapping) and Isactive=1;        
 End        
        
  if(@Flag='fillAllVendorMeal')        
   Begin        
   --Select RiyaMeal_Id,Meal from Riya_Meal where IsActive=1;        
   Select VendorMeal_Id,Meal from Vendor_Meal where IsActive=1;        
   --select VendorMeal_Id from Vendor_Meal where VendorMeal_Id not in (select VendorMeal_Id from MealMapping);        
  End        
         
  if(@Flag='GetData')        
    Begin        
   --  select         
   --row_number() over (order by MM.id) as 'SN',        
   --MM.id,        
   --RM.Meal 'RiyaMeal',        
           
   --Vm.Meal 'VendorMeal',        
   --MM.RiyaMeal_Id 'RiyaMealId',        
   --MU.UserName,        
   --MM.CreatedDate        
   --   from         
   --MealMapping MM         
   --left join Riya_Meal RM on MM.RiyaMeal_Id=RM.RiyaMeal_Id        
   --left join Vendor_Meal VM on MM.VendorMeal_Id=VM.VendorMeal_Id          
   --left join mUser MU on MM.CreatedBy=MU.ID           
      
   select  row_number() over (order by MM.id) as 'SN',        
   MM.id,        
   RM.Meal 'RiyaMeal',          
   Vm.Meal 'VendorMeal',        
   MM.RiyaMeal_Id 'RiyaMealId',        
   MU.UserName,        
   MM.CreatedDate into #Test1       
      from         
   MealMapping MM         
   left join Riya_Meal RM on MM.RiyaMeal_Id=RM.RiyaMeal_Id        
   left join Vendor_Meal VM on MM.VendorMeal_Id=VM.VendorMeal_Id          
   left join mUser MU on MM.CreatedBy=MU.ID        
      
    SELECT       
   RiyaMealId,        
  -- SN,        
  -- id,        
  -- RiyaMeal,          
   VendorMeal=STUFF((SELECT ', ' + VendorMeal      
           FROM #Test1 b       
           WHERE b.RiyaMealId = a.RiyaMealId       
          FOR XML PATH('')), 1, 2, '')      
         
  -- UserName       
  -- CreatedDate      
   into #test2      
   FROM #Test1 a      
   GROUP BY RiyaMealId      
      
      
   select        
    row_number() over (order by t2.RiyaMealId) as 'SN',       
    t2.RiyaMealId,      
 rm.Meal 'RiyaMeal',--t2.VendorMeal,      
   case       
     when (LEN(t2.VendorMeal) > 35) then  SUBSTRING(t2.VendorMeal ,1,35) +'.....'      
   when (LEN(t2.VendorMeal) < 35) then  t2.VendorMeal      
      
   end as  'VendorMeal'      
    from       
   #test2 t2       
   --join MealMapping mm on mm.RiyaMeal_Id=t2.RiyaMealId        
   join Riya_Meal rm on rm.RiyaMeal_Id=t2.RiyaMealId        
      
      
   drop  table #test2;      
      drop  table #Test1;      
 End        
        
  if(@Flag='InsertMealMapping')        
 begin        
     if not exists(select Id from MealMapping where RiyaMeal_Id=@Riyaid and VendorMeal_Id=@Vendorid)        
       begin        
         insert into MealMapping (RiyaMeal_Id,VendorMeal_Id,CreatedBy,CreatedDate,IsActive) values (@Riyaid,@Vendorid,@CreatedBy,GETDATE(),1);        
       end        
  else if exists(select Id from MealMapping where RiyaMeal_Id=@Riyaid and VendorMeal_Id=@Vendorid)        
  begin        
       select top 1  @id=Id from MealMapping where RiyaMeal_Id=@Riyaid and VendorMeal_Id=@Vendorid        
        
    UPDATE MealMapping SET RiyaMeal_Id=@Riyaid, VendorMeal_Id=@Vendorid,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE() WHERE ID=@id;        
             
  end        
        
 end        
          
  if(@flag='Edit')        
  begin        
       select VM.Meal,VM.VendorMeal_Id  from MealMapping MM left join Vendor_Meal VM on MM.VendorMeal_Id=VM.VendorMeal_Id where MM.isactive=1 and MM.RiyaMeal_Id=@Riyaid;        
  end        
        
  if(@Flag='Update')        
  begin        
        
                
  --  if not exists(select Id from MealMapping where RiyaMeal_Id=@Riyaid and VendorMeal_Id=@Vendorid)        
  --     begin        
         insert into MealMapping (RiyaMeal_Id,VendorMeal_Id,CreatedBy,CreatedDate,IsActive) values (@Riyaid,@Vendorid,@CreatedBy,GETDATE(),1);        
  --     end        
  --else if exists(select Id from MealMapping where RiyaMeal_Id=@Riyaid and VendorMeal_Id=@Vendorid)        
  --begin        
  --     select top 1  @id=Id from MealMapping where RiyaMeal_Id=@Riyaid and VendorMeal_Id=@Vendorid        
  --  UPDATE MealMapping SET RiyaMeal_Id=@Riyaid, VendorMeal_Id=@Vendorid,ModifiedBy=@CreatedBy,ModifiedDate=GETDATE() WHERE ID=@id;             
  --end         
  end        
        
  if(@Flag='DeleteRiyameal')        
  begin        
     delete from MealMapping where RiyaMeal_Id=@Riyaid;        
  end        
        
  if(@Flag='Riyameal')        
  begin         
      select  distinct MM.RiyaMeal_Id 'Id',        
          
   Rm.Meal 'Meal'  from MealMapping MM left join Riya_Meal RM on MM.RiyaMeal_Id=RM.RiyaMeal_Id where MM.isactive=1 ;        
  End        
        
  if(@Flag='VmealBasedOnRmeal')        
  begin        
   --select  distinct MM.VendorMeal_Id,Rm.Meal 'Riyameal', Vm.Meal 'VendorMeal'  from MealMapping MM         
   --left join Vendor_Meal VM on MM.VendorMeal_Id=VM.VendorMeal_Id         
   --left join Riya_Meal RM on MM.VendorMeal_Id=RM.RiyaMeal_Id            
   --where MM.isactive=1 and mm.RiyaMeal_Id=@Riyaid;       
       
   select   Vm.Meal 'VendorMeal'  from MealMapping MM         
   left join Vendor_Meal VM on MM.VendorMeal_Id=VM.VendorMeal_Id         
   left join Riya_Meal RM on MM.VendorMeal_Id=RM.RiyaMeal_Id            
   where MM.isactive=1 and mm.RiyaMeal_Id=@Riyaid;    
        
        
  end        
        
        
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_MealMapping] TO [rt_read]
    AS [dbo];

