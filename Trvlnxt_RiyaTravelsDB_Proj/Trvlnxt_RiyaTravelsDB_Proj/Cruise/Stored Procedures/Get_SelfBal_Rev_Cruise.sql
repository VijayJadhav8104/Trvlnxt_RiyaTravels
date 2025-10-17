-- [Cruise].Get_SelfBal_Rev_Cruise '2023-01-01','2023-12-21','All','',0
CREATE PROCEDURE [Cruise].[Get_SelfBal_Rev_Cruise]
	@FromDate Date=null,
	@ToDate Date=null,
	@Status Varchar(10)='',
	@UserId Varchar(500)=null,-- Jitendra Nakum 21/09/2022 add User Filter as per discussed date 20/09/2022
	@OBTC Int-- Jitendra Nakum 21/09/2022 add OBTC Filter when check box check then all record fetch other wise only OBTC No available that record fetch as per discussed date 20/09/2022
AS
BEGIN
	if(@Status='All')
	BEGIN
		SELECT
		CB.CreatedOn 'Date/Time'
		,BR.Icast as 'CUSTID'
		,MU.UserName +' - '+ Mu.FullName 'BookedBy'
		,isnull(MU.UserName + ' - ' + MU.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) as 'IssuedBy'
		,CB.BookingReferenceid 'BookingID'
		,CB.BookingReferenceid 'BookingReferenceid'
		,CB.TotalPrice  as 'TotalPrice'
		,'INR' as 'Currency'
		,(select top 1 ISNULL(ite.StartDate,'') as  StartDate from Cruise.BookedItineraries ite where ite.FkBookingId=CB.Id) as 'StartDate'    
		,(select top 1 pax.FirstName +' '+ pax.LastName from Cruise.BookedPaxDetails pax where pax.FkBookingId=CB.Id and pax.IsPrimaryPax=1) as  'LeadPaxName'
		,(select Count(pax.FkBookingId) from Cruise.BookedPaxDetails pax where pax.FkBookingId=CB.Id) as 'No.ofPax'
		,'Self Balance' AS 'PaymentMode'
		,CASE
		WHEN CB.SB_ReversalStatus=0 then 'Pending'
		WHEN CB.SB_ReversalStatus=1 then 'Completed'
		END 'ReversalStatus'
		,CB.AgentInvoiceNumber
		,CB.InquiryNo
		,CB.FileNo
		,CB.PaymentRefNo
		,CB.OBTCNo
		,CB.RTTRefNo
		,CB.OpsRemark
		,CB.AcctsRemark
		FROM
		cruise.Bookings CB		
		left join cruise.BookedItineraries CBI on CB.Id=CBI.FkBookingId		
		left join B2BRegistration BR on CB.AgentId=BR.FKUserID
		left join mUser MU on CB.RiyaUserId=Mu.ID
		left join AgentLogin al on CB.AgentId=al.UserID
		--left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId
		--left join Hotel_Status_Master HM on SH.FkStatusId=HM.Id
		--left join Hotel_Pax_master HP on HB.pkId=HP.book_fk_id
		WHERE
		CAST(CB.CreatedOn as date) between @FromDate and @ToDate
		--AND (HB.SB_ReversalStatus=cast(@Status as bit))
		AND CB.PaymentMode=4
		AND (@UserId='' OR CB.RiyaUserId=@USerId)
		-- --and (@IsOBTC = 1 OR (HB.OBTCNo is not null and HB.OBTCNo != ''))
		--AND (@OBTC = 0 
		--	OR
		--	(@OBTC=1 and HB.OBTCNo is not null AND HB.OBTCNo != '')
		--	OR
		--	(@OBTC=2 and (HB.OBTCNo is null OR HB.OBTCNo = ''))
		--	)
		AND CB.IsActive = 1
	END
	IF(@Status!='All')
	BEGIN
		SELECT
		CB.CreatedOn 'Date/Time'
		,BR.Icast as 'CUSTID'
		,MU.UserName +' - '+ Mu.FullName 'BookedBy'
		,isnull(MU.UserName + ' - ' + MU.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) as 'IssuedBy'
		,CB.BookingReferenceid 'BookingID'
		,CB.TotalPrice  as 'TotalPrice'
		,'INR' as 'Currency'
		,(select top 1 ISNULL(ite.StartDate,'') as  StartDate from Cruise.BookedItineraries ite where ite.FkBookingId=CB.Id) as 'StartDate'    
		,(select top 1 pax.FirstName +' '+ pax.LastName from Cruise.BookedPaxDetails pax where pax.FkBookingId=CB.Id  and pax.IsPrimaryPax=1) as  'LeadPax Name'
		,(select Count(pax.FkBookingId) from Cruise.BookedPaxDetails pax where pax.FkBookingId=CB.Id) as 'No.ofPax'
		,'Self Balance' AS 'PaymentMode'
		,CASE
		WHEN CB.SB_ReversalStatus=0 then 'Pending'
		WHEN CB.SB_ReversalStatus=1 then 'Completed'
		END 'ReversalStatus'
		,CB.AgentInvoiceNumber
		,CB.InquiryNo
		,CB.FileNo
		,CB.PaymentRefNo
		,CB.OBTCNo
		,CB.RTTRefNo
		,CB.OpsRemark
		,CB.AcctsRemark
		FROM
		cruise.Bookings CB		
		left join cruise.BookedItineraries CBI on CB.Id=CBI.FkBookingId		
		left join B2BRegistration BR on CB.AgentId=BR.FKUserID
		left join mUser MU on CB.RiyaUserId=Mu.ID
		left join AgentLogin al on CB.AgentId=al.UserID
		--left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId
		--left join Hotel_Status_Master HM on SH.FkStatusId=HM.Id
		--left join Hotel_Pax_master HP on HB.pkId=HP.book_fk_id
		WHERE
		CAST(CB.CreatedOn as date) between @FromDate and @ToDate
		AND (CB.SB_ReversalStatus=cast(@Status as bit))
		AND CB.PaymentMode=4
		AND (@UserId='' OR CB.RiyaUserId=@USerId)
		--  --AND (@IsOBTC =1 OR (HB.OBTCNo IS NOT NULL AND HB.OBTCNo != ''))
		--AND (@OBTC = 0 
		--	OR
		--	(@OBTC=1 AND CB.OBTCNo IS NOT NULL AND CB.OBTCNo != '')
		--	OR
		--	(@OBTC=2 AND (CB.OBTCNo IS NULL OR CB.OBTCNo = ''))
		--)
		AND CB.IsActive = 1
	END
 END