CREATE procedure [dbo].[RPT_AgentBalance_LimitAlert]                        
                       
as                                              
begin    
select br.AgencyName [Agency Name],br.CustomerCOde ICust, ab.CloseBalance [Current Balance] From B2BRegistration br
inner join tblAgentBalance ab on br.FKUserID=ab.AgentNo
inner join tblAgentLimitAlert al on br.CustomerCOde=al.erpcode
where  IsActive = 1 and TransactionType = 'debit' 
and ab.CloseBalance <= al.limit                
end 