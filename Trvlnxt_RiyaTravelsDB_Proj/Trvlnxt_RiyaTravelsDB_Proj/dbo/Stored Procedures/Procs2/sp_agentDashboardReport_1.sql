--sp_helptext sp_agentDashboardReport '01-May-2023','03-May-2024','BOMCUST002120A-RH MAHARASHTRA','3'  
/**/  
CREATE procedure [dbo].[sp_agentDashboardReport_1]  -- '22-Apr-2024','22-Apr-2024',null,'1',null      
@FromDate varchar(12)=null,        
@ToDate varchar(12)=null,        
@searchText varchar(max)=null,        
@searchBy varchar(1)='1',        
@userType varchar(15)=null        
        
        
as          
 begin     
 
 if(@searchBy ='1')
 Begin
select           
BR.Icast as 'Agent Code',          
BR.AgencyName as 'Agent Name', 
mc.Value 'User Type',
AL.AgentBalance as 'Current Balance',          
( TAB2.TranscationAmount) as 'Last Top-up Amount',          
Cast(TAB2.CreatedOn  as varchar)/*+' - '+cast(mu.FullName+'('+mu.UserName+')' as varchar)*/'Last top-up Date & By'          
,CAST( tab.CreatedOn as varchar) 'Last Transaction Date'          
,TAB.TranscationAmount 'Last Transaction Amount'          
,br.SalesPersonName 'Sales Person'          
, BR.AccountPerson 'Accounts Person'          
--,br.BranchCode 'Agent City/Branch'         
  ,mybranch.BranchCode + ' - '+mybranch.[Name] as 'Agent City/Branch'             
        
--TAB.PKID,          
--TAB2.PKID 'topuppkid',          
--BR.FKUserID          
from B2BRegistration BR           
inner join tblAgentBalance as TAB on (BR.FKUserID=TAB.AgentNo           
and TAB.PKID=(select MAX(tblAgentBalance.PKID) from tblAgentBalance where BR.FKUserID=tblAgentBalance.AgentNo))          
          
inner join tblAgentBalance as TAB2 on (BR.FKUserID=TAB2.AgentNo --and tab2.Reference='Temp Balance'          
and TAB2.PKID=(select MAX(tblAgentBalance.PKID) from tblAgentBalance where Reference='Temp Balance' and BR.FKUserID=tblAgentBalance.AgentNo))          
          
          
     left join(                                                                                                                                            
  select mbr.BranchCode,MAx(name) as 'Name',Max(Division) as 'Division',max(id) as maxid from mBranch as mbr  group by BranchCode                                                                                                                  
)  as mybranch                                                   
                                                                                                                  
   on br.BranchCode=mybranch.BranchCode        
          
left join agentLogin AL on AL.UserID=BR.FKUserID          
           
left join mUser mu on mu.ID=TAB.CreatedBy          
left join mcommon mc on mc.ID = al.userTypeID and Category='UserType'
where         
BR.Status=1         
and       
 cast(tab.CreatedOn as date) between cast(@FromDate as date) and cast(@ToDate as date)        
     
order by TAB.CreatedOn desc          
  ENd
  else
  if(@searchBy ='2')
  Begin
  select           
BR.Icast as 'Agent Code',          
BR.AgencyName as 'Agent Name', 
mc.Value 'User Type',
AL.AgentBalance as 'Current Balance',          
( TAB2.TranscationAmount) as 'Last Top-up Amount',          
Cast(TAB2.CreatedOn  as varchar)/*+' - '+cast(mu.FullName+'('+mu.UserName+')' as varchar)*/'Last top-up Date & By'          
,CAST( tab.CreatedOn as varchar) 'Last Transaction Date'          
,TAB.TranscationAmount 'Last Transaction Amount'          
,br.SalesPersonName 'Sales Person'          
, BR.AccountPerson 'Accounts Person'          
--,br.BranchCode 'Agent City/Branch'         
  ,mybranch.BranchCode + ' - '+mybranch.[Name] as 'Agent City/Branch'             
        
