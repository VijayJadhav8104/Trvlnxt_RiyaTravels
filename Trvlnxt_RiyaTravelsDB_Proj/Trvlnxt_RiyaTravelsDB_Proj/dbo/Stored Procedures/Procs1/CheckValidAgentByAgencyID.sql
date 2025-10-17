CREATE Proc [dbo].[CheckValidAgentByAgencyID]  
 @AgencyID int  
AS  
BEGIN 
 SELECT userTypeID ,  
 u.Country ,
 BalanceFetch
 FROM AgentLogin U  
 JOIN B2BRegistration R  ON U.UserID=R.FKUserID  
 WHERE UserID=@AgencyID  
 End