-- =============================================        
-- Author:  Rahul Agrahari        
-- Create date: 4 May 2021        
-- Description: ERP Activity
-- =============================================
--[USP_ERP_Activity] 'Search','','WGZVFE-1',''
CREATE PROCEDURE [dbo].[USP_ERP_Activity_New]
	@Action varchar(50)=null,
	@orderId varchar(100) =null,
	@Ticketnumber varchar(50)=null,
	@flag varchar(10) =null,
	@BMID varchar(50) =null,
	@PBID varchar(50) =null,
	@CustomerNumber varchar(50) =null,
	@Canfees varchar(50) =null,
	@ServiceFees varchar(50) =null,
	@MarkupOnBaseFare varchar(50) =null,
	@MarkupOnTaxFare varchar(50) =null,
	@MarkuponPenalty varchar(50) =null,
	@Narration  varchar(50) =null,
	@empcode varchar(50) =null	
AS            
BEGIN
	IF @Action = 'Cancellationtickets'  --Marine Cancellation              
		BEGIN              
			SELECT TOP 10000 TicketNumber,EmployeeCode 'UserName', BookingStatus,EDVendorCode 'VendorCode',BMPkId 'PKId',PBPId 'PId', riyaPNR, 
			CreatedDate 'Inserteddate', CounterCloseTime, BMRegistrationNumber 'RegistrationNumber', BookingDate 'IssueDate',TravelStartDate 'depDate',
			TravelEndDate 'arrivalDate', airCode, BMVendor_No 'Vendor_No',VendIATACommAmount 'IATACommission',TravelStartTime 'deptTime',
			TravelEndTime 'arrivalTime', IATACode 'IATA', FromCity 'frmSector', ToCity 'toSector', flightNo,BMtravClass 'travClass',
			TotalAmount 'totalFare', AgentID, Country, BMfromTerminal 'fromTerminal', BMtoTerminal 'toTerminal', BMEquipment 'equipment',              
			BMTotalDiscount 'TotalDiscount', GDSPNR,VendCommAmount 'VendorCommissionPercent', OfficeID, OrderID,Salutation 'title',
			BaseAmount 'basicFare', TaxAmount 'totalTax', paxType,paxName,ManagementFee, PBBaggage 'baggage', PBMarkup 'Markup',              
			YRTaxAmount 'YRTax', YQTaxAmount 'YQ', INTaxAmount 'INTax', K3TaxAmount 'JNTax', OCTaxAmount 'OCTax', XTTaxAmount 'ExtraTax',              
			CardType, CardNumber, PM_Mer_Amount 'mer_amount', PM_Billing_Address 'billing_address', PM_Billing_Name 'billing_name',
			PM_Tracking_id 'tracking_id',airlinePNR, BIcabin 'cabin', BIfarebasis 'farebasis',ATT_VesselName 'VesselName',
			ATT_TR_POName 'TR_POName', ATT_Bookedby 'Bookedby', ATT_AType 'AType', ATT_RankNo 'RankNo',CustomerNumber 'ICast',ISNULL(LocationCode,''),
			ISNULL(BranchCode,''), ISNULL(DivisionCode, ''),ISNULL(PREmpCode,'') as 'EmpCode',ATTOBTCno  'OBTCno',CancellationCharges 'Canfees', 
			ServiceFee 'ServiceFees', MarkupOnBaseFare, MarkupOnTaxFare,CancellationPenalty,ISNULL(Narration, ''),
			--ERP.MarkuponPenalty
			ProductType,
			--Case When CounterCloseTime = 1 Then 'AIR-DOM' Else 'AIR-INT' End As productType,              
			ISNULL(FormOfPayment,'') 'FormOfPayment',  -- Need to check with manasvee              
			ExtraBaggageAmount 'extrabagAmount',Meal_Charges 'Meal Charges',AirLineCode ,AirLineType
			FROM TRVLNXT_Tickets_ERPStatus
			WHERE  IsBooked =1 and TotalAmount > 0 and AgentID != 'B2C'
			and BookingStatus In(4,11) --As confirm with Mansavee               
			and CancERPResponseID is null and (CancERPPuststatus = 0 or CancERPPuststatus is null)---to be checked                 
			and CreatedDate > '2020-12-31 23:59:59.999' and Country in ('IN')              
			and userTypeID = 3 --For Marine usertype is 3 ***     
			and BMVendorName Not in ('STS')
			ORDER BY CreatedDate DESC
		END              
	IF @Action = 'B2CCancellationtickets'
		BEGIN
			SELECT TOP 10000 TicketNumber, EmployeeCode 'UserName', bookingStatus,EDVendorCode,PBPId,BMPkid,riyaPNR, CreatedDate 'Inserteddate',
			BookingDate 'IssueDate', CounterCloseTime, BMRegistrationNumber,TravelStartDate 'depDate', TravelEndDate 'arrivalDate',
			airCode, BMVendor_No 'Vendor_No',VendIATACommAmount 'IATACommission', TravelStartTime 'deptTime',TravelEndTime 'arrivalTime',
			IATACode 'IATA', FromCity 'frmSector', ToCity 'toSector', flightNo, BMtravClass,TotalAmount 'totalFare', AgentID, Country,
			BMfromTerminal 'fromTerminal', BMtoTerminal 'toTerminal', BMEquipment 'equipment',BMTotalDiscount 'TotalDiscount', GDSPNR,
			VendCommAmount 'VendorCommissionPercent', OfficeID, orderId,Salutation 'title',BaseAmount 'basicFare',TotalAmount 'totalTax', 
			paxType,paxName,ManagementFee, PBBaggage 'baggage', PBMarkup 'Markup',            
			YRTaxAmount 'YRTax', YQTaxAmount 'YQ', INTaxAmount 'INTax', K3TaxAmount 'JNTax', OCTaxAmount 'OCTax', XTTaxAmount 'ExtraTax',         
			CancellationCharges,CancellationPenalty,CardType, CardNumber, PM_Mer_Amount 'mer_amount', PM_Billing_Address 'billing_address',
			PM_Billing_Name 'billing_name', OrderID 'order_id', PM_Tracking_id 'tracking_id',              
			--BI.airlinePNR, BI.cabin, BI.farebasis,              
			ATT_VesselName 'VesselName', ATT_TR_POName 'TR_POName', ATT_Bookedby 'Bookedby', ATT_AType 'AType', ATT_RankNo 'RankNo',           
			CustomerNumber 'ICast','' as LocationCode, '' as BranchCode,'' as DivisionCode,                   
			--ERP.Canfees, ERP.ServiceFees,ERP.MarkuponPenalty
			MarkupOnBaseFare, MarkupOnTaxFare,'' Narration, 
			Case When CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as ProductType,               
			'' as FormOfPayment,  -- Need to check with manasvee              
			--1 for domestic              
			AirLineCode,AirLineType             
			FROM TRVLNXT_Tickets_ERPStatus            
			WHERE
			IsBooked =1 and TotalAmount > 0               
			and cast(AgentID as varchar(50))= 'B2C'              
			and BookingStatus In(4,11) --As confirm with Mansavee              
			--and CancERPResponseID is null and (CancERPPuststatus = 0 or CancERPPuststatus is null)              
			and CreatedDate > '2021-08-01 23:59:59.999'               
			--and BM.Country in ('IN','AE','US','CA') --For B2C BM.Country is not required ***               
			--and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country              
			--and AL.userTypeID = 3 --For B2C usertype is not required ***               
			--and pb.TicketNumber='6025563116'              
			ORDER BY IssueDate DESC            
	END                   
	 IF @Action = 'B2CBookingtickets'              
		 BEGIN            
			  SELECT TOP 10000 EmployeeCode 'UserName',EDVendorCode 'VendorCode',OfficeID,BMPkId,PBPId,riyaPNR ,CreatedDate 'inserteddate',
			  BookingDate 'IssueDate',CounterCloseTime, TravelStartDate 'depDate',TravelEndDate 'arrivalDate',airCode,BMVendor_No 'Vendor_No',
			  VendIATACommAmount 'IATACommission',TravelStartTime 'deptTime',TravelEndTime 'arrivalTime',FromCity 'frmSector',ToCity 'toSector',            
			  FlightNo,BMtravClass 'travClass',AgentID,Country,BMfromTerminal 'fromTerminal',BMtoTerminal 'toTerminal',BMEquipment 'equipment'            
			  ,BMTotalDiscount 'TotalDiscount',gdsPnr,VendCommAmount 'VendorCommissionPercent',ServiceFee,SalesExchangeRate 'AgentROE'            
			  ,SalesCurrencyCode 'AgentCurrency',PBB2bMarkup 'B2bMarkup',PBBFC 'BFC',IATACode 'IATA',PurchCurr 'Currency',PurchCurrROE 'ROE',            
			  BMRegistrationNumber 'RegistrationNumber',Salutation 'title',TicketNumber,BaseAmount 'basicFare',TotalAmount 'totalTax',paxType,paxName            
			  managementfees,PBBaggage 'baggage',PBMarkup 'Markup',YRTaxAmount 'YRTax',YQTaxAmount 'YQ',INTaxAmount 'INTax'            
			  ,K3TaxAmount 'JNTax',OCTaxAmount 'OCTax',XTTaxAmount 'ExtraTax',ExtraBaggageAmount 'BaggageFare',CardType,            
			  CardNumber,PM_Mer_Amount 'mer_amount',PM_Billing_Address 'billing_address',PM_Billing_Name 'billing_name',OrderID 'order_id',            
			  PM_Tracking_id 'tracking_id',airlinePNR,BICabin 'cabin',BIfarebasis 'farebasis',            
			  ATT_VesselName 'VesselName',ATT_TR_POName 'TR_POName',ATT_Bookedby 'Bookedby',ATT_AType 'AType',ATT_RankNo 'RankNo',IsBooked,
			  BookingStatus,CustomerNumber 'ICast', LocationCode = '', BranchCode = '', PREmpCode 'EmpCode',AirLineType            
			  FROM TRVLNXT_Tickets_ERPStatus            
			  WHERE IsBooked =1 and TotalAmount > 0 
				and cast(AgentID as varchar(50))= 'B2C'
				and BookingStatus In (1,6)	--As confirm with Mansavee
				and ERPResponseID is null and (ERPPuststatus = 0 or ERPPuststatus is null)
				and CreatedDate > '2021-08-31 23:59:59.999' 				
				and Country in('IN')
				--and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country
				--and AL.userTypeID = 3 --For B2C usertype is not required ***	
				--and BM.GDSPNR IN ('ROWW6M','ROJRQJ','VI2X5J')
				--and PB.TicketNumber in ('6025563122')
			  ORDER BY IssueDate DESC         
		 END          
	 IF @Action = 'B2BBookingTickets'        
		  BEGIN        
			SELECT TOP 10000 EmployeeCode 'UserName',EDVendorCode 'VendorCode',OfficeID,BMPkid 'PKID',PBPId 'PId',riyaPNR,CreatedDate 'Inserteddate',
			BookingDate 'IssueDate',CounterCloseTime,TravelStartDate 'depDate',TravelEndDate 'arrivalDate',airCode,BMVendor_No 'Vendor_No',
			VendIATACommAmount 'IATACommission',TravelStartTime 'deptTime',TravelEndTime 'arrivalTime',FromCity 'frmSector',ToCity 'toSector',FlightNo,
			BMtravClass 'travClass',AgentID,Country,BMfromTerminal 'fromTerminal',BMtoTerminal 'toTerminal',BMEquipment 'equipment',
			BMTotalDiscount 'TotalDiscount',GDSPNR, VendCommAmount 'VendorCommissionPercent',ServiceFee,SalesExchangeRate 'AgentROE',
			SalesCurrencyCode 'AgentCurrency',PBB2bMarkup 'B2bMarkup',PBBFC 'BFC',IATACode 'IATA',PurchCurr 'Currency',PurchCurrROE 'ROE',
			BMRegistrationNumber 'RegistrationNumber',Salutation 'title',TicketNumber,BaseAmount 'basicFare',TaxAmount 'totalTax',paxType,
			paxName,ManagementFee,PBBaggage 'baggage',PBMarkup 'Markup',YRTaxAmount 'YRTax',YQTaxAmount 'YQ',INTaxAmount 'INTax',K3TaxAmount 'JNTax',
			OCTaxAmount 'OCTax',XTTaxAmount 'ExtraTax',PBBaggageFare 'BaggageFare',CardType,CardNumber,PM_Mer_Amount 'mer_amount',
			PM_Billing_Address 'billing_address',PM_Billing_Name 'billing_name',OrderID 'order_id',PM_Tracking_id 'tracking_id',airlinePNR,
			BICabin 'cabin',BIfarebasis 'farebasis',ATT_VesselName 'VesselName',ATT_TR_POName 'TR_POName',ATT_Bookedby 'Bookedby',
			ATT_AType 'AType',ATT_RankNo 'RankNo',CustomerNumber 'ICast',ISNULL(LocationCode,'') ,ISNULL(BranchCode,''),ISNULL(PREmpCode,'') as 'EmpCode',
			AirLineType,ATTOBTCno  'OBTCno',CrsCode,ProductCode,ProductType
			FROM TRVLNXT_Tickets_ERPStatus
			WHERE IsBooked =1 and TotalAmount > 0 and AgentID != 'B2C'        
			and BookingStatus In(1,6) --As confirm with Mansavee        
			-- For Booking        
			and ERPResponseID is null and (ERPPuststatus = 0 or ERPPuststatus is null)        
			and CreatedDate > '2021-08-31 23:59:59.999'         
			and Country in('IN')
			and userTypeID IN(2) --For B2B usertype is 2 ***    
			and BMVendorName Not in ('STS')  
			ORDER BY CreatedDate DESC    
		 END

	IF @Action = 'B2BCancellationTickets'        
		  BEGIN        
			SELECT TOP 10000 TicketNumber,EmployeeCode 'UserName', BookingStatus,EDVendorCode 'VendorCode',BMPkId 'PKId',PBPId 'PId', riyaPNR, 
			CreatedDate 'Inserteddate', CounterCloseTime, BMRegistrationNumber 'RegistrationNumber', BookingDate 'IssueDate',TravelStartDate 'depDate',
			TravelEndDate 'arrivalDate', airCode, BMVendor_No 'Vendor_No',VendIATACommAmount 'IATACommission',TravelStartTime 'deptTime',
			TravelEndTime 'arrivalTime', IATACode 'IATA', FromCity 'frmSector', ToCity 'toSector', flightNo,BMtravClass 'travClass',
			TotalAmount 'totalFare', AgentID, Country, BMfromTerminal 'fromTerminal', BMtoTerminal 'toTerminal', BMEquipment 'equipment',              
			BMTotalDiscount 'TotalDiscount', GDSPNR,VendCommAmount 'VendorCommissionPercent', OfficeID, OrderID,Salutation 'title',
			BaseAmount 'basicFare', TaxAmount 'totalTax', paxType,paxName,ManagementFee, PBBaggage 'baggage', PBMarkup 'Markup',              
			YRTaxAmount 'YRTax', YQTaxAmount 'YQ', INTaxAmount 'INTax', K3TaxAmount 'JNTax', OCTaxAmount 'OCTax', XTTaxAmount 'ExtraTax',              
			CardType, CardNumber, PM_Mer_Amount 'mer_amount', PM_Billing_Address 'billing_address', PM_Billing_Name 'billing_name',
			PM_Tracking_id 'tracking_id',airlinePNR, BIcabin 'cabin', BIfarebasis 'farebasis',ATT_VesselName 'VesselName',
			ATT_TR_POName 'TR_POName', ATT_Bookedby 'Bookedby', ATT_AType 'AType', ATT_RankNo 'RankNo',CustomerNumber 'ICast',ISNULL(LocationCode,''),
			ISNULL(BranchCode,''), ISNULL(DivisionCode, ''),ISNULL(PREmpCode,'') as 'EmpCode',ATTOBTCno  'OBTCno',CancellationCharges 'Canfees', 
			ServiceFee 'ServiceFees', MarkupOnBaseFare, MarkupOnTaxFare,CancellationPenalty,ISNULL(Narration, ''),
			--ERP.MarkuponPenalty
			ProductType,
			--Case When CounterCloseTime = 1 Then 'AIR-DOM' Else 'AIR-INT' End As productType,              
			ISNULL(FormOfPayment,'') 'FormOfPayment',  -- Need to check with manasvee              
			ExtraBaggageAmount 'extrabagAmount',AirLineCode ,AirLineType
			FROM TRVLNXT_Tickets_ERPStatus
			WHERE  IsBooked =1 and TotalAmount > 0 and AgentID != 'B2C'
			and BookingStatus In(4,11) --As confirm with Mansavee               
			and CancERPResponseID is null and (CancERPPuststatus = 0 or CancERPPuststatus is null)---to be checked                 
			and CreatedDate > '2020-12-31 23:59:59.999' and Country in ('IN')              
			and userTypeID = 2 --For usertype is 3 ***     
			and BMVendorName Not in ('STS')
			ORDER BY CreatedDate DESC
		  END        

	IF @Action = 'HolidayBookingTickets'        
		BEGIN        
			SELECT TOP 10000 EmployeeCode 'UserName',EDVendorCode 'VendorCode',OfficeID,BMPkid 'PKID',PBPId 'PId',riyaPNR,CreatedDate 'Inserteddate',
			BookingDate 'IssueDate',CounterCloseTime,TravelStartDate 'depDate',TravelEndDate 'arrivalDate',airCode,BMVendor_No 'Vendor_No',
			VendIATACommAmount 'IATACommission',TravelStartTime 'deptTime',TravelEndTime 'arrivalTime',FromCity 'frmSector',ToCity 'toSector',FlightNo,
			BMtravClass 'travClass',AgentID,Country,BMfromTerminal 'fromTerminal',BMtoTerminal 'toTerminal',BMEquipment 'equipment',
			BMTotalDiscount 'TotalDiscount',GDSPNR, VendCommAmount 'VendorCommissionPercent',ServiceFee,SalesExchangeRate 'AgentROE',
			SalesCurrencyCode 'AgentCurrency',PBB2bMarkup 'B2bMarkup',PBBFC 'BFC',IATACode 'IATA',PurchCurr 'Currency',PurchCurrROE 'ROE',
			BMRegistrationNumber 'RegistrationNumber',Salutation 'title',TicketNumber,BaseAmount 'basicFare',TaxAmount 'totalTax',paxType,
			paxName,ManagementFee,PBBaggage 'baggage',PBMarkup 'Markup',YRTaxAmount 'YRTax',YQTaxAmount 'YQ',INTaxAmount 'INTax',K3TaxAmount 'JNTax',
			OCTaxAmount 'OCTax',XTTaxAmount 'ExtraTax',PBBaggageFare 'BaggageFare',CardType,CardNumber,PM_Mer_Amount 'mer_amount',
			PM_Billing_Address 'billing_address',PM_Billing_Name 'billing_name',OrderID 'order_id',PM_Tracking_id 'tracking_id',airlinePNR,
			BICabin 'cabin',BIfarebasis 'farebasis',ATT_VesselName 'VesselName',ATT_TR_POName 'TR_POName',ATT_Bookedby 'Bookedby',
			ATT_AType 'AType',ATT_RankNo 'RankNo',CustomerNumber 'ICast',ISNULL(LocationCode,'') ,ISNULL(BranchCode,''),ISNULL(PREmpCode,'') as 'EmpCode',
			AirLineType,ATTOBTCno  'OBTCno'
			FROM TRVLNXT_Tickets_ERPStatus
			WHERE IsBooked =1 and TotalAmount > 0 and AgentID != 'B2C'        
			and BookingStatus In(1,6) --As confirm with Mansavee        
			-- For Booking        
			and ERPResponseID is null and (ERPPuststatus = 0 or ERPPuststatus is null)        
			and CreatedDate > '2021-08-31 23:59:59.999'         
			and Country in('IN')
			and userTypeID IN(4) --For Holiday usertype is 4 ***    
			and BMVendorName Not in ('STS')  
			ORDER BY CreatedDate DESC        
		END
	 
	 IF @Action = 'HolidayCancellationtTickets'
		BEGIN        
			SELECT TOP 10000 TicketNumber,EmployeeCode 'UserName', BookingStatus,EDVendorCode 'VendorCode',BMPkId 'PKId',PBPId 'PId', riyaPNR, 
			CreatedDate 'Inserteddate', CounterCloseTime, BMRegistrationNumber 'RegistrationNumber', BookingDate 'IssueDate',TravelStartDate 'depDate',
			TravelEndDate 'arrivalDate', airCode, BMVendor_No 'Vendor_No',VendIATACommAmount 'IATACommission',TravelStartTime 'deptTime',
			TravelEndTime 'arrivalTime', IATACode 'IATA', FromCity 'frmSector', ToCity 'toSector', flightNo,BMtravClass 'travClass',
			TotalAmount 'totalFare', AgentID, Country, BMfromTerminal 'fromTerminal', BMtoTerminal 'toTerminal', BMEquipment 'equipment',              
			BMTotalDiscount 'TotalDiscount', GDSPNR,VendCommAmount 'VendorCommissionPercent', OfficeID, OrderID,Salutation 'title',
			BaseAmount 'basicFare', TaxAmount 'totalTax', paxType,paxName,ManagementFee, PBBaggage 'baggage', PBMarkup 'Markup',              
			YRTaxAmount 'YRTax', YQTaxAmount 'YQ', INTaxAmount 'INTax', K3TaxAmount 'JNTax', OCTaxAmount 'OCTax', XTTaxAmount 'ExtraTax',              
			CardType, CardNumber, PM_Mer_Amount 'mer_amount', PM_Billing_Address 'billing_address', PM_Billing_Name 'billing_name',
			PM_Tracking_id 'tracking_id',airlinePNR, BIcabin 'cabin', BIfarebasis 'farebasis',ATT_VesselName 'VesselName',
			ATT_TR_POName 'TR_POName', ATT_Bookedby 'Bookedby', ATT_AType 'AType', ATT_RankNo 'RankNo',CustomerNumber 'ICast',ISNULL(LocationCode,''),
			ISNULL(BranchCode,''), ISNULL(DivisionCode, ''),ISNULL(PREmpCode,'') as 'EmpCode',ATTOBTCno  'OBTCno',CancellationCharges 'Canfees', 
			ServiceFee 'ServiceFees', MarkupOnBaseFare, MarkupOnTaxFare,CancellationPenalty,ISNULL(Narration, ''),
			--ERP.MarkuponPenalty
			ProductType,
			--Case When CounterCloseTime = 1 Then 'AIR-DOM' Else 'AIR-INT' End As productType,              
			ISNULL(FormOfPayment,'') 'FormOfPayment',  -- Need to check with manasvee              
			ExtraBaggageAmount 'extrabagAmount',Meal_Charges 'Meal Charges',AirLineCode ,AirLineType
			FROM TRVLNXT_Tickets_ERPStatus
			WHERE  IsBooked =1 and TotalAmount > 0 and AgentID != 'B2C'
			and BookingStatus In(4,11) --As confirm with Mansavee               
			and CancERPResponseID is null and (CancERPPuststatus = 0 or CancERPPuststatus is null)---to be checked                 
			and CreatedDate > '2020-12-31 23:59:59.999' and Country in ('IN')              
			and userTypeID = 4 --For Holiday usertype is 3 ***     
			and BMVendorName Not in ('STS')
			ORDER BY CreatedDate DESC
		END        

	 IF @Action = 'UAEBookingTickets'        
		BEGIN        
			SELECT TOP 10000 EmployeeCode 'UserName',EDVendorCode,OfficeID,PBPId,BMPKid,riyaPNR,CreatedDate 'inserteddate',BookingDate 'IssueDate',
			CounterCloseTime,TravelStartDate 'depDate',TravelEndDate 'arrivalDate',airCode,BMVendor_No 'Vendor_No'            
			,VendIATACommAmount 'IATACommission',TravelStartTime 'deptTime',TravelEndTime 'arrivalTime',FromCity 'frmSector',ToCity 'toSector',             
			FlightNo,BMtravClass 'travClass',AgentID,Country,BMfromTerminal 'fromTerminal',BMtoTerminal 'toTerminal',BMEquipment 'equipment'            
			,BMTotalDiscount 'TotalDiscount',GDSPNR, VendCommAmount 'VendorCommissionPercent',ServiceFee,SalesExchangeRate 'AgentROE',      
			SalesCurrencyCode 'AgentCurrency',PBB2bMarkup 'B2bMarkup',PBBFC 'BFC',IATACode 'IATA',PurchCurr 'Currency',PurchCurrROE 'ROE',        
			BMRegistrationNumber 'RegistrationNumber',Salutation 'title',TicketNumber,BaseAmount 'basicFare',TaxAmount 'totalTax',paxType,
			paxName,ManagementFee,PBBaggage 'baggage',PBMarkup 'Markup',YRTaxAmount 'YRTax',YQTaxAmount 'YQ',INTaxAmount 'INTax',      
			K3TaxAmount 'JNTax',OCTaxAmount 'OCTax',XTTaxAmount 'ExtraTax',ExtraBaggageAmount 'BaggageFare',CardType,CardNumber,
			PM_Mer_Amount 'mer_amount',PM_Billing_Address 'billing_address',PM_Billing_Name 'billing_name',OrderID 'order_id',            
			PM_Tracking_id 'tracking_id',airlinePNR,BICabin 'cabin',BIfarebasis 'farebasis',ATT_VesselName 'VesselName',ATT_TR_POName 'TR_POName',
			ATT_Bookedby 'Bookedby',ATT_AType 'AType',ATT_RankNo 'RankNo',         
			CustomerNumber 'ICast', LocationCode = '', BranchCode = '', PREmpCode 'EmpCode',AirLineType        
			FROM TRVLNXT_Tickets_ERPStatus        
			WHERE IsBooked =1 and TotalAmount > 0 and AgentID != 'B2C'        
			and BookingStatus In (1,6) --As confirm with Mansavee        
			-- For Booking        
			and ERPResponseID is null and (ERPPuststatus = 0 or ERPPuststatus is null)        
			and CreatedDate > '2021-10-31 23:59:59.999'         
			and Country in('AE')        
			--and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country         
			and userTypeID IN(2) --For UAE usertype is 2 ***            
			ORDER BY CreatedDate DESC        
		END          
      
	IF @Action = 'MarineBookingtickets'        
		BEGIN
			SELECT TOP 10000 TicketNumber,EmployeeCode 'UserName', Bookingstatus,EDVendorCode,
			--ED.AgentCountry,ED.OwnerCountry, ED.ERPCountry,	-- This all replaced with Country column data
			MainAgentId,	--BM.MainAgentId,    to check  
			case when PaymentMode='passThrough' then 'CUSTOMER'         
			when PaymentMode='Credit' then 'CORPORATE'         
			Else 'CASH' end as UATP,        
			PBPId,BMPkId, IATACode 'IATA', CustomerNumber 'ICast', RiyaPNR, CreatedDate 'inserteddate',CounterCloseTime,
			BMRegistrationNumber 'RegistrationNumber', BookingDate 'BMIssueDate',TravelStartDate 'depDate',TravelEndDate 'arrivalDate',
			airCode,BMVendor_No 'Vendor_No',VendIATACommAmount 'IATACommission',TravelStartTime 'deptTime',TravelEndTime 'arrivalTime',
			FromCity 'frmSector',ToCity 'toSector',FlightNo,BMtravClass 'travClass',TotalAmount 'totalFare',AgentID, Country, 
			BMfromTerminal 'fromTerminal',BMtoTerminal 'toTerminal',BMEquipment 'equipment',BMTotalDiscount 'TotalDiscount',GDSPNR,
			VendCommAmount 'VendorCommissionPercent', OfficeID, orderId,Salutation 'title',BaseAmount 'basicFare',TaxAmount 'totalTax',
			paxType,paxName,ManagementFee,PBBaggage 'baggage',PBMarkup 'Markup',YRTaxAmount 'YRTax',YQTaxAmount 'YQ',INTaxAmount 'INTax',
			K3TaxAmount 'JNTax',OCTaxAmount 'OCTax',XTTaxAmount 'ExtraTax', K3TaxAmount 'K3Tax' ,RFTaxAmount 'RFTax',   
			--Added By Rahul A. As discussed with  ranjit
			WOTaxAmount 'WOTax',YMTaxAmount 'YMTax',OBTaxAmount 'OBTax',        
			--End
			CardType,CardNumber,PM_Mer_Amount 'mer_amount',PM_Billing_Address 'billing_address',PM_Billing_Name 'billing_name',    
			OrderID 'order_id',PM_Tracking_id 'tracking_id',        
			--BI.airlinePNR, BI.cabin, BI.farebasis,        
			ServiceFee 'ServiceFees',ISNULL(PBB2bMarkup,0) +ISNULL(PBBFC,0) as 'MarkupOnBaseFare','' as MarkupOnTaxFare , '' as Narration,            
			ExtraBaggageAmount 'BaggageFare',
			--ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,        
			LocationCode = '', BranchCode = '','' as DivisionCode,AirLineCode,        
			Case When CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' 
				 End As productType,
			'' as FormOfPayment,  -- Need to check with manasvee        
			--1 for domestic        
			TicketingUserID as 'TicketinguserID',
			BookingUserID as 'BookinguserID',
			case when BMVendorName='Amadeus' then '1A'         
			when BMVendorName='Galileo' then '1G'         
			when BMVendorName='Sabre' then '1S'         
			Else BMVendorName end as CRSCode,     
			SalesExchangeRate 'SalesCurrROE',   --BM.AgentROE as 'SalesCurrROE',        
			SalesCurrencyCode 'SalesCurr',		--BM.AgentCurrency 'SalesCurr',        
			PurchCurr 'PurchaseCurr',			--TOC.Currency as 'PurchaseCurr',        
			PurchCurrROE 'PurchaseCurrROE',		--BM.ROE as 'PurchaseCurrROE',        
			ExtraBaggageAmount 'extrabagAmount',   --,SSR_Amount as 'extrabagAmount', 
			AirLineType 'AirLineType'        
			FROM TRVLNXT_Tickets_ERPStatus			
			WHERE IsBooked =1 and TotalAmount > 0 and AgentID != 'B2C'       
			and BookingStatus IN(1,6)   --As confirm with Mansavee        
			and ERPResponseID is null and (ERPPuststatus = 0 or ERPPuststatus is null)        
			and CreatedDate > '2021-08-31 23:59:59.999'        
			and Country in ('IN') --('IN','AE','US','CA')        
			--and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country        
			and userTypeID = 3 --For Marine usertype is 3 ***        
			--and SSR_Type='Baggage' and SSR_Status=1  to be checked  
			ORDER BY BookingDate DESC        
		END          
	IF @Action = 'US-CABookingtickets'
		BEGIN        
			SELECT TOP 10000 ticketnumber, --ED.AgentCountry,OwnerCountry,  ED.ERPCountry, BM.MainAgentId  ,    
			EmployeeCode AS UserName, bookingStatus, EDVendorCode,         
			Case When PaymentMode='passThrough' then 'CUSTOMER'         
				 When PaymentMode='Credit' then 'CORPORATE'         
				 Else 'CASH' end as UATP,       
			PBPId,BMPkId, IATACode 'IATA', CustomerNumber 'ICast', RiyaPNR,
			CreatedDate 'BMinserteddate', CounterCloseTime, BMRegistrationNumber 'RegistrationNumber', BookingDate 'IssueDate',   
			TravelStartDate 'depDate',TravelEndDate 'arrivalDate',airCode,BMVendor_No 'Vendor_No',   
			VendIATACommAmount 'IATACommission',TravelStartTime 'deptTime',TravelEndTime 'arrivalTime', FromCity 'frmSector',ToCity 'toSector',
			FlightNo,BMtravClass 'TravelClass',TotalAmount AS totalFare, AgentID, Country, BMfromTerminal 'fromTerminal',
			BMtoTerminal 'toTerminal',BMEquipment 'equipment',         
			BMTotalDiscount 'TotalDiscount',GDSPNR, VendCommAmount 'VendorCommissionPercent', OfficeID, orderId,Salutation 'title',
			TicketNumber,BaseAmount + isnull(BMAgentMarkup,0.00) as basicFare,TaxAmount 'totalTax',paxType, K3TaxAmount 'K3Tax', PaxName,
			ManagementFee,PBBaggage 'baggage',PBMarkup 'Markup', isnull(BMAgentMarkup,0.00) as AgentMarkup,YRTaxAmount 'YRTax',
			YQTaxAmount 'YQ',INTaxAmount 'INTax',  K3TaxAmount 'JNTax',OCTaxAmount 'OCTax',XTTaxAmount 'ExtraTax',PBRFTax 'RFTax',CardType,
			CardNumber,PM_Mer_Amount 'mer_amount',PM_Billing_Address 'billing_address',PM_Billing_Name 'billing_name',OrderID 'order_id',
			PM_Tracking_id 'tracking_id',
			--BI.airlinePNR, BI.cabin, BI.farebasis,        
			ServiceFee 'ServiceFees', ISNULL(PBB2bMarkup,0) +ISNULL(PBBFC,0) as 'MarkupOnBaseFare' ,'' as MarkupOnTaxFare , '' as Narration,               
			ExtraBaggageAmount 'BaggageFare',        
			--ATT.VesselName, ATT.TR_POName, ATT.Bookedby, ATT.AType, ATT.RankNo,
			'' as LocationCode, '' as BranchCode,'' as DivisionCode,AirLineCode,        
			case when CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
			'' as FormOfPayment,  -- Need to check with manasvee        
			--1 for domestic        
			TicketingUserID as 'TicketinguserID',
			BookingUserID as 'BookinguserID',
			case when BMVendorName='Amadeus' then '1A'         
			when BMVendorName='Galileo' then '1G'         
			when BMVendorName='Sabre' then '1S'         
			Else BMVendorName end as CRSCode,     
			SalesExchangeRate 'SalesCurrROE',   --BM.AgentROE as 'SalesCurrROE',        
			SalesCurrencyCode 'SalesCurr',		--BM.AgentCurrency 'SalesCurr',        
			PurchCurr 'PurchaseCurr',			--TOC.Currency as 'PurchaseCurr',        
			PurchCurrROE 'PurchaseCurrROE',		--BM.ROE as 'PurchaseCurrROE',        
			ExtraBaggageAmount 'extrabagAmount',   --,SSR_Amount as 'extrabagAmount',        
			cast((isnull((CASE WHEN BMB2bFareType=2 or BMB2bFareType=3 THEN  (PBB2bMarkup/isnull(SalesExchangeRate,0)) ELSE 0 END)* PurchCurrROE,0))as decimal(18,2)) as MarkupOnTax_,        
			(cast((isnull((CASE WHEN BMB2bFareType=1 THEN  (PBB2bMarkup/isnull(SalesExchangeRate,0)) ELSE 0 END)* PurchCurrROE,0))as decimal(18,2)) +PBBFC) as MarkupOnFare_ ,
			AirLineType 'AirLineType'         
			FROM TRVLNXT_Tickets_ERPStatus       
			WHERE IsBooked =1 and TotalAmount > 0 and AgentID != 'B2C'        
			and BookingStatus IN(1,6)  --As confirm with Mansavee        
			and ERPResponseID is null and (ERPPuststatus = 0 or ERPPuststatus is null)           
			and CreatedDate > '2021-07-31 23:59:59.999'        
			and Country in ('US','CA')--('IN','AE','US','CA')        
			--and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country        
			and userTypeID = 2 --For US usertype is 2 ***                 
			ORDER BY BookingDate DESC
		END

	 IF @Action = 'US-CACancellationtickets'        
		BEGIN
		SELECT TOP 10000 TicketNumber, EmployeeCode 'UserName', bookingStatus,EDVendorCode,PBPId,BMpkId, riyaPNR, CreatedDate 'inserteddate',
			CounterCloseTime, BMRegistrationNumber 'RegistrationNumber', BookingDate 'IssueDate',TravelStartDate 'depDate',
			TravelEndDate 'arrivalDate',airCode,BMVendor_No 'Vendor_No',VendIATACommAmount 'IATACommission',TravelStartTime 'deptTime',
			TravelEndTime 'arrivalTime', IATACode 'IATA',FromCity 'frmSector',ToCity 'toSector',FlightNo,BMtravClass 'travClass',       
			TotalAmount AS totalFare, AgentID, Country, BMfromTerminal 'fromTerminal',BMtoTerminal 'toTerminal',BMEquipment 'equipment',        
			BMTotalDiscount 'TotalDiscount',GDSPNR, VendCommAmount 'VendorCommissionPercent', OfficeID, orderId,Salutation 'title',
			TicketNumber,BaseAmount 'basicFare',TaxAmount 'totalTax',paxType,paxName, ManagementFee,PBBaggage 'baggage',PBMarkup 'Markup',YRTaxAmount 'YRTax',YQTaxAmount 'YQ',INTaxAmount 'INTax',    
			K3TaxAmount 'JNTax',OCTaxAmount 'OCTax',XTTaxAmount 'ExtraTax',       
			CardType,  CardNumber,PM_Mer_Amount 'mer_amount',PM_Billing_Address 'billing_address',PM_Billing_Name 'billing_name',    
			OrderID 'order_id',PM_Tracking_id 'tracking_id',    
			--BI.airlinePNR, BI.cabin, BI.farebasis,        
			ATT_VesselName 'VesselName',ATT_TR_POName 'TR_POName',ATT_Bookedby 'Bookedby',ATT_AType 'AType',ATT_RankNo 'RankNo',        
			CustomerNumber 'ICast', '' as LocationCode, '' as BranchCode,'' as DivisionCode,CancellationCharges 'Canfees',
			ServiceFee 'ServiceFees',MarkupOnBaseFare, MarkupOnTaxFare, CancellationPenalty 'MarkuponPenalty','' Narration,    
			case when CounterCloseTime = 1 then 'AIR-DOM' else 'AIR-INT' end as productType,        
			'' as FormOfPayment,  -- Need to check with manasvee        
			--1 for domestic        
			AirLineCode,AirLineType 'AirLineType'        
			FROM TRVLNXT_Tickets_ERPStatus       
			WHERE IsBooked =1 and TotalAmount > 0 and AgentID != 'B2C'        
			and BookingStatus IN(4,11) --As confirm with Mansavee        
			and CancERPResponseID is null and (CancERPPuststatus = 0 or CancERPPuststatus is null)  
			and CreatedDate > '2020-12-31 23:59:59.999'
			and Country in ('US','CA')        
			--and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country        
			and userTypeID = 2 --For US CA usertype is 2 ***           
			ORDER BY BookingDate DESC        
		END        
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_ERP_Activity_New] TO [rt_read]
    AS [dbo];

