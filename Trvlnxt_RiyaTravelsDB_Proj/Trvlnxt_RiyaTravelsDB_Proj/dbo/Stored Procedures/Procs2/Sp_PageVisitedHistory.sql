CREATE procedure Sp_PageVisitedHistory  
@FK_InvoicesLoginAuditId varchar(50),  
@PageVisted varchar(500)  
as  
begin  
insert into InvoicesPageVisitedAudit(FK_InvoicesLoginAuditId,PageVisted,VisitedOn) values(@FK_InvoicesLoginAuditId,@PageVisted,GETDATE())  
end