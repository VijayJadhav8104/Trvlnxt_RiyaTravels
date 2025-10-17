
CREATE PROCEDURE GetBBManageBookingUser              
 -- Add the parameters for the stored procedure here              
 @AgentId INT = null    
-- @CountryCode varchar(50)=null    
AS              
BEGIN     
    
    declare  @CountryCode varchar(50)=null;    
   If(@AgentId!=null)      
    begin      
     
 set @CountryCode= (select Country from AgentLogin where UserID=@AgentId )     
    
      SELECT U.ID,U.FullName,CM.CountryCode FROM mUser U       
     JOIN mUserCountryMapping UM ON  UM.UserId=U.ID and UM.isActive=1      
     jOIN CountryMaster CM ON CM.C_Id =UM.CountryId      
     JOIN AgentLogin AL ON AL.BookingCountry=CM.CountryCode and AL.UserID=@AgentId AND U.isActive=1    
  where cm.CountryName=@CountryCode    
      --select ID,case when ISNUMERIC(UserName)=1 then FullName+' - '+UserName else UserName end  as UserName from mUser                
    END      
   ELSE      
   BEGIN      
     SELECT ID,FullName  AS UserName FROM mUser WHERE isActive=1  ORDER BY UserName ASC        
   END      
              
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetBBManageBookingUser] TO [rt_read]
    AS [dbo];

