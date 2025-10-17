CREATE Proc [dbo].[Get_AgentAccountStatementHotel]    
	@FromDate Date=null
	, @ToDate Date=null
	, @BranchCode varchar(40)=null
	, @PaymentType varchar(50)=null
	, @AgentTypeId Varchar(50)=null
	, @AgentId int=null
	, @Country varchar(50)=null
	, @ProductType varchar(20)
	, @RiyaPNR varchar(20)=null
AS
BEGIN
	IF(@ProductType='Hotel')              
	BEGIN    
		--IF(@PaymentType='Payment Gateway')          
		IF(@PaymentType='3')             
		BEGIN    
			SELECT            
			--Sr No             
			B.inserteddate AS 'Booking Date'
			, 'HotelSales' AS 'Service Type'
			, (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'
			--B.CurrentStatus as'Booking Status',            
			, sm.STATUS AS 'Booking Status'
			, BookingReference AS 'Booking id'
			, B.riyaPNR AS 'Riya / CRSPNR'
			, B.ConfirmationNumber AS 'Supplier confirmairlinePNR'
			, CASE  WHEN P.order_status = 'Cancelled' THEN convert(VARCHAR(50), ISNULL(P.amount, '0'))  ELSE '0'   END AS 'CreditAmount'
			, CASE  WHEN P.order_status = 'Success'  THEN convert(VARCHAR(50), ISNULL(P.amount, '0')) ELSE '0' END AS 'DebitAmount'
			, '0' AS 'Remaining'
			, P.payment_mode AS 'Mode of Payment'
			, coun.Currency AS 'Currency'
			, B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'
			, CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'
			-- (B.TotalAdults + B.TotalChildren) AS 'Pax count',  
			, cast(Cast(TotalAdults as int) + Cast(TotalChildren  as int) as int) AS 'Pax count'
			, c.Value AS 'AgentType'
			, AL.bookingcountry AS 'Country'
			, BR.Icast as 'AgencyID'
			, BR.AgencyName AS 'AgencyName'
			, '' AS 'Branch Name'
			, '' AS RefNo
			, Al.UserName  as 'Booked By'
			, '' AS 'Remark'
			, B.CheckInDate
			, B.CheckOutDate  
			--,AL.UserTypeID    
			-- ,AL.BookingCountry    
			-- ,b.BranchCode    
			-- ,B.RiyaAgentID    
			FROM Hotel_BookMaster B            
			LEFT JOIN B2BRegistration BR ON B.RiyaAgentID = BR.FKUserID            
			LEFT JOIN Paymentmaster P ON P.order_id = B.orderId                     
			LEFT JOIN mCountry coun ON coun.CountryCode = b.BOOKINGCOUNTRY            
			LEFT JOIN AgentLogin AL ON B.RiyaAgentID = AL.UserID            
			LEFT JOIN mCommon C ON C.ID = AL.UserTypeID            
			LEFT JOIN Hotel_Status_History SH ON B.pkId = SH.FKHotelBookingId     
			LEFT JOIN Hotel_Status_Master SM ON SH.FkStatusId = SM.Id            
			WHERE P.amount IS NOT NULL            
			AND SH.IsActive = 1               
			AND RiyaAgentID IS NOT NULL                      
			AND B.BookingReference IS NOT NULL            
			AND B2BPaymentMode = 3      
			AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FromDate and @ToDate ))    
			AND (AL.UserTypeID= @AgentTypeId  or @AgentTypeId ='')     
			AND (AL.BookingCountry= @Country or @Country='')     
			AND (B.BranchCode =@BranchCode or @BranchCode='')    
			AND (B.RiyaAgentID=@AgentId or @AgentId='')       
			order by B.inserteddate desc
		END    
		--IF(@PaymentType='Walllet')     
		IF(@PaymentType='2')             
		BEGIN    
			SELECT            
			B.inserteddate AS 'Booking Date'
			, 'HotelSales' AS 'Service Type',            
			(B.HotelName + ' ' + B.HotelAddress1) AS 'Description',            
			sm.STATUS AS 'Booking Status',            
			BookingReference AS 'Booking id',            
			B.riyaPNR AS 'Riya / CRSPNR',            
			B.ConfirmationNumber AS 'Supplier confirmairlinePNR',            
			CASE WHEN AB.TransactionType = 'Credit' THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0')) ELSE '0' END AS 'CreditAmount',            
			CASE WHEN AB.TransactionType = 'Debit'  THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0')) ELSE '0' END AS 'DebitAmount',            
			AB.CloseBalance AS 'Remaining',            
			'' as 'Mode of Payment',             
			coun.Currency AS 'Currency',            
			B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name',            
			CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date',            
			--(B.TotalAdults + B.TotalChildren) AS 'Pax count',
			cast(Cast(TotalAdults as int) + Cast(TotalChildren  as int) as int) AS 'Pax count',
			c.Value AS 'AgentType',            
			AL.bookingcountry AS 'Country',  
			BR.Icast as 'AgencyID',  
			BR.AgencyName AS 'AgencyName',            
			'' AS 'Branch Name',            
			'' AS RefNo,            
			Al.UserName  as 'Booked By',            
			'' AS 'Remark',     
			B.CheckInDate,  
			B.CheckOutDate           
			FROM Hotel_BookMaster B            
			LEFT JOIN B2BRegistration BR  ON B.RiyaAgentID = BR.FKUserID            
			LEFT JOIN tblAgentBalance ab ON ab.BookingRef = B.orderId                             
			INNER JOIN mCountry coun ON coun.CountryCode = b.BOOKINGCOUNTRY            
			LEFT JOIN AgentLogin AL ON B.RiyaAgentID = AL.UserID            
			INNER JOIN mCommon C  ON C.ID = AL.UserTypeID            
			LEFT JOIN Hotel_Status_History SH ON B.pkId = SH.FKHotelBookingId            
			LEFT JOIN Hotel_Status_Master SM ON SH.FkStatusId = SM.Id            
			WHERE ab.TranscationAmount IS NOT NULL            
			AND SH.IsActive = 1            
			AND RiyaAgentID IS NOT NULL            
			AND B.BookingReference is not null             
			AND B.B2BPaymentMode = 2            
			AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FromDate and @ToDate ))    
			AND (AL.UserTypeID= @AgentTypeId  or @AgentTypeId ='')     
			AND (AL.BookingCountry= @Country or @Country='')     
			AND (BR.BranchCode =@BranchCode or @BranchCode='')    
			AND (B.RiyaAgentID=@AgentId or @AgentId='')    
			order by [Booking Date] desc    
		END    
		--IF(@PaymentType='Credit')    
		IF(@PaymentType='40')    
		Begin    
			--Credit Debit top up        
			SELECT            
			--Sr No             
			TAB.CreatedOn AS 'Booking Date',            
			'TOP-UP' AS 'Service Type',            
			'' AS 'Description',            
			'' AS 'Booking Status',            
			'' AS 'Booking id',            
			'' AS 'Riya / CRSPNR',            
			'' AS 'Supplier confirmairlinePNR',            
			CASE WHEN tab.TransactionType = 'Credit' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0')) ELSE '0'  END AS 'CreditAmount',            
			CASE  WHEN tab.TransactionType = 'Debit'  THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0'))  ELSE '0' END AS 'DebitAmount',            
			TAB.CloseBalance AS 'Remaining',            
			'' AS 'Mode of Payment',            
			'' AS 'Currency',            
			'' AS 'Passenger name',            
			'' AS 'Travel date',            
			'' AS 'Pax count',            
			c.Value AS 'AgentType',            
			AL.bookingcountry AS 'Country',       
			BR.Icast as 'AgencyID',  
			BR.AgencyName AS 'AgencyName',            
			'' AS 'Branch Name',            
			'' AS RefNo,            
			Al.UserName  as 'Booked By',            
			'' AS 'Remark',     
			'' as CheckInDate,  
			'' as CheckOutDate          
			FROM tblAgentBalance TAB            
			LEFT JOIN B2BRegistration BR ON TAB.AgentNo = BR.FKUserID            
			LEFT JOIN AgentLogin AL ON TAB.AgentNo = AL.UserID            
			LEFT JOIN mCommon C  ON C.ID = AL.UserTypeID            
			WHERE BookingRef in ('Cash','Credit')       
			AND ((@FROMDate = '' or @ToDate='') or (cast(TAB.CreatedOn as date) between @FromDate and @ToDate ))    
			AND (AL.UserTypeID= @AgentTypeId  or @AgentTypeId ='')     
			AND (AL.BookingCountry= @Country or @Country='')     
			AND (BR.BranchCode =@BranchCode or @BranchCode='')    
			AND (TAB.AgentNo=@AgentId or @AgentId='')    
		End    
		--IF(@PaymentType='Hold')     
		IF(@PaymentType='1')             
		BEGIN    
			--    
			SELECT            
			--Sr No             
			B.inserteddate AS 'Booking Date',            
			'HotelSales' AS 'Service Type',            
			(B.HotelName + ' ' + B.HotelAddress1) AS 'Description',            
			sm.STATUS AS 'Booking Status',            
			BookingReference AS 'Booking id',            
			B.riyaPNR AS 'Riya / CRSPNR',            
			B.ConfirmationNumber AS 'Supplier confirmairlinePNR',            
			'0' AS 'CreditAmount',            
			convert(VARCHAR(50), ISNULL(B.DisplayDiscountRate, '0')) AS 'DebitAmount',            
			'0' AS 'Remaining',     
			'' AS 'Mode of Payment',            
			coun.Currency AS 'Currency',            
			B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name',            
			CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date',            
			-- (B.TotalAdults + B.TotalChildren) AS 'Pax count', 
			cast(Cast(TotalAdults as int) + Cast(TotalChildren  as int) as int) AS 'Pax count',
			c.Value AS 'AgentType',            
			AL.bookingcountry AS 'Country',  
			BR.Icast as 'AgencyID',  
			BR.AgencyName AS 'AgencyName',            
			'' AS 'Branch Name',            
			'' AS RefNo,            
			Al.UserName  as 'Booked By',            
			'' AS 'Remark',     
			B.CheckInDate,  
			B.CheckOutDate          
			FROM Hotel_BookMaster B    
			LEFT JOIN B2BRegistration BR ON B.RiyaAgentID = BR.FKUserID                     
			INNER JOIN mCountry coun  ON coun.CountryCode = b.BOOKINGCOUNTRY            
			LEFT JOIN AgentLogin AL ON B.RiyaAgentID = AL.UserID            
			INNER JOIN mCommon C   ON C.ID = AL.UserTypeID            
			LEFT JOIN Hotel_Status_History SH ON B.pkId = SH.FKHotelBookingId            
			LEFT JOIN Hotel_Status_Master SM ON SH.FkStatusId = SM.Id            
			WHERE SH.IsActive = 1            
			AND RiyaAgentID IS NOT NULL                    
			AND B.BookingReference IS NOT NULL            
			AND B.B2BPaymentMode IN (4,1)    
			AND  ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FromDate and @ToDate ))    
			AND  (AL.UserTypeID= @AgentTypeId  or @AgentTypeId ='')     
			AND  (AL.BookingCountry= @Country or @Country='')     
			AND  (BR.BranchCode =@BranchCode or @BranchCode='')    
			AND  (B.RiyaAgentID=@AgentId or @AgentId='')    
			order by B.inserteddate desc    
		END    
		--IF(@PaymentType='') All     
		IF(@PaymentType='')             
		BEGIN    
			(
				SELECT            
				--Sr No             
				B.inserteddate AS 'Booking Date',            
				'HotelSales' AS 'Service Type',            
				(B.HotelName + ' ' + B.HotelAddress1) AS 'Description',            
				--B.CurrentStatus as'Booking Status',            
				sm.STATUS AS 'Booking Status',            
				BookingReference AS 'Booking id',            
				B.riyaPNR AS 'Riya / CRSPNR',            
				B.ConfirmationNumber AS 'Supplier confirmairlinePNR',            
				CASE  WHEN P.order_status = 'Cancelled' THEN convert(VARCHAR(50), ISNULL(P.amount, '0'))  ELSE '0'   END AS 'CreditAmount',            
				CASE  WHEN P.order_status = 'Success'  THEN convert(VARCHAR(50), ISNULL(P.amount, '0')) ELSE '0' END AS 'DebitAmount',            
				'0' AS 'Remaining',            
				P.payment_mode AS 'Mode of Payment',            
				coun.Currency AS 'Currency',            
				B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name',            
				CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date',            
				--(B.TotalAdults + B.TotalChildren) AS 'Pax count',    
				cast(Cast(TotalAdults as int) + Cast(TotalChildren  as int) as int) AS 'Pax count',
				c.Value AS 'AgentType',            
				AL.bookingcountry AS 'Country',      
				BR.Icast as 'AgencyID',    
				BR.AgencyName AS 'AgencyName',            
				'' AS 'Branch Name',            
				'' AS RefNo,            
				Al.UserName  as 'Booked By',            
				'' AS 'Remark',     
				B.CheckInDate,  
				B.CheckOutDate  
				--,AL.UserTypeID    
				-- ,AL.BookingCountry    
				-- ,b.BranchCode    
				-- ,B.RiyaAgentID    
				FROM    
				Hotel_BookMaster B            
				LEFT JOIN B2BRegistration BR  ON B.RiyaAgentID = BR.FKUserID            
				LEFT JOIN Paymentmaster P  ON P.order_id = B.orderId                     
				LEFT JOIN mCountry coun   ON coun.CountryCode = b.BOOKINGCOUNTRY            
				LEFT JOIN AgentLogin AL   ON B.RiyaAgentID = AL.UserID            
				LEFT JOIN mCommon C       ON C.ID = AL.UserTypeID            
				LEFT JOIN Hotel_Status_History SH   ON B.pkId = SH.FKHotelBookingId     
				LEFT JOIN Hotel_Status_Master SM   ON SH.FkStatusId = SM.Id            
				WHERE     
				P.amount IS NOT NULL            
				AND SH.IsActive = 1               
				AND RiyaAgentID IS NOT NULL                      
				AND B.BookingReference IS NOT NULL            
				AND B2BPaymentMode = 3      
				AND  ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FromDate and @ToDate ))    
				AND  (AL.UserTypeID= @AgentTypeId  or @AgentTypeId ='')     
				AND  (AL.BookingCountry= @Country or @Country='')     
				AND  (B.BranchCode =@BranchCode or @BranchCode='')    
				AND  (B.RiyaAgentID=@AgentId or @AgentId='')       
				--  order by B.inserteddate desc    
  
				Union    
      
				SELECT            
				B.inserteddate AS 'Booking Date',            
				'HotelSales' AS 'Service Type',            
				(B.HotelName + ' ' + B.HotelAddress1) AS 'Description',            
				sm.STATUS AS 'Booking Status',            
				BookingReference AS 'Booking id',            
				B.riyaPNR AS 'Riya / CRSPNR',            
				B.ConfirmationNumber AS 'Supplier confirmairlinePNR',            
				CASE WHEN AB.TransactionType = 'Credit' THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0')) ELSE '0' END AS 'CreditAmount',            
				CASE WHEN AB.TransactionType = 'Debit'  THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0')) ELSE '0' END AS 'DebitAmount',            
				AB.CloseBalance AS 'Remaining',            
				'' as 'Mode of Payment',             
				coun.Currency AS 'Currency',            
				B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name',            
				CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date',            
				-- (B.TotalAdults + B.TotalChildren) AS 'Pax count',   
				cast(Cast(TotalAdults as int) + Cast(TotalChildren  as int) as int) AS 'Pax count',
  
				c.Value AS 'AgentType',            
				AL.bookingcountry AS 'Country',  
				BR.Icast as 'AgencyID',  
				BR.AgencyName AS 'AgencyName',            
				'' AS 'Branch Name',            
				'' AS RefNo,            
				Al.UserName  as 'Booked By',            
				'' AS 'Remark',     
				B.CheckInDate,  
				B.CheckOutDate  
   
				FROM Hotel_BookMaster B            
				LEFT JOIN B2BRegistration BR  ON B.RiyaAgentID = BR.FKUserID            
				LEFT JOIN tblAgentBalance ab ON ab.BookingRef = B.orderId                             
				INNER JOIN mCountry coun ON coun.CountryCode = b.BOOKINGCOUNTRY            
				LEFT JOIN AgentLogin AL ON B.RiyaAgentID = AL.UserID            
				INNER JOIN mCommon C  ON C.ID = AL.UserTypeID            
				LEFT JOIN Hotel_Status_History SH ON B.pkId = SH.FKHotelBookingId            
				LEFT JOIN Hotel_Status_Master SM ON SH.FkStatusId = SM.Id            
				WHERE     
				ab.TranscationAmount IS NOT NULL            
				AND SH.IsActive = 1            
				AND RiyaAgentID IS NOT NULL            
				AND B.BookingReference is not null             
				AND B.B2BPaymentMode = 2            
				AND  ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FromDate and @ToDate ))    
				AND  (AL.UserTypeID= @AgentTypeId  or @AgentTypeId ='')     
				AND  (AL.BookingCountry= @Country or @Country='')     
				AND  (BR.BranchCode =@BranchCode or @BranchCode='')    
				AND  (B.RiyaAgentID=@AgentId or @AgentId='')    
    
				union      
      
				--Credit Debit top up        
				SELECT            
				--Sr No             
				TAB.CreatedOn AS 'Booking Date',            
				'TOP-UP' AS 'Service Type',            
				'' AS 'Description',            
				'' AS 'Booking Status',            
				'' AS 'Booking id',            
				'' AS 'Riya / CRSPNR',            
				'' AS 'Supplier confirmairlinePNR',            
				CASE WHEN tab.TransactionType = 'Credit' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0')) ELSE '0'  END AS 'CreditAmount',            
				CASE  WHEN tab.TransactionType = 'Debit'  THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0'))  ELSE '0' END AS 'DebitAmount',            
				TAB.CloseBalance AS 'Remaining',            
				'' AS 'Mode of Payment',            
				'' AS 'Currency',            
				'' AS 'Passenger name',            
				'' AS 'Travel date',            
				'' AS 'Pax count',            
				c.Value AS 'AgentType',            
				AL.bookingcountry AS 'Country',      
				BR.Icast as 'AgencyID',  
				BR.AgencyName AS 'AgencyName',            
				'' AS 'Branch Name',            
				'' AS RefNo,            
				Al.UserName  as 'Booked By',            
				'' AS 'Remark',     
				'' as CheckInDate,  
				'' as CheckOutDate    
     
				FROM tblAgentBalance TAB            
				LEFT JOIN B2BRegistration BR ON TAB.AgentNo = BR.FKUserID            
				LEFT JOIN AgentLogin AL ON TAB.AgentNo = AL.UserID            
				LEFT JOIN mCommon C  ON C.ID = AL.UserTypeID            
				WHERE     
				BookingRef in ('Cash','Credit')       
				AND  ((@FROMDate = '' or @ToDate='') or (cast(TAB.CreatedOn as date) between @FromDate and @ToDate ))    
				AND  (AL.UserTypeID= @AgentTypeId  or @AgentTypeId ='')     
				AND  (AL.BookingCountry= @Country or @Country='')     
				AND  (BR.BranchCode =@BranchCode or @BranchCode='')    
				AND  (TAB.AgentNo=@AgentId or @AgentId='')    
      
				Union    
      
				SELECT            
				--Sr No             
				B.inserteddate AS 'Booking Date',            
				'HotelSales' AS 'Service Type',            
				(B.HotelName + ' ' + B.HotelAddress1) AS 'Description',            
				sm.STATUS AS 'Booking Status',            
				BookingReference AS 'Booking id',            
				B.riyaPNR AS 'Riya / CRSPNR',            
				B.ConfirmationNumber AS 'Supplier confirmairlinePNR',            
				'0' AS 'CreditAmount',            
				convert(VARCHAR(50), ISNULL(B.DisplayDiscountRate, '0')) AS 'DebitAmount',            
				'0' AS 'Remaining',            
				'' AS 'Mode of Payment',            
				coun.Currency AS 'Currency',            
				B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name',            
				CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date',            
				--  (B.TotalAdults + B.TotalChildren) AS 'Pax count',            
				cast(Cast(TotalAdults as int) + Cast(TotalChildren  as int) as int) AS 'Pax count',
				c.Value AS 'AgentType',            
				AL.bookingcountry AS 'Country',       
				BR.Icast as 'AgencyID',  
				BR.AgencyName AS 'AgencyName',            
				'' AS 'Branch Name',            
				'' AS RefNo,            
				Al.UserName  as 'Booked By',            
				'' AS 'Remark',     
				B.CheckInDate,  
				B.CheckOutDate            
				FROM Hotel_BookMaster B    
				LEFT JOIN B2BRegistration BR ON B.RiyaAgentID = BR.FKUserID                     
				INNER JOIN mCountry coun  ON coun.CountryCode = b.BOOKINGCOUNTRY            
				LEFT JOIN AgentLogin AL ON B.RiyaAgentID = AL.UserID            
				INNER JOIN mCommon C   ON C.ID = AL.UserTypeID            
				LEFT JOIN Hotel_Status_History SH ON B.pkId = SH.FKHotelBookingId            
				LEFT JOIN Hotel_Status_Master SM ON SH.FkStatusId = SM.Id            
				WHERE                   
				SH.IsActive = 1            
				AND RiyaAgentID IS NOT NULL                    
				AND B.BookingReference IS NOT NULL            
				AND B.B2BPaymentMode IN (4,1)    
				AND  ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FromDate and @ToDate ))    
				AND  (AL.UserTypeID= @AgentTypeId  or @AgentTypeId ='')     
				AND  (AL.BookingCountry= @Country or @Country='')     
				AND  (BR.BranchCode =@BranchCode or @BranchCode='')    
				AND  (B.RiyaAgentID=@AgentId or @AgentId='')    
			) order by [Booking Date]  
		END    
	END    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_AgentAccountStatementHotel] TO [rt_read]
    AS [dbo];

