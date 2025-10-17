


--select * from SupplierDisplayRights

-- =============================================  
-- Author:  <Altamash Khan>  
-- Create date: <Create Date,,>  
-- Description: <Get All mUser,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[GetmUserForDisplaySupplierRights]  
   
   @Action varchar(50)=null
AS  
BEGIN  
   
   if(@Action='mUser')
   begin
		select ID,UserName +' - '+ FullName as Name 
		from mUser where isActive=1 order by FullName asc  
  end
  else if(@Action='Agent')
   begin
		select PKID as ID,AgencyName +' - '+ Icast as Name 
		from B2BRegistration where AgencyName is not null and Icast is not null order by AgencyName asc  
  end
  
END  
  

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetmUserForDisplaySupplierRights] TO [rt_read]
    AS [dbo];

