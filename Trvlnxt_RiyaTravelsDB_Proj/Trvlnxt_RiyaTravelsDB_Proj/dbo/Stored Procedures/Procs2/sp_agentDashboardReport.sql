--sp_helptext             
/*            
sp_agentDashboardReport '01-May-2023','03-May-2024','BOMCUST002120A-RH MAHARASHTRA','1'                  
            
sp_agentDashboardReport '01-May-2023','03-May-2024','BOMCUST002120A-RH MAHARASHTRA','2'                  
            
sp_agentDashboardReport null,null,'','3'  ,'4'     
sp_agentDashboardReport null,null,null,5,null,null,null,null,null,null  
            
sp_agentDashboardReport '01-Jul-2024','12-Jul-2024',null,'4'  ,null,'2878,2966',''                  
sp_agentDashboardReport null,null,null,'5'  ,null,'RBT Cliq','1000000',null,null,'ANDHERI'                
         700642    
*/                  
CREATE procedure [dbo].[sp_agentDashboardReport]  -- '22-Apr-2024','22-Apr-2024',null,'1',null                      
@FromDate varchar(12)=null,                        
@ToDate varchar(12)=null,                        
@searchText varchar(max)=null,                        
@searchBy varchar(1)='1',                        
@userType varchar(15)=null,    
@EntityNames varchar(max)=null,    
@CBRange varchar(max)='',     
@stateID varchar(max)=null,    
@salesPerson varchar(500)=null,    
@accountsPerson varchar(500)=null,    
@branch varchar(500)=null    
                         
as                          
 begin                     
                 
  --print @searchBy            
 if(@searchBy ='1')                
 Begin                
select                           
BR.Icast as 'Agent Code',            
br.EntityName 'Entity Name',            
BR.AgencyName as 'Agent Name',                
  mybranch.BranchCode + ' - '+mybranch.[Name] as 'Agent City/Branch'               ,              
                   
mc.Value 'User Type',                
AL.AgentBalance as 'Current Balance',                          
( TAB2.TranscationAmount) as 'Last Top-up Amount',                          
Cast(TAB2.CreatedOn  as varchar)/*+' - '+cast(mu.FullName+'('+mu.UserName+')' as varchar)*/'Last top-up Date & By'                          
,CAST( tab.CreatedOn as varchar) 'Last Transaction Date'                          
,TAB.TranscationAmount 'Last Transaction Amount'                          
,br.SalesPersonName 'Sales Person'                          
, BR.AccountPersonName 'Accounts Person'                          
--,br.BranchCode 'Agent City/Branch'                         
                   
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
br.EntityName 'Entity Name',            
            
BR.AgencyName as 'Agent Name',               
  mybranch.BranchCode + ' - '+mybranch.[Name] as 'Agent City/Branch'               ,              
              
mc.Value 'User Type',                
AL.AgentBalance as 'Current Balance',                      
( TAB2.TranscationAmount) as 'Last Top-up Amount',                          
Cast(TAB2.CreatedOn  as varchar)/*+' - '+cast(mu.FullName+'('+mu.UserName+')' as varchar)*/'Last top-up Date & By'                          
,CAST( tab.CreatedOn as varchar) 'Last Transaction Date'                          
,TAB.TranscationAmount 'Last Transaction Amount'                          
,br.SalesPersonName 'Sales Person'                          
, BR.AccountPersonName 'Accounts Person'                          
--,br.BranchCode 'Agent City/Branch'                         
                   
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
           
order by TAB2.CreatedOn desc                 
  End                
  else if (@searchBy ='3')               
  Begin             
  select                           
BR.Icast as 'Agent Code',              
br.EntityName 'Entity Name',            
            
BR.AgencyName as 'Agent Name',               
  mybranch.BranchCode + ' - '+mybranch.[Name] as 'Agent City/Branch'               ,              
              
mc.Value 'User Type',                
AL.AgentBalance as 'Current Balance',                          
( TAB2.TranscationAmount) as 'Last Top-up Amount',                          
Cast(TAB2.CreatedOn  as varchar)/*+' - '+cast(mu.FullName+'('+mu.UserName+')' as varchar)*/'Last top-up Date & By'                          
,CAST( tab.CreatedOn as varchar) 'Last Transaction Date'                          
,TAB.TranscationAmount 'Last Transaction Amount'                          
,br.SalesPersonName 'Sales Person'             
, BR.AccountPersonName 'Accounts Person'                          
--,br.BranchCode 'Agent City/Branch'                         
                 
