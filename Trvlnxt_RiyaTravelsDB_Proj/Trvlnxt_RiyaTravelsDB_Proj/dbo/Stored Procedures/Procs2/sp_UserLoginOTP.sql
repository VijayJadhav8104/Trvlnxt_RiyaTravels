-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
create PROCEDURE [dbo].[sp_UserLoginOTP] -- [sp_UserLoginOTP] '','2','40028','14.143.46.145',null,null       
@UserDeviceID varchar(100),  
@UserType varchar(100),  
@UserID varchar(100),  
@IP varchar(100) = null,  
@windowHight varchar(100) = null,  
@windowWidth varchar(100) = null  
AS  
BEGIN  
   
 declare @myid varchar(30)='';  
   
 if(@UserType = 2 or @UserType=3)  
 begin  
 set @myid = (select top 1 UD.ID from UserDeviceIDs UD  
 LEFT JOIN AgentLogin AL on UD.UserID = AL.UserID  
 where UD.UserDeviceID = @UserDeviceID  
 and UserType = @UserType and UD.UserID = @UserID  
 and UD.UserDeviceID!='' and UD.UserDeviceID is not null  
 and DATEDIFF(DAY, AL.UserDeviceIDTime,getdate()) < 30)  
 end  
 else if(@UserType = 1)  
 begin  
 set @myid = (select top 1 UD.ID from UserDeviceIDs UD  
 LEFT JOIN mUser MU on UD.UserID = MU.ID  
 where UD.UserDeviceID = @UserDeviceID  
 and UserType = @UserType and UD.UserID = @UserID  
 and UD.UserDeviceID!='' and UD.UserDeviceID is not null  
 and DATEDIFF(DAY, MU.UserDeviceIDTime,getdate()) < 30)  
 end  


 if(@myid!='' and @myid is not null)  
 begin  
 select top 1 UserDeviceID,'MatchedDeviceID' as MatchedParameter from UserDeviceIDs   
 where ID = @myid  
 end   


  
 --if(@myid='' or @myid is null)  
 --begin  
 --if(@UserType = 2)  
 --begin  
 --select top 1 UD.UserDeviceID,'MatchedIP' as MatchedParameter from UserDeviceIDs UD  
 --LEFT JOIN AgentLogin AL on UD.UserID = AL.UserID  
 --where UserType = @UserType and UD.UserID = @UserID and IPAddress=@IP  
 --and UD.UserDeviceID!='' and UD.UserDeviceID is not null  
 --and DATEDIFF(DAY, AL.UserDeviceIDTime,getdate()) < 30  
 --end  
 --else if(@UserType = 1)  
 --begin  
 --select top 1 UD.UserDeviceID, 'MatchedIP' as MatchedParameter from UserDeviceIDs UD  
 --LEFT JOIN mUser MU on UD.UserID = MU.ID  
 --where UserType = @UserType and UD.UserID = @UserID  
 --and UD.UserDeviceID!='' and UD.UserDeviceID is not null and IPAddress=@IP  
 --and DATEDIFF(DAY, MU.UserDeviceIDTime,getdate()) < 30  
 --end  

 --end  
END  