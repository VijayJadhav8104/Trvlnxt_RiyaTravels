--exec sp_getAgentAccess 4,'menu',1 , 'trvlnxt' ,'Insurance'   
CREATE PROC [dbo].[sp_getAgentAccess]          
@ID INT,          
@Col varchar(10),          
@UserLevel int,          
@Module varchar(20) = null,      
@Products varchar(20) = null      
AS          
BEGIN          
      
IF(@Module IS NULL)      
BEGIN      
 SET @Module='B2B Portal'      
END      
--------      
 if(@Col='country')          
  begin          
    select C.CountryCode,UT.UserTypeId as UserType,u.EmailID,U.MobileNo   from  mUserCountryMapping(nolock) UC           
    INNER JOIN mCountry(nolock)  C on C.ID=UC.CountryId          
    INNER JOIN mUser(nolock)  U on U.ID=UC.UserId          
    INNER JOIN mUserTypeMapping(nolock)  UT ON UT.UserId=U.ID          
    WHERE UC.UserId=@ID and uc.isActive=1          
  end          
  else if(@Col='menu')          
   begin          
     if(@UserLevel=1)          
     begin          
         select distinct m.ID,m.MenuName,M.Path,m.IsParent,m.ParentMenuID,m.menuclass,m.ItemOrder,  
   CASE     
     WHEN (select COUNT(UserTypeId) from mUserTypeMapping mu where mu.UserId=u.ID and mu.UserTypeId=3 and mu.IsActive=1)=1 AND @Module IS NULL AND m.MenuName='Retrieve PNR' THEN '/flight/retrievepnrm/'      
     WHEN (select COUNT(UserTypeId) from mUserTypeMapping mu where mu.UserId=u.ID and mu.UserTypeId=3 and mu.IsActive=1)<>1 AND @Module IS NULL AND m.MenuName='Retrieve PNR' THEN '/flight/retrievepnr/'     
     WHEN (select COUNT(UserTypeId) from mUserTypeMapping mu where mu.UserId=u.ID and mu.UserTypeId=3 and mu.IsActive=1)=1 AND @Module='trvlnxt' AND m.MenuName='Retrieve PNR' THEN '/flight/retrievepnrm/'      
     WHEN (select COUNT(UserTypeId) from mUserTypeMapping mu where mu.UserId=u.ID and mu.UserTypeId=3 and mu.IsActive=1)<>1 AND @Module='trvlnxt' AND m.MenuName='Retrieve PNR' THEN '/flight/retrievepnr/'     
  ELSE m.NewPath END  AS newpath   
   from  mRoleMapping(nolock)  RM           
  INNER JOIN mmenu(nolock)  M on M.ID=RM.MenuID AND M.isActive=1  AND M.Module=@Module --M.Module='B2B Portal'       
  INNER JOIN mUser(nolock)  U ON U.RoleID=RM.RoleID AND U.isActive=1          
  INNER JOIN mUserTypeMapping(nolock) utm on U.ID=utm.UserId AND U.isActive=1   
   WHERE U.ID=@ID AND RM.isActive=1  and (m.Products  like '%'+ @Products +'%' or @Products  IS NULL)      
   order by ItemOrder          
                 
     end          
   else if(@UserLevel=2 or @UserLevel=3 or @UserLevel=4)          
     begin         
      Select distinct m.ID,m.MenuName,M.Path,m.IsParent,m.ParentMenuID,m.menuclass,m.ItemOrder,        
  CASE       
  WHEN U.UserTypeID=3 AND @Module IS NULL AND m.MenuName='Retrieve PNR' THEN '/flight/retrievepnrm/'        
  WHEN U.UserTypeID<>3 AND @Module IS NULL AND m.MenuName='Retrieve PNR' THEN '/flight/retrievepnr/'       
  WHEN U.UserTypeID=3 AND @Module='trvlnxt' AND m.MenuName='Retrieve PNR' THEN '/flight/retrievepnrm/'        
  WHEN U.UserTypeID<>3 AND @Module='trvlnxt' AND m.MenuName='Retrieve PNR' THEN '/flight/retrievepnr/'       
  ELSE m.NewPath END  AS newpath        
  from  mAgentMapping(nolock)  AM           
  INNER JOIN mmenu(nolock)  M on M.ID=AM.MenuID AND M.isActive=1  AND M.Module=@Module  --M.Module='B2B Portal'        
  INNER JOIN AgentLogin(nolock)  U ON U.UserID=AM.AgentID AND U.isActive=1        
  WHERE AM.AgentID=@ID AND AM.isActive=1 and (m.Products like '%'+ @Products +'%' or @Products  IS NULL)      
               
      UNION          
          
      select distinct m.ID,m.MenuName,M.Path,m.IsParent,m.ParentMenuID,m.menuclass,m.ItemOrder,m.newpath FROM mmenu(nolock) M, mmenu(nolock) M1           
  LEFT JOIN mAgentMapping(nolock) AM on M1.ID=AM.MenuID AND M1.isActive=1  AND M1.Module=@Module  --M1.Module='B2B Portal'          
  WHERE AM.AgentID=@ID AND AM.isActive=1 AND M.ID=M1.ParentMenuID  and (m.Products like '%'+ @Products +'%' or @Products  IS NULL)      
  order by ItemOrder          
                
        end          
      end          
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_getAgentAccess] TO [rt_read]
    AS [dbo];