--TAB.PKID,                          
--TAB2.PKID 'topuppkid',                          
--BR.FKUserID                          
from B2BRegistration BR                           
inner join tblAgentBalance as TAB on (BR.FKUserID=TAB.AgentNo                           
and TAB.PKID=(select MAX(tblAgentBalance.PKID) from tblAgentBalance where BR.FKUserID=tblAgentBalance.AgentNo))                          
                          
inner join tblAgentBalance as TAB2 on (BR.FKUserID=TAB2.AgentNo --and tab2.Reference='Temp Balance'                  
and TAB2.PKID=(select MAX(tblAgentBalance.PKID) from tblAgentBalance where Reference='Temp Balance' and BR.FKUserID=tblAgentBalance.AgentNo))                          
                          
                          
     left join(                                                                                      
  select mbr.BranchCode,MAx(name) as 'Name',Max(Division) as 'Division',max(id) as xid from mBranch as mbr  group by BranchCode                                                                                                                               
  
   
)  as mybranch                                                                   
                                                                                                                                  
   on br.BranchCode=mybranch.BranchCode                        
                          
left join agentLogin AL on AL.UserID=BR.FKUserID                          
                           
left join mUser mu on mu.ID=TAB.CreatedBy                          
left join mcommon mc on mc.ID = al.userTypeID and Category='UserType'                
where                         
BR.Status=1                         
       and (BR.Icast + '-'+BR.AgencyName like '%'+@searchText+'%'    )            
                
              
            
order by TAB.CreatedOn desc               
            
                
end            
else if (@searchBy ='4')               
  Begin             
  select                           
BR.Icast as 'Agent Code',              
br.EntityName 'Entity Name',            
            
BR.AgencyName as 'Agent Name',               
  mybranch.BranchCode + ' - '+mybranch.[Name] as 'Agent City/Branch'               ,              
              
mc.Value 'User Type',                
AL.AgentBalance as 'Current Balance',                          
( TAB2.TranscationAmount) as 'Last Top-up Amount',                          
Cast(TAB2.CreatedOn  as varchar)/*+' - '+cast(mu.FullName+'('+mu.UserName+')' as varchar)*/'Last top-up Date & By'                          
,CAST( tab.CreatedOn as varchar) 'Last Transaction Date'                          
,TAB.TranscationAmount 'Last Transaction Amount'                          
,br.SalesPersonName 'Sales Person'                          
, BR.AccountPersonName 'Accounts Person'                          
--,br.BranchCode 'Agent City/Branch'                         
                 
--TAB.PKID,                          
--TAB2.PKID 'topuppkid',                          
--BR.FKUserID                          
from B2BRegistration BR                           
inner join tblAgentBalance as TAB on (BR.FKUserID=TAB.AgentNo                           
and TAB.PKID=(select MAX(tblAgentBalance.PKID) from tblAgentBalance where BR.FKUserID=tblAgentBalance.AgentNo))                          
                          
inner join tblAgentBalance as TAB2 on (BR.FKUserID=TAB2.AgentNo --and tab2.Reference='Temp Balance'                          
and TAB2.PKID=(select MAX(tblAgentBalance.PKID) from tblAgentBalance where Reference='Temp Balance' and BR.FKUserID=tblAgentBalance.AgentNo))                          
                          
                          
     left join(                                                                                                                                                            
  select mbr.BranchCode,MAx(name) as 'Name',Max(Division) as 'Division',max(id) as xid from mBranch as mbr  group by BranchCode                                                                                                                                
  
)  as mybranch                                                                   
                                                                                                                                  
   on br.BranchCode=mybranch.BranchCode                        
                
left join agentLogin AL on AL.UserID=BR.FKUserID                          
                           
left join mUser mu on mu.ID=TAB.CreatedBy                          
left join mcommon mc on mc.ID = al.userTypeID and Category='UserType'                
where                         
BR.Status=1                         
                   
  and ( cast(BR.EntityNameID as varchar) in (select value from dbo.fn_split( @EntityNames,',')) or isnull(@EntityNames,'')='')          
    --and (al.userTypeID=cast(@userType as int) or isnull(@userType,'')='')            
                 
            
