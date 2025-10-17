--sp_helpText GetDisplaySupplierRights

-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>  
-- [GetDisplaySupplierRights] 'mUser'  
-- =============================================    
CREATE PROCEDURE [dbo].[GetDisplaySupplierRights]    
   @Action varchar(50)=null  
AS    
BEGIN    
   if(@Action='mUSer')  
   begin   
     select sr.Id as Id,    
     m.FullName as Name,    
     sr.DisplayRights as Rights,    
      
     (select FullName from mUser m1 where m1.ID=sr.CreatedBy) as 'CreatedBy',    
       
      sr.CreatedOn   
  ,sr.UserType  
    
 from SupplierDisplayRights sr    
     
   join mUser m on sr.FkmUserId=m.ID    
 where sr.IsActive=1   and sr.UserType=@Action  
 order by CreatedOn desc    
   End  
  
   else  if(@Action='Agent')  
   begin   
     select sr.Id as Id,    
     BR.AgencyName as Name,    
     sr.DisplayRights as Rights,    
      
     (select FullName from mUser m1 where m1.ID=sr.CreatedBy) as 'CreatedBy',    
       
      sr.CreatedOn   
  ,sr.UserType  
  ,BR.AgencyName  
 from SupplierDisplayRights sr    
   join B2BRegistration BR on sr.FKB2bRegistrationId=BR.PKID  
 where sr.IsActive=1   and sr.UserType=@Action  
 order by CreatedOn desc    
   End  
   
    
END    

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetDisplaySupplierRights] TO [rt_read]
    AS [dbo];