--TAB.PKID,          
--TAB2.PKID 'topuppkid',          
--BR.FKUserID          
from B2BRegistration BR           
inner join tblAgentBalance as TAB on (BR.FKUserID=TAB.AgentNo           
and TAB.PKID=(select MAX(tblAgentBalance.PKID) from tblAgentBalance where BR.FKUserID=tblAgentBalance.AgentNo))          
          
inner join tblAgentBalance as TAB2 on (BR.FKUserID=TAB2.AgentNo --and tab2.Reference='Temp Balance'          
and TAB2.PKID=(select MAX(tblAgentBalance.PKID) from tblAgentBalance where Reference='Temp Balance' and BR.FKUserID=tblAgentBalance.AgentNo))          
          
          
     left join(                                                                                                                                            
  select mbr.BranchCode,MAx(name) as 'Name',Max(Division) as 'Division',max(id) as maxid from mBranch as mbr  group by BranchCode                                                                                                                  
)  as mybranch                                                   
                                                                                                                  
   on br.BranchCode=mybranch.BranchCode        
          
left join agentLogin AL on AL.UserID=BR.FKUserID          
           
left join mUser mu on mu.ID=TAB.CreatedBy          
left join mcommon mc on mc.ID = al.userTypeID and Category='UserType'
where         
BR.Status=1         
and       
      
(@searchBy ='2' and cast(TAB2.CreatedOn as date) between cast(@FromDate as date) and cast(@ToDate as date))        
    
order by TAB.CreatedOn desc 
  End
  else
  Begin
  select           
BR.Icast as 'Agent Code',          
BR.AgencyName as 'Agent Name', 
mc.Value 'User Type',
AL.AgentBalance as 'Current Balance',          
( TAB2.TranscationAmount) as 'Last Top-up Amount',          
Cast(TAB2.CreatedOn  as varchar)/*+' - '+cast(mu.FullName+'('+mu.UserName+')' as varchar)*/'Last top-up Date & By'          
,CAST( tab.CreatedOn as varchar) 'Last Transaction Date'          
,TAB.TranscationAmount 'Last Transaction Amount'          
,br.SalesPersonName 'Sales Person'          
, BR.AccountPerson 'Accounts Person'          
--,br.BranchCode 'Agent City/Branch'         
  ,mybranch.BranchCode + ' - '+mybranch.[Name] as 'Agent City/Branch'             
        
--TAB.PKID,          
--TAB2.PKID 'topuppkid',          
--BR.FKUserID          
from B2BRegistration BR           
inner join tblAgentBalance as TAB on (BR.FKUserID=TAB.AgentNo           
and TAB.PKID=(select MAX(tblAgentBalance.PKID) from tblAgentBalance where BR.FKUserID=tblAgentBalance.AgentNo))          
          
inner join tblAgentBalance as TAB2 on (BR.FKUserID=TAB2.AgentNo --and tab2.Reference='Temp Balance'          
and TAB2.PKID=(select MAX(tblAgentBalance.PKID) from tblAgentBalance where Reference='Temp Balance' and BR.FKUserID=tblAgentBalance.AgentNo))          
          
          
     left join(                                                                                                                                            
  select mbr.BranchCode,MAx(name) as 'Name',Max(Division) as 'Division',max(id) as maxid from mBranch as mbr  group by BranchCode                                                                                                                  
)  as mybranch                                                   
                                                                                                                  
   on br.BranchCode=mybranch.BranchCode        
          
left join agentLogin AL on AL.UserID=BR.FKUserID          
           
left join mUser mu on mu.ID=TAB.CreatedBy          
left join mcommon mc on mc.ID = al.userTypeID and Category='UserType'
where         
BR.Status=1         
       and BR.Icast + '-'+BR.AgencyName like '%'+@searchText+'%' 
order by TAB.CreatedOn desc 
end
END 