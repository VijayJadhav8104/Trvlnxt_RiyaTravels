
 CREATE Procedure [dbo].[ERPPendingRecords]
 as
 Begin
 IF OBJECT_ID ( 'tempdb..#tempTablePendingERPPush') IS NOT NULL
	DROP TABLE #tempTablePendingERPPush
		SELECT * INTO #tempTablePendingERPPush FROM (
  SELECT TOP 10000 PB.TicketNumber, BM.riyaPNR,nl.FK_tblbookmasterID,
 nl.Request,nl.Response,ED.OwnerCountry, ED.ERPCountry, 'RBT-US-CA' as UserType,   
  isnull(BM.IssueDate, BM.inserteddate) as PostingDate,  
  BM.airCode, BM.Country,  BM.Vendor_No, BM.orderId,  
  Case When AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR'
  FROM tblBookMaster BM WITH (NOLOCK) 
  LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster 
  left join NewERPData_Log nl  WITH (NOLOCK) ON nl.FK_tblbookmasterID= pb.pid
  LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id          
  LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID       LEFT JOIN mUser U on BM.MainAgentId = U.ID          
  LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid  
  LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID          
  LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID and AL.ParentAgentID is null          
  LEFT JOIN B2BRegistration BR1 WITH (NOLOCK) ON AL.ParentAgentID = BR1.FKUserID and AL.ParentAgentID is not null          
  LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode          
  LEFT JOIN tblOwnerCurrency TOC WITH (NOLOCK) ON TOC.OfficeID = BM.OfficeID          
  LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode          
  LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber  
  --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId          
  LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId and BBM.FkBookId= BM.pkId  
  left join tblSSRDetails SSR WITH (NOLOCK) on SSR.fkPassengerid=PB.pid and SSR.fkBookMaster=BM.pkId  and SSR.SSR_Type='Baggage' and SSR.SSR_Status=1 and SSR.SSR_Amount>0   
  left join tblSSRDetails SSR1 WITH (NOLOCK) on SSR1.fkPassengerid=PB.pid and SSR1.fkBookMaster=BM.pkId  and SSR1.SSR_Type='Meals' and SSR1.SSR_Status=1 and SSR1.SSR_Amount>0   
  left join tblSSRDetails SSR2 WITH (NOLOCK) on SSR2.fkPassengerid=PB.pid and SSR2.fkBookMaster=BM.pkId  and SSR2.SSR_Type='Seat' and SSR2.SSR_Status=1 and SSR2.SSR_Amount>0       
  WHERE  
  BM.IsBooked = 1   
  and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)  
  and BM.totalFare > 0 and BM.AgentID != 'B2C'  
  and BM.BookingStatus IN(1,6)  --As confirm with Mansavee          
  and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)             
  and BM.inserteddate > (Getdate()-31) -- '2021-07-31 23:59:59.999'          
  and ED.AgentCountry in ('US','CA','GB')  
  and ED.AgentCountry = BM.Country    
  and ED.ERPCountry = BM.Country  
  and BM.totalFare > 0  
  and AL.userTypeID in (5) --For RBT usertype is 5 ***             
  and BM.VendorName Not in ('STS')  
 -- and BM.riyaPNR in('1H18TO') 
 union 
  SELECT TOP 10000 
 PB.TicketNumber, BM.riyaPNR,nl.FK_tblbookmasterID,
 nl.Request,nl.Response,
 ED.OwnerCountry, ED.ERPCountry, 'B2B-India' as UserType,   
  isnull(BM.IssueDate, BM.inserteddate) as PostingDate,  
  BM.airCode, BM.Country,  BM.Vendor_No, BM.orderId, BM.GDSPNR  
  FROM tblBookMaster BM WITH (NOLOCK)          
   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster          
   left join NewERPData_Log nl  WITH (NOLOCK) ON nl.FK_tblbookmasterID= pb.pid
   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id            
   --LEFT JOIN tblBookItenary BI ON BM.pkId = BI.fkBookMaster    
   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid  
   LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID  
   LEFT JOIN AttributeSpValidation Attsp WITH (NOLOCK) ON BM.AgentID = Attsp.FKUserID and isActive = 1  
   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country          
   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID             
   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID          
   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID             
   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID           
   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode    
   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber  
   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId  
   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'      
   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)  
   and BM.BookingStatus In(1,6) --As confirm with Mansavee          
   -- For Booking          
   and ISNULL(BM.ERPPush,0) = 0  
   and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)          
   and BM.inserteddate > (Getdate()-31) -- '2021-08-31 23:59:59.999'          
   and BM.Country in('IN')   
   and ISNULL(PB.ticketnumber,'') != ''  
   and BM.AgentID not in (48210)  
   and BM.totalFare > 0  
   and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country           
   and AL.userTypeID IN(2) --For B2B usertype is 2 ***  
   --and BM.riyaPNR = 'W2HM07'  
   and BM.VendorName Not in ('STS') 
   Union
   SELECT TOP 10000 
 PB.TicketNumber, BM.riyaPNR,nl.FK_tblbookmasterID,
 nl.Request,nl.Response,ED.OwnerCountry, ED.ERPCountry, 'RBT-IN' as UserType,   
 isnull(BM.IssueDate, BM.inserteddate) as PostingDate,  
  BM.airCode, BM.Country,  BM.Vendor_No, BM.orderId,  
  Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR'        
   FROM tblBookMaster BM WITH (NOLOCK)          
   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster          
   left join NewERPData_Log nl  WITH (NOLOCK) ON nl.FK_tblbookmasterID= pb.pid
   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id            
   --LEFT JOIN tblBookItenary BI ON BM.pkId = BI.fkBookMaster          
   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid  
   LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID          
   LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country          
   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID             
   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID          
   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID             
   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID           
   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode    
   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber  
   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId  
   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'          
   and BM.BookingStatus In(1,6) --As confirm with Mansavee        
   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)  
   -- For Booking          
   and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)          
   and BM.inserteddate > (Getdate()-31) -- '2021-08-31 23:59:59.999'          
   and BM.Country in('IN')  
   and BM.totalFare > 0  
   and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country           
   and AL.userTypeID IN(5) --For B2B usertype is 2 ***      
   and BM.VendorName Not in ('STS')   
   --and BM.riyaPNR = '3TE76F'
   union
    SELECT TOP 10000 
 PB.TicketNumber, BM.riyaPNR,nl.FK_tblbookmasterID,
 nl.Request,nl.Response,ED.OwnerCountry, ED.ERPCountry, 'B2B-US-CA' as UserType,   
 isnull(BM.IssueDate, BM.inserteddate) as PostingDate,  
  BM.airCode, BM.Country,  BM.Vendor_No, BM.orderId,  
  Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR'
    FROM tblBookMaster BM WITH (NOLOCK)  
    LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster          
	left join NewERPData_Log nl  WITH (NOLOCK) ON nl.FK_tblbookmasterID= pb.pid
    LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id     
    LEFT JOIN Paymentmaster PM1 WITH (NOLOCK) ON BM.orderId = PM1.ParentOrderId  
    LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID       LEFT JOIN mUser U on BM.MainAgentId = U.ID          
    LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid  
    LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID          
    LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID and AL.ParentAgentID is null          
    LEFT JOIN B2BRegistration BR1 WITH (NOLOCK) ON AL.ParentAgentID = BR1.FKUserID and AL.ParentAgentID is not null          
    LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode          
    LEFT JOIN tblOwnerCurrency TOC WITH (NOLOCK) ON TOC.OfficeID = BM.OfficeID          
    LEFT JOIN AirlineMaster AM WITH (NOLOCK) ON AM.Airlinecode = BM.airCode and AM.Status = 'A'         
    LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber  
    --LEFT JOIN tblBookItenary BI ON BM.orderId = BM.orderId          
    LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId  
    left join tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1          
    WHERE  
    BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'        
    and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)  
    and BM.BookingStatus IN(1,6)  --As confirm with Mansavee          
   and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)             
    and BM.inserteddate > (Getdate()-31) -- '2021-07-31 23:59:59.999'          
    and ED.AgentCountry in ('US','CA')--('IN','AE','US','CA')     
    and ED.AgentCountry = BM.Country  and ED.ERPCountry = BM.Country          
    and AL.userTypeID in (2) --For US usertype is 2 ***         
    and BM.VendorName Not in ('STS')  
    and BM.totalFare > 0  
    --and PB.ticketnumber != null  
   -- and BM.riyaPNR in ('2H77Y3')  
   --and BM.GDSPNR = '36BGXH'  
