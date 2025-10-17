-- =============================================
-- Author:		Bhavika kawa
-- Create date: 8/4/2020
-- Description:	get Booking Process B2C
-- =============================================
create PROCEDURE [dbo].[Sp_GetBookingProcess]
@Userid int,
@FromDate Date=null, 
@ToDate Date=null, 
@UserTypeId int=null, 
@Country varchar(10)=null,
@PaymentType varchar(50)=null,
@AgentId int=null,
@BookingStatus varchar(20)=null,
@ProductType varchar(10)=null,
@AirlineCode varchar(10)=null,
@Start int=null,
@Pagesize int=null,
@RecordCount INT OUTPUT
AS
BEGIN

	if(@ProductType = '' or @ProductType='Airline')
	begin
	IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL
	DROP table  #tempTableA
	SELECT * INTO #tempTableA 
	from
	(  
	SELECT  distinct(t.pkId) as pid, t.riyaPNR as RiyaPNR,t.frmSector  as frmloc,
			t.TicketIssuanceError as TicketIssuanceError,t.inserteddate,
			t.toSector as toloc,OrderId
			,CASE WHEN (pm.order_status is null) THEN 'Pending'
			WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
			WHEN (GDSPNR IS NULL AND pm.order_status  is NOT null) THEN pm.order_status end as PaymentStatus,status_message,
			DATEDIFF(mi,t.inserteddate,getdate()) as mints,
			timeline = 'D:'+ convert(varchar(5),datediff(dd,0,(GETDATE()- ISNULL(t.inserteddate_old,T.inserteddate)))) +
			' H:'+ convert(varchar(5),datepart(hour,(GETDATE()-ISNULL(t.inserteddate_old,T.inserteddate)))) +
			' M:'+  convert(varchar(5),datepart(minute,(GETDATE()-ISNULL(t.inserteddate_old,T.inserteddate)))),
			GDSPNR as GDSPNR,t.[airName] as airname,
			t.emailId as email,t.mobileNo as mob,t.depttime as deptdate,t.arrivaltime arrivaldate
			,CASE WHEN (pm.order_status is null) THEN 'Pending'
			WHEN (GDSPNR IS NULL AND pm.order_status is  null) THEN 'Pending' 
			WHEN (GDSPNR IS NULL AND pm.order_status  is NOT null) THEN pm.order_status
			WHEN (pm.order_status  is NOT null AND GDSPNR IS NOT NULL ) THEN pm.order_status   END AS pnrStatus 
			,t.IP,p.ticketNum,p.isReturn,t.Country,t.OfficeID		
			from  [dbo].[tblBookMaster] t
			left join dbo.Paymentmaster pm on pm.order_id=t.orderId
			inner join tblPassengerBookDetails p on p.fkBookMaster=t.pkId
			left join AgentLogin al on CAST(al.UserID as varchar(20)) = t.AgentID

			where t.IsBooked =0 and t.pkId in (select fkBookMaster from tblPassengerBookDetails where IsRefunded =0)
			AND T.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) 
			--AND t.AgentID = 'B2C'
			AND ((@FROMDate = '') or (CONVERT(date,t.inserteddate) >= CONVERT(date,@FROMDate)))
 			AND ((@ToDate = '') or (CONVERT(date,t.inserteddate) <= CONVERT(date, @ToDate))) 
			AND ((@Country = '') or (t.Country = @Country))
			AND ((@UserTypeId = '') or (al.UserTypeID=@UserTypeId))
			AND ((@AgentId = '') or (t.AgentID=@AgentId))
			--AND ((@BookingStatus = '') or (pm.order_status is null) or (PaymentStatus = @BookingStatus))
			AND ((@AirlineCode = '') or (t.airCode in  ( select DATA from sample_split(@AirlineCode,',') )))
			) p 
	order by p.inserteddate desc

	SELECT @RecordCount = @@ROWCOUNT

		SELECT * FROM #tempTableA
		ORDER BY  inserteddate desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	end
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetBookingProcess] TO [rt_read]
    AS [dbo];

