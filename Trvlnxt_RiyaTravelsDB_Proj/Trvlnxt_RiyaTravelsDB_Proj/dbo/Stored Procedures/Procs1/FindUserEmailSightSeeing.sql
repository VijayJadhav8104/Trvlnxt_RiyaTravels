CREATE PROCEDURE FindUserEmailSightSeeing  -- FindUserEmail 0,27516,4257            
 -- Add the parameters for the stored procedure here            
 @UserType nvarchar(500)=null,            
 @UserId nvarchar(200),            
  @pkid nvarchar(200)= null            
AS            
BEGIN            
    Declare @AlertEmailid varchar(200)            
   Declare @AddrEmailid varchar(200)          
   Declare @MainAgentEmailid varchar(200)           
 if(@UserType > 0)            
 Begin            
   select EmailID from mUser            
   where ID=@UserType            
               
 End            
            
 else if(@UserType=0)            
 Begin            
              
  --select b.AddrEmail as 'EmailId' from AgentLogin A            
  --inner join B2BRegistration B on a.UserID=B.FKUserID            
  --where B.FKUserID= @UserId            
          
  select @AlertEmailid=Email from SS.SS_BookingMaster where BookingId = @pkid           
  select @AddrEmailid=b.AddrEmail  from AgentLogin A              
  inner join B2BRegistration B on a.UserID=B.FKUserID              
  where B.FKUserID= @UserId            
            
  select @MainAgentEmailid=mu.EmailID  from SS.SS_BookingMaster hb              
  inner join muser mu on hb.MainAgentID=mu.ID              
  where hb.BookingId= @pkid          
        
     select CONCAT(isnull(@AddrEmailid,'developers@riya.travel')+','+isnull(@MainAgentEmailid,'developers@riya.travel')+',',isnull(@AlertEmailid,'developers@riya.travel'),',tn.hotels@riya.travel  ') as 'EmailId'             
               
  return           
              
 End            
            
END  