  
  
CREATE Procedure [SS].[Proc_GetBillingContacts]        
@agentID int    = null
    
As        
Begin        
--SS.Proc_GetBillingContacts  51354
--select 'RIYA HOLIDAYS ' 'firstName',
--'PVT LTD' 'lastName', MobileNumber,* from AgentLogin where UserID=@agentID


      
select 
	b.AgencyName 'firstName',
	'' 'middleName',
	LastName 'lastName',
	'' 'suffix', 
	'' 'type', 
	'' 'title', 
	40 'age',
	b.AddrMobileNo 'phone',
	
	b.AddrEmail 'email'
	from AgentLogin ag inner join B2BRegistration b on ag.UserID=b.FKUserID
--where UserID=@agentID
where UserID=@agentID

End
