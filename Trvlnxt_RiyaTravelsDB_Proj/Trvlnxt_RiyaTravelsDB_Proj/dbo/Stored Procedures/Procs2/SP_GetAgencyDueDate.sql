CREATE Procedure [dbo].[SP_GetAgencyDueDate]      
@AgentID int      
as      
begin      
      
SELECT       
convert(varchar(20),(r.AirlineStartDate + r.AirlineCreditday),105) EndDate,    
u.Country    
,u.UserTypeID
FROM AgentLogin U      
 JOIN B2BRegistration R ON U.UserID = R.FKUserID      
WHERE UserID =@AgentID      
      
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_GetAgencyDueDate] TO [rt_read]
    AS [dbo];

