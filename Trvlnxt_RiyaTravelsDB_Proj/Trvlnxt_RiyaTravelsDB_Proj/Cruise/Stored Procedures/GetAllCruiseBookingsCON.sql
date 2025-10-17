--[Cruise].[GetAllCruiseBookingsCON]  1,'','',69,'BRH103101','51366','C-2210281840'
CREATE PROCEDURE [Cruise].[GetAllCruiseBookingsCON]
 @Id int=0,  
 @BookingFromDate varchar(50)='',                              
 @BookingToDate varchar(50)='',
 @RiyaUserID nvarchar(200)='',                              
 @Branch nvarchar(200)='',                              
 @Agent nvarchar(200)='',                                                       
 @BookingID nvarchar(200)='',
 @BookingStatus nvarchar(200)=''
AS
BEGIN
--select Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)
--select Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102)
	
	SELECT DISTINCT BK.Id, b2b.AgencyName as AgencyName,
		--al.FirstName as AgentName, 
		ite.Iti_Title as CruiseName, ite.DestinationPort as Destination, MB.BranchCode as Branch,
		usr.FullName as AgentName, ISNULL(Supplier,'') as SupplierName,bk.TotalPrice,
		(case when bk.Status=0 then 'NA' when bk.Status=1 then 'Confirmed'  when bk.Status=2 then 'Hold' when bk.Status=3 then 'PendingTicket'  when bk.Status=4 then 'Cancel'
		 when bk.Status=5 then 'Close'  when bk.Status=6 then 'Cancellation'  when bk.Status=7 then 'ToBeReschedule' 
		 when bk.Status=8 then 'Reschedule'  when bk.Status=9 then 'HoldCancel'  when bk.Status=10 then 'BookingTrack' 
		 when bk.Status=11 then 'OnlineCancellation'  when bk.Status=12 then 'TicketingAccess'  when bk.Status=13 then 'ConsoleInserted' when bk.Status=14 then 'Failed' END) AS Status, 
		(select top 1 pax.FirstName +' '+ pax.LastName from Cruise.BookedPaxDetails pax where pax.FkBookingId=bk.Id) as PassengerName,
		(select top 1 ISNULL(ite.StartDate,'') as  StartDate from Cruise.BookedItineraries ite where ite.FkBookingId=bk.Id) as StartDate,
		(select top 1 ISNULL(ite.EndDate,'') as EndDate  from Cruise.BookedItineraries ite where ite.FkBookingId=bk.Id) as EndDate
		,bk.* 
		from Cruise.Bookings bk	
		LEFT JOIN AgentLogin al ON bk.AgentId = al.UserID
		INNER JOIN Cruise.BookedItineraries ite on bk.Id = ite.FkBookingId	
		LEFT JOIN B2BRegistration b2b ON bk.AgentId = b2b.FKUserID
		LEFT JOIN mUser usr ON bk.RiyaUserId = usr.ID
		LEFT JOIN  mBranch MB on MB.BranchCode=b2b.BranchCode
		WHERE 

	    (Convert(varchar(12),bk.CreatedOn,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                              
	    case when @BookingToDate <> '' 
		then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)
		else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate=''))                                          
		
		--(CONVERT(varchar, bk.CreatedOn,126) >= (CONVERT(varchar, @BookingFromDate, 126))        
		--And CONVERT(varchar, bk.CreatedOn,126) <= (CONVERT(varchar, @BookingToDate, 126)))
		And
		(( @RiyaUserID ='') or (bk.RiyaUserId IN  (select Data from sample_split(@RiyaUserID,','))) )  
		And (( @Branch ='') or (b2b.BranchCode IN  (select Data from sample_split(@Branch,','))) ) 
		And ((@Agent ='') or (bk.AgentID IN  (select Data from sample_split(@Agent,','))) )
		And (( @BookingStatus ='') or (bk.Status IN  (select Data from sample_split( @BookingStatus,','))) ) 
		And ((@BookingID ='') or (bk.BookingReferenceId =@BookingID)) 		  		
		And 
		bk.IsActive =1	
		
END



--[Cruise].[GetAllCruiseBookingsCON]  '','','','','','','','1'