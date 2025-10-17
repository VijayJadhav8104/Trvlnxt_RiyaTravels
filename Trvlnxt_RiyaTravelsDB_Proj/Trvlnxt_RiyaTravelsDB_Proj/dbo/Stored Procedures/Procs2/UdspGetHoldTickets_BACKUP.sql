
CREATE proc [dbo].[UdspGetHoldTickets_BACKUP] -- [UdspGetHoldTickets] '6'
@UserId varchar(25) = null,
@MainAgentId varchar(25)  =null,
@BookingStatus int
AS
BEGIN
        --DECLARE @UserId varchar(500) = '1'
		DECLARE @Error_msg varchar(500)=null
		DECLARE @parent varchar(800)=null

		
		IF (@MainAgentId !=0)

		BEGIN
					SELECT  distinct(t.pkId) as pid, 
					t.riyaPNR as RiyaPNR,
					t.frmSector  as frmloc,
					t.TicketIssuanceError as TicketIssuanceError,
					t.toSector as toloc,
					t.AgentAction,
					OrderId,
						CASE WHEN (pm.order_status is null) THEN 'Pending'
						 WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
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

					CASE WHEN (pm.order_status is null) THEN 'Pending'
					 WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
						 WHEN (GDSPNR IS NULL AND pm.order_status  is NOT null) THEN pm.order_status
						  WHEN (pm.order_status  is NOT null AND GDSPNR IS NOT NULL ) THEN pm.order_status   END AS pnrStatus ,
						  t.IP,
						  p.ticketNum,
						  p.isReturn,
						  t.Country,
						  t.OfficeID,
						  t.AgentID,
						  t.IsBooked ,
					      t.AgentID,
					      pm.order_status ,
					      t.AgentAction ,t.pkId ,t.TicketIssue
						  ,t.FareType
						  ,BR.AgencyName
						  ,BR.Icast
						  --,t.AgentID + ' - ' + B.FirstName + ' ' as BookedBy
						  ,M.UserName as BookedBy
						  ,pm.payment_mode
						  ,t.inserteddate
						  ,t.BookingStatus
					from  [dbo].[tblBookMaster] t
					
					left join dbo.Paymentmaster pm on pm.order_id=t.orderId	
					inner join tblPassengerBookDetails p on p.fkBookMaster=t.pkId
					left join AgentLogin B on  t.AgentID = B.UserID
					inner join B2BRegistration BR on B.UserID = BR.FKUserID
					left join mUser M on M.id = t.MainAgentId
					 where 
					  t.AgentID in (select UserID from AgentLogin  where BookingCountry in (select CountryCode from mUserCountryMapping CM  inner join mCountry C on CM.CountryId = C.ID where UserId = @MainAgentId)) 
					 and t.BookingStatus = @BookingStatus
					 order by t.inserteddate desc

					 
					 
		END

		ELSE IF (@UserId !=0)
		BEGIN
		
				SELECT  distinct(t.pkId) as pid, 
					t.riyaPNR as RiyaPNR,
					t.frmSector  as frmloc,
					t.TicketIssuanceError as TicketIssuanceError,
					t.toSector as toloc,
					OrderId,
						CASE WHEN (pm.order_status is null) THEN 'Pending'
						 WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
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
					CASE WHEN (pm.order_status is null) THEN 'Pending'
					 WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
						 WHEN (GDSPNR IS NULL AND pm.order_status  is NOT null) THEN pm.order_status
						  WHEN (pm.order_status  is NOT null AND GDSPNR IS NOT NULL ) THEN pm.order_status   END AS pnrStatus ,
						  t.IP,
						  p.ticketNum,
						  p.isReturn,
						  t.Country,
						  t.OfficeID,
						  t.agentaction
						  ,t.FareType
						  ,BR.AgencyName
						  ,BR.Icast
						  --,t.AgentID + ' - ' + B.FirstName + ' ' as BookedBy
						  ,M.UserName as BookedBy
						  ,pm.payment_mode
						  ,t.inserteddate
						  ,t.BookingStatus
					from  [dbo].[tblBookMaster] t
					left join dbo.Paymentmaster pm on pm.order_id=t.orderId
					inner join tblPassengerBookDetails p on p.fkBookMaster=t.pkId
					--inner join B2BRegistration BR on B.UserID = BR.FKUserID
					inner join AgentLogin B on  t.AgentID = B.UserID
					inner join B2BRegistration BR on B.UserID = BR.FKUserID
					left join mUser M on M.id = t.MainAgentId
					 where 
					 t.AgentID= @UserId 
					 and t.BookingStatus = @BookingStatus
					 order by t.inserteddate desc
		END
		
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UdspGetHoldTickets_BACKUP] TO [rt_read]
    AS [dbo];

