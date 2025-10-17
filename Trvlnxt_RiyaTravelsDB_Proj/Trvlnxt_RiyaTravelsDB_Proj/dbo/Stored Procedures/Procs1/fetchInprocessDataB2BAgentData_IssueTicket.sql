CREATE  proc [dbo].[fetchInprocessDataB2BAgentData_IssueTicket]
@UserId varchar(500)
AS
BEGIN
        --DECLARE @UserId varchar(500) = '1'
		DECLARE @Error_msg varchar(500)=null
		DECLARE @parent varchar(800)=null

		set @parent=(select ParentAgentID from AgentLogin where UserID=@UserId)

		IF @PARENT IS NULL
		BEGIN
					
					 SELECT  distinct(t.pkId) as pid, 
					t.riyaPNR as RiyaPNR,
					t.frmSector  as frmloc,
					t.TicketIssuanceError as TicketIssuanceError,
					t.toSector as toloc,
					t.AgentAction,
					OrderId,
						CASE WHEN (pm.order_status is null AND t.TicketIssue=1) THEN 'Pending'
						 WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
						  WHEN (pm.order_status  is NOT null AND GDSPNR IS NOT NULL AND t.TicketIssue=1  ) THEN 'Pending'
						 WHEN (GDSPNR IS NULL AND pm.order_status  is NOT null) THEN pm.order_status end as PaymentStatus,
						

						 status_message,
						 DATEDIFF(mi,t.inserteddate,getdate()) as mints,
						   timeline = 'D:'+ convert(varchar(5),datediff(dd,0,(GETDATE()-t.inserteddate))) +
						   ' H:'+ convert(varchar(5),datepart(hour,(GETDATE()-t.inserteddate))) +
						 ' M:'+  convert(varchar(5),datepart(minute,(GETDATE()-t.inserteddate))),

					 GDSPNR as GDSPNR,
					 t.[airName] as airname,

					t.emailId as email,
					t.mobileNo as mob,
					t.depDate as deptdate,
					t.arrivalDate arrivaldate,

					CASE WHEN (pm.order_status is null  AND t.TicketIssue=1) THEN 'Pending'
					 WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
					  WHEN (pm.order_status  is NOT null AND GDSPNR IS NOT NULL AND t.TicketIssue=1 ) THEN 'Pending'
						 WHEN (GDSPNR IS NULL AND pm.order_status  is NOT null) THEN pm.order_status
						  WHEN (pm.order_status  is NOT null AND GDSPNR IS NOT NULL ) THEN pm.order_status   END AS pnrStatus ,
						  
						  t.IP,
						  p.ticketNum,
						  p.isReturn,
						  t.Country,
						  t.OfficeID
						  ,t.FareType
					from  [dbo].[tblBookMaster] t

					left join dbo.Paymentmaster pm 	on pm.order_id=t.orderId	
					inner join tblPassengerBookDetails p on p.fkBookMaster=t.pkId
					left join AgentLogin B on  t.AgentID = B.UserID

					 where 
					 t.IsBooked =0 and 
					 t.TicketIssue = 1  
					and (t.AgentID= @UserId or t.AgentID in (select cast (userid as varchar(50)) from AgentLogin where ParentAgentID=@Userid)) AND
					 t.pkId in (select fkBookMaster from tblPassengerBookDetails where IsRefunded =0)



		END

		ELSE
		BEGIN
				SELECT  distinct(t.pkId) as pid, 
					t.riyaPNR as RiyaPNR,
					t.frmSector  as frmloc,
					t.TicketIssuanceError as TicketIssuanceError,
					t.toSector as toloc,
					OrderId,
						CASE WHEN (pm.order_status is null  AND t.TicketIssue = 1) THEN 'Pending'
						 WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
						  WHEN (pm.order_status  is NOT null AND GDSPNR IS NOT NULL AND t.TicketIssue=1  ) THEN 'Pending'
						 WHEN (GDSPNR IS NULL AND pm.order_status  is NOT null) THEN pm.order_status end as PaymentStatus,
						 status_message,
						 DATEDIFF(mi,t.inserteddate,getdate()) as mints,
						   timeline = 'D:'+ convert(varchar(5),datediff(dd,0,(GETDATE()-t.inserteddate))) +
						   ' H:'+ convert(varchar(5),datepart(hour,(GETDATE()-t.inserteddate))) +
						 ' M:'+  convert(varchar(5),datepart(minute,(GETDATE()-t.inserteddate))),

					 GDSPNR as GDSPNR,
					 t.[airName] as airname,

					t.emailId as email,
					t.mobileNo as mob,
					t.depDate as deptdate,
					t.arrivalDate arrivaldate,
					CASE WHEN (pm.order_status is null  AND t.TicketIssue=1) THEN 'Pending'
					 WHEN (GDSPNR IS NULL AND pm.order_status is  null AND t.TicketIssue=1) THEN 'Pending' 
						 WHEN (GDSPNR IS NULL AND pm.order_status  is NOT null) THEN pm.order_status 
						  WHEN (pm.order_status  is NOT null AND GDSPNR IS NOT NULL AND t.TicketIssue=1) THEN 'Pending'
						  WHEN (pm.order_status  is NOT null AND GDSPNR IS NOT NULL ) THEN pm.order_status   END AS pnrStatus ,
						  t.IP,
						  p.ticketNum,
						  p.isReturn,
						  t.Country,
						  t.OfficeID,
						  t.agentaction
						  ,t.FareType
					from  [dbo].[tblBookMaster] t
					left join dbo.Paymentmaster pm on pm.order_id=t.orderId
					inner join tblPassengerBookDetails p on p.fkBookMaster=t.pkId
					 where t.IsBooked =0 and
					 t.TicketIssue = 1
					 and 
					 t.pkId in (select fkBookMaster from tblPassengerBookDetails where IsRefunded =0)
					 and
					 t.AgentID= @UserId 
		END
		
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[fetchInprocessDataB2BAgentData_IssueTicket] TO [rt_read]
    AS [dbo];