Union
SELECT TOP 10000 
  PB.TicketNumber, BM.riyaPNR,nl.FK_tblbookmasterID,
 nl.Request,nl.Response,ED.OwnerCountry, ED.ERPCountry, 'UAE_SA' as UserType,   
 isnull(BM.IssueDate, BM.inserteddate) as PostingDate,  
  BM.airCode, BM.Country,  BM.Vendor_No, BM.orderId,  
Case when AC.type ='FSC' then BM.GDSPNR 
when BM.VendorName ='Amadeus' then BM.GDSPNR else LEFT(PB.TicketNumber, 6) 
  end as 'GDSPNR'               
   FROM tblBookMaster BM WITH (NOLOCK)  
   LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster          
   	left join NewERPData_Log nl  WITH (NOLOCK) ON nl.FK_tblbookmasterID= pb.pid
   LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id          
  -- LEFT JOIN tblBookItenary BI ON BM.orderId = BI.orderId          
   --LEFT JOIN tblBookItenary BI ON BM.pkId = BI.pkId          
   LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid  
   LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID          
   LEFT JOIN tblERPDetails ED WITH (NOLOCK)   
     ON ( BM.OfficeID = ED.OwnerID and ED.AgentCountry=BM.Country )   
    OR (BM.TicketingPCC IS not NULL AND BM.TicketingPCC = ED.OwnerID and ED.AgentCountry=BM.Country)             
   LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID             
   Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID          
   LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID      
   LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber  
   LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) 
   on (BM.OfficeID = CU.OfficeID) 
        OR (BM.TicketingPCC IS not NULL AND BM.TicketingPCC = CU.OfficeID)
   LEFT JOIN B2BRegistration B2BR1 WITH (NOLOCK) ON AL.ParentAgentID = B2BR1.FKUserID  
   LEFT JOIN TblErpVendorCode EV WITH (NOLOCK) on BM.OfficeID = EV.OfficeID and ED.AgentCountry in ('AE')  
   LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode      
   LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId  
   left join tblSSRDetails SSR WITH (NOLOCK) on ssr.fkPassengerid=PB.pid and SSR_Type='Baggage' and SSR_Status=1  
   WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'  
   and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)  
   and BM.BookingStatus In (1,6) --As confirm with Mansavee          
   -- For Booking  
   and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)          
   and BM.inserteddate > (Getdate()-31) -- '2021-08-31 23:59:59.999'          
   and BM.Country in('AE','SA')          
   and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country           
   and AL.userTypeID IN(2,3,5) --For UAE usertype is 2 ***    --- 3 is for marine uae and 5 is for RBT  
   and ISNULL(PB.TicketNumber,'') != ''  
   and (B2BR.FKUserID not in (49932,51685) or B2BR1.FKUserID not in (49932,51685))  
   and BM.totalFare > 0  
  -- and BM.riyaPNR IN('H1MK95')  
   and BM.VendorName Not in ('STS')
   Union
    SELECT TOP 10000
  PB.TicketNumber, BM.riyaPNR,nl.FK_tblbookmasterID,
 nl.Request,nl.Response,ED.OwnerCountry, ED.ERPCountry, 'Holiday' as UserType,   
 isnull(BM.IssueDate, BM.inserteddate) as PostingDate,  
  BM.airCode, BM.Country,  BM.Vendor_No, BM.orderId,  
