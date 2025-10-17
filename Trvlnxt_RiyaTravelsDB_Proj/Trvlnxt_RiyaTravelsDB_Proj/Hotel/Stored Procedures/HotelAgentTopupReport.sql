        
                
                  
             
                  
CREATE Procedure Hotel.HotelAgentTopupReport                  
                  
@StartDate varchar(20) = null,                                                    
@EndDate varchar(20)=null,            
@UserType int=0,            
@Agency int=0            
as                   
                  
Begin                  
  Select             
--  TAB.CreatedOn as 'Transaction_Date',  
FORMAT(TAB.CreatedOn, 'dd MMM yyyy hh:mm tt') AS [Transaction_Date],

  BR.Icast  as 'ICUST',              
  mybranch.BranchCode + ' - '+mybranch.[Name] as Branch,              
  mc.[Value] as 'User_Type',              
  BR.AgencyName as 'Agency_Name',              
                
  TAB.OpenBalance as 'Opening_Balance',                  
 case when TransactionType='Debit' then  TAB.TranscationAmount end as 'Debit_Amt',                  
 case when TransactionType='Credit' then  TAB.TranscationAmount end as 'Credit_Amt',                  
  TAB.CloseBalance as 'Closing_Balance',                  
-- case when Tab.DeadlineDate='System.Web.UI.WebCon' then '-' else TAB.DeadlineDate end as 'Deadline_Date',
CASE 
    WHEN ISDATE(Tab.DeadlineDate) = 1 AND Tab.DeadlineDate NOT IN ('1753-01-01 00:00:00.000') 
        THEN FORMAT(CAST(Tab.DeadlineDate AS DATETIME), 'dd MMM yyyy hh:mm tt')
    ELSE '-' 
END AS Deadline_Date,

  TAB.Remark  as 'Remarks' ,      
  Mu.FullName as 'Updated_By'      
                    
  From tblAgentBalance TAB  WITH (NOLOCK)                
  left join B2BRegistration BR WITH (NOLOCK) on BR.FKUserID=TAB.AgentNo              
  left join AgentLogin al WITH (NOLOCK) on TAB.AgentNo=al.UserID              
  left join mCommon mc WITH (NOLOCK) on al.UserTypeID=mc.ID       
  left join mUser mu WITH (NOLOCK) on tab.CreatedBy= mu.ID      
  left join(                                                                                                                                          
  select mbr.BranchCode,MAx(name) as 'Name',Max(Division) as 'Division',max(id) as maxid from mBranch as mbr  group by BranchCode                                                                                                                
)  as mybranch                                                  
                                                                                                                
   on br.BranchCode=mybranch.BranchCode                  
              
  where  TAb.Reference like '%Temp Balance%'              
  and (( cast(TAB.CreatedOn as date) between @StartDate and  @EndDate )or (@StartDate is null and @EndDate is null))             
  and (al.UserTypeID = @UserType   or @UserType=0)            
  and(TAb.AgentNo = @Agency   or @Agency=0)            
  order by  TAB.PKID desc                  
End 