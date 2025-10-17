Create PROC [dbo].[sp_getAgentAccess_Backup25/08/2022]
@ID INT,
@Col varchar(10),
@UserLevel int 
AS
BEGIN
	if(@Col='country')
		begin
				select C.CountryCode,UT.UserTypeId as UserType,u.EmailID,U.MobileNo   from  mUserCountryMapping(nolock) UC 
				inner join mCountry(nolock)  C on C.ID=UC.CountryId
				inner join mUser(nolock)  U on U.ID=UC.UserId
				inner join mUserTypeMapping(nolock)  UT ON UT.UserId=U.ID
				WHERE UC.UserId=@ID and uc.isActive=1
		end
		else if(@Col='menu')
			begin
					if(@UserLevel=1)
					begin
						   select distinct m.ID,m.MenuName,M.Path,m.IsParent,m.ParentMenuID,m.menuclass,m.ItemOrder,m.newpath from  mRoleMapping(nolock)  RM 
							inner join mmenu(nolock)  M on M.ID=RM.MenuID AND M.Module='B2B Portal' AND M.isActive=1
							INNER JOIN mUser(nolock)  U ON U.RoleID=RM.RoleID AND U.isActive=1
							WHERE U.ID=@ID AND RM.isActive=1 order by ItemOrder
							
			        end
                    else if(@UserLevel=2 or @UserLevel=3)
		            begin
						select distinct m.ID,m.MenuName,M.Path,m.IsParent,m.ParentMenuID,m.menuclass,m.ItemOrder,m.newpath from  mAgentMapping(nolock)  AM 
						inner join mmenu(nolock)  M on M.ID=AM.MenuID AND M.Module='B2B Portal' AND M.isActive=1
						WHERE AM.AgentID=@ID AND AM.isActive=1 
					
						UNION

						select distinct m.ID,m.MenuName,M.Path,m.IsParent,m.ParentMenuID,m.menuclass,m.ItemOrder,m.newpath FROM mmenu(nolock) M, mmenu(nolock) M1 
						LEFT JOIN mAgentMapping(nolock) AM on M1.ID=AM.MenuID AND M1.Module='B2B Portal' AND M1.isActive=1 
						WHERE AM.AgentID=@ID AND AM.isActive=1 AND M.ID=M1.ParentMenuID order by ItemOrder
						
				    end
		    end
END

--select * from mRoleMapping where MenuID=17

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_getAgentAccess_Backup25/08/2022] TO [rt_read]
    AS [dbo];

