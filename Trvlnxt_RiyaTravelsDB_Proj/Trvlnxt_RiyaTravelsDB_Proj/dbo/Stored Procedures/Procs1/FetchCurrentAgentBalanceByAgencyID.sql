--exec [dbo].[FetchCurrentAgentBalanceByAgencyID] 21931    
CREATE Proc [dbo].[FetchCurrentAgentBalanceByAgencyID]    
 @AgencyID int    
AS    
BEGIN    
 SELECT ISNULL(AgentBalance, 0)  AS AgentBalance , ISNULL(R.CreditLimit, 0)  AS CreditLimit,    
 convert(varchar(20),r.AirlineStartDate,106) AirlineStartDate ,u.Country    
 FROM AgentLogin U    
 JOIN B2BRegistration R  ON U.UserID=R.FKUserID    
 WHERE UserID=@AgencyID     
      
 SELECT TOP 5 AgencyName,    
  T.CreatedOn,    
  ISNULL(TranscationAmount,0) AS TranscationAmount,    
  isnull(CloseBalance,0) as Total,    
  TransactionType,    
  AddrLandlineNo,    
  Remark,    
  Reference,  --avinash added    
  convert(varchar(20),b.AirlineStartDate,106) AirlineStartDate,    
  convert(varchar(20),(b.AirlineStartDate + b.AirlineCreditday),106) EndDate,    
  b.AirlineCreditday,    
  t.DueClear,M.UserName as 'CreatedBy'    
  FROM tblAgentBalance T     
  INNER JOIN B2BRegistration B on b.FKUserID=t.AgentNo   
  LEFT JOIN MUSER M ON M.ID=T.CreatedBy 
  where t.AgentNo=@AgencyID AND Remark IS NOT NULL    
  ORDER BY T.CreatedOn DESC    
    
 SELECT AgencyName,    
  Icast,AddrLandlineNo,    
  (case when b.Status=1 then 'Active' when  b.Status=3 then 'Blocked' end) as Status,    
  UserTypeID,    
  B.country,    
  u1.Country,    
  Value    
 FROM B2BRegistration B     
 inner join  agentLogin u1 on b.FKUserID=u1.UserID      
 inner join mCommon on mCommon.ID=UserTypeID    
 where FKUserID=@AgencyID      
 and Category='UserType'    
END    
    
    

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchCurrentAgentBalanceByAgencyID] TO [rt_read]
    AS [dbo];

