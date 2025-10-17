

CREATE procedure [dbo].[aa]
as begin
--/****** Script for SelectTopNRows command from SSMS  ******/
--INSERT INTO TicketEmails_Arch 
--	([E_ID], [E_Ticket_Id], [E_From], [E_To], [E_DateSent]
--	, [E_Subject], [E_CCMail], [E_Ref_Id], [E_msg_Id], [E_html_Body], [E_entered_date]
--	, [E_AssignedUser], [E_Attachment], [E_Path], [E_Sent_Flag], [E_QCRemark]
--	, [E_Priority], [E_QcFlag], [E_FollowFlag], [E_CloseFlag]
--	, [remark], [OpenEmailFlag], [disposition], [iscancellation], [NewHtmlBody]
--	, [E_AssignedBy], [isservices], [E_moveflag], [E_poptime]
--	, [Qc_DoneBy], [Qc_updated_date], [E_date1])

--SELECT [E_ID], [E_Ticket_Id], [E_From], [E_To], [E_DateSent]
--, [E_Subject], [E_CCMail], [E_Ref_Id], [E_msg_Id], [E_html_Body], [E_entered_date]
--, [E_AssignedUser], [E_Attachment], [E_Path], [E_Sent_Flag], [E_QCRemark]
--, [E_Priority], [E_QcFlag], [E_FollowFlag], [E_CloseFlag]
--, [remark], [OpenEmailFlag], [disposition], [iscancellation], [NewHtmlBody]
--, [E_AssignedBy], [isservices], [E_moveflag], [E_poptime]
--, [Qc_DoneBy], [Qc_updated_date], [E_date1]
--  FROM [CRM].[dbo].[TicketEmails]
--  WHERE E_date1 <= '2017-03-31' AND E_date1 >= '2017-03-01'


--DELETE FROM [CRM].[dbo].[TicketEmails]
--  WHERE E_date1 <= '2017-03-31' AND E_date1 >= '2017-03-01'
select 1
end 




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[aa] TO [rt_read]
    AS [dbo];