Case when AC.type ='FSC' then BM.GDSPNR  else LEFT(PB.TicketNumber, 6)  end as 'GDSPNR'
   FROM tblBookMaster BM WITH (NOLOCK)  
    LEFT JOIN tblPassengerBookDetails PB WITH (NOLOCK) ON BM.pkId = PB.fkBookMaster          
	left join NewERPData_Log nl  WITH (NOLOCK) ON nl.FK_tblbookmasterID= pb.pid
    LEFT JOIN Paymentmaster PM WITH (NOLOCK) ON BM.orderId = PM.order_id          
    --LEFT JOIN tblBookItenary BI WITH (NOLOCK) ON BM.orderId = BI.orderId          
    LEFT JOIN mAttrributesDetails ATT WITH (NOLOCK) ON PB.pid = ATT.fkPassengerid  
    LEFT JOIN B2BRegistration B2BR WITH (NOLOCK) ON BM.AgentID = B2BR.FKUserID          
    LEFT JOIN tblERPDetails ED WITH (NOLOCK) ON BM.OfficeID = ED.OwnerID             
    LEFT JOIN agentLogin AL WITH (NOLOCK) ON  AL.UserID = BM.AgentID 
	left join agentlogin al1 on al1.userid=al.ParentAgentID
	left join b2bregistration b2b1 on al.ParentAgentID = b2b1.FKUserID
    Left Join PNRRetriveDetails PR WITH (NOLOCK) on BM.orderId = PR.OrderID  
    LEFT JOIN tblInterBranchWinyatra IBM WITH (NOLOCK)
