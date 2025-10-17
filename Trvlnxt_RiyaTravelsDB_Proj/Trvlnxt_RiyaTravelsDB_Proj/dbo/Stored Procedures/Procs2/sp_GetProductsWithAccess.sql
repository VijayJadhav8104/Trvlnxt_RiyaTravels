--sp_helptext sp_GetProductsWithAccess @RiyaUserId=1072,  @MainAgentID =2064  
CREATE Proc [dbo].[sp_GetProductsWithAccess]        
@RiyaUserId as int= 0,    
@AgentID as int= 0  ,  
@SubAgentID as int= 0   
AS        
BEGIN        
 
 if(@AgentID > 0 AND @RiyaUserId=0)
begin
 SELECT P.*
 FROM mProducts p  
 left join mProductsAccess mpa on mpa.MenuId=p.pkid where IsActive=1 
 and AccessToAgency=1 order by ItemOrder     
 end
 else if(@RiyaUserId>0)
 Begin 
  SELECT P.*
   FROM mProducts p  
 left join mProductsAccess mpa on mpa.MenuId=p.pkid where IsActive=1 
 
  and AccessToUser=1 order by ItemOrder
  ENd
else
Begin 
 SELECT P.*
   FROM mProducts p  
 left join mProductsAccess mpa on mpa.MenuId=p.pkid where IsActive=1 
  order by ItemOrder
End
END