order by TAB.CreatedOn desc               
            
                
end            
else if (@searchBy ='5')               
  Begin             
   select                         
BR.Icast as 'Agent Code',            
br.EntityName 'Entity Name',          
          
BR.AgencyName as 'Agent Name',             
  mybranch.BranchCode + ' - '+mybranch.[Name] as 'Agent City/Branch'               ,            
            
mc.Value 'User Type',              
AL.AgentBalance as 'Current Balance',                        
( TAB2.TranscationAmount) as 'Last Top-up Amount',                        
Cast(TAB2.CreatedOn  as varchar)/*+' - '+cast(mu.FullName+'('+mu.UserName+')' as varchar)*/'Last top-up Date & By'                        
,CAST( tab.CreatedOn as varchar) 'Last Transaction Date'                        
,TAB.TranscationAmount 'Last Transaction Amount'                        
,case when BR.SalesPersonId='0' then 'NA' else Isnull(br.SalesPersonName,'NA') end as 'Sales Person'                        
,case when BR.AccountPerson='0' then 'NA' else Isnull (BR.AccountPersonName,'NA') end as 'Accounts Person'                        
--,br.BranchCode 'Agent City/Branch'                       
               
--TAB.PKID,                        
--TAB2.PKID 'topuppkid',                        
--BR.FKUserID       
,ms.stateName      
from B2BRegistration BR                         
inner join tblAgentBalance as TAB on (BR.FKUserID=TAB.AgentNo                         
and TAB.PKID=(select MAX(tblAgentBalance.PKID) from tblAgentBalance where BR.FKUserID=tblAgentBalance.AgentNo))                        
                        
inner join tblAgentBalance as TAB2 on (BR.FKUserID=TAB2.AgentNo --and tab2.Reference='Temp Balance'                        
and TAB2.PKID=(select MAX(tblAgentBalance.PKID) from tblAgentBalance where Reference='Temp Balance' and BR.FKUserID=tblAgentBalance.AgentNo))                        
                        
                        
     left join(                                                                                                                                                          
  select mbr.BranchCode,MAx(name) as 'Name',Max(Division) as 'Division',max(id) as xid from mBranch as mbr  group by BranchCode                                                                                                                                
)  as mybranch                                                                 
                                                                                                                                
   on br.BranchCode=mybranch.BranchCode                      
                        
left join agentLogin AL on AL.UserID=BR.FKUserID                        
                         
left join mUser mu on mu.ID=TAB.CreatedBy                        
left join mcommon mc on mc.ID = al.userTypeID and Category='UserType'       
      
left join mState ms on ms.ID=StateID      
where                       
BR.Status=1                       
           
    and (al.userTypeID=@userType or isnull(@userType,'')='' or @userType ='-Select-' )          
   and           
  (          
   (@CBRange= '0-100000' AND  (AL.AgentBalance < 100000))          
    OR           
    (@CBRange= '100000-300000' AND  (AL.AgentBalance > 100000 and AL.AgentBalance < 300000))          
     OR           
    (@CBRange= '300000-500000' AND  (AL.AgentBalance > 300000 and AL.AgentBalance < 500000))          
     OR           
    (@CBRange= '500000-1000000' AND  (AL.AgentBalance > 500000 and AL.AgentBalance < 1000000))          
     OR           
    (@CBRange= '1000000' AND  (AL.AgentBalance > 1000000 )          
              
    )          
    OR          
    @CBRange =''  and(AL.AgentBalance > 1 )   
    )          
 and(  isnull(@stateID,'')='' or StateID in ((select value from dbo.fn_split( @stateID,','))) )      
    
 and(  isnull(@accountsPerson,'')='' or BR.AccountPerson in ((select value from dbo.fn_split( @accountsPerson,','))) )      
 and(  isnull(@salesPerson,'')='' or BR.SalesPersonId in ((select value from dbo.fn_split( @salesPerson,','))) )      
 and(  isnull(@branch,'')='' or mybranch.BranchCode in ((select value from dbo.fn_split( @branch,','))) )                   
          
order by TAB.CreatedOn desc             
       
end            
END 