ON ( 
    (B2BR.StateID = IBM.fkStateId AND IBM.Country = 'IN') 
    OR 
    (B2BR.StateID IS NULL AND B2B1.StateID = IBM.fkStateId AND IBM.Country = 'IN')
)  
    LEFT JOIN mUser U WITH (NOLOCK) on BM.MainAgentId = U.ID             
    LEFT JOIN tblOwnerCurrency CU WITH (NOLOCK) on BM.OfficeID = CU.OfficeID           
    LEFT JOIN AirlineCode_Console AC WITH (NOLOCK) ON AC.Airlinecode = BM.airCode          
    LEFT Join mCardDetails CD WITH (NOLOCK) ON CD.CardNumber = PM.EnCardNumber  
    LEFT Join B2BMakepaymentCommission BBM WITH (NOLOCK) on BBM.orderId = BM.OrderId  
    WHERE BM.IsBooked =1 and BM.totalFare > 0 and BM.AgentID != 'B2C'          
    and (BM.Isfakebooking = 0 or BM.Isfakebooking is null)  
    and BM.BookingStatus In (1,6) --= 4 For Cancellation  =1 For Booking  --As confirm with Mansavee          
    -- For Booking          
    and PB.ERPResponseID is null and (PB.ERPPuststatus = 0 or PB.ERPPuststatus is null)          
    and BM.inserteddate > (Getdate()-62) -- '2021-08-31 23:59:59.999'          
    --and BM.Country in('IN','AE','US','CA')  // Commented As Discussed With Pranay & Bhavika          
    and ED.AgentCountry = BM.Country and ED.ERPCountry = BM.Country  
    and BM.totalFare > 0  
  and AL.userTypeID IN(4) --For Holiday usertype is 4 ***     
   -- and BM.riyaPNR='3YNJ39'  
    and BM.VendorName Not in ('STS')   

   ORDER BY BM.inserteddate DESC  
) p
select * from #tempTablePendingERPPush Order by postingdate desc
  END