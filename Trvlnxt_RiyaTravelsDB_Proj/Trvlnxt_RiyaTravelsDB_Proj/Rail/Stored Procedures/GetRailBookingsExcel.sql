--[Rail].[GetRailBookingsExcel] '','2023-10-09','2023-10-10','','','','','CREATED'                
                
CREATE PROCEDURE [Rail].[GetRailBookingsExcel]                    
 @Id int=0,                    
 @BookingFromDate varchar(50)='',                                                  
 @BookingToDate varchar(50)='',                    
 @RiyaUserID nvarchar(200)='',                                                  
 @Branch nvarchar(200)='',                                                  
 @Agent nvarchar(200)='',                    
 @BookingID nvarchar(200)='',                  
 @Status nvarchar(200)='',              
 @RiyaPnr varchar(50)=''              
AS                    
BEGIN                    
IF OBJECT_ID(N'tempdb..#bookingExcel') IS NOT NULL                    
BEGIN                    
DROP TABLE #bookingExcel                    
END                    
 if(@Status ='All' )                  
Begin                  
select * into #bookingExcel from (SELECT DISTINCT                     
  'EURAIL' as 'Service',                    
  isnull(bk.RiyaPnr,'')as 'RiyaPnr',                    
  bki.bookingReference as 'BookingReference',                    
  bk.BookingId ,                  
  bki.bookingItemId,                  
  '--' as'Order ID',                    
   --MB.Name as'Branch',                    
  b2b.BranchCode,                    
  b2b.AgencyName,                    
  usr.UserName as 'UserID',                    
  usr.FullName as 'UserName',      
   CASE                  WHEN  ISNULL(LTRIM(RTRIM(B2B.BillingID)), '') <> ''                  THEN ISNULL(B2B.Icast, 'NA') +' ' + ' /' +' ' + B2B.BillingID                  ELSE ISNULL(B2B.Icast, 'NA')              END AS 'AgentId' ,      
  --bk.AgentId,                    
  (select top 1 pax.FirstName +' '+ pax.LastName from Rail.PaxDetails pax where pax.fk_ItemId=bki.Id) as 'LeaderName',    
  --FORMAT(CAST(pax.dateOfBirth AS datetime),'dd MMM yyyy hh:mm tt') as dateOfBirth,     
  pax.dateOfBirth,                  
  pax.PassportNumber,                    
 pax.Pan as 'PanNumber',                    
 pax.PanName as 'PanName',    
  
      
 pax.IssueDate,                    
 pax.ExpiryDate,                    
  bk.creationDate as 'BookingDate',                    
  bk.expirationDate as 'CheckOutDate',                    
  bki.Departure as'TravelDate',                    
  bki.Destination as 'Destination',                    
  bki.Type as 'TicketType',                    
  bki.activationPeriodStart as 'ActivationPeriodStart',                    
  bki.activationPeriodEnd as 'ActivationPeriodEnd',                    
  bki.validityPeriodStart as 'ValidityPeriodStart',                    
  bki.validityPeriodEnd as 'ValidityPeriodEnd',                    
 '--' as'Deadline',                  
  CASE                   
 WHEN bk.bookingStatus = 'INVOICED'                  
 THEN 'CONFIRMED'                  
 WHEN bk.bookingStatus = 'PREBOOKED'                  
 THEN 'ON-HOLD'                  
 WHEN bk.bookingStatus = 'MODIFIED'                  
 THEN 'MODIFIED'                
 WHEN bk.bookingStatus = 'CREATED'                
 THEN 'CREATED'                
 END AS [CurrentStatus],                
 bk.bookingStatus,                
 -- bki.Status as [CurrentStatus],                    
 bk.AmountPaidbyAgent as 'BookingAmount',                    
 bki.Currency as 'BookingCurrency',                    
 bki.AgentCommission as 'AgentCommission',                     
 bki.AgentAmount As 'AgentAmount',                    
 bki.RiyaCommission as 'RiyaCommission',                    
 bki.RiyaAmount as 'RiyaAmount',                    
  bk.PaymentMode as 'ModeOfPayment',                    
 bk.PaymentType 'PaymentGatewayType',                    
 b2b.GST_No as 'GSTNumber',                    
 bki.Currency,                    
 bki.AgentCurrency,                    
 bki.ROE,                    
 bki.FinalROE,                    
 '----' as 'Supplierrate (INR)',                    
 b2b.AddrCity as 'City',                    
 bki.Country as'Country',                    
   bki.numberOfTravelDays,                    
 bk.OBTCNo,                    
                     
 bk.BookingFee,                    
 bk.BFFinalROE,                  
 bk.BFROE,                  
 '0' as 'MarkUpOnBookingFee',                
 '0' as 'TaxOnBookingFee',                    
 (bk.AmountPaidbyAgent - ((bk.AmountPaidbyAgent)/((PGM.Charges/100) + 1))) as PaymentGatewayCharge,                    
  Round((bki.RiyaAmount)*(bki.FinalROE),2) as NetAmountINR,                  
 Round((bk.BookingFee)*(bk.BFFinalROE),2) as BookingFeesINR,                   
   bki.SupplierToInrROE,                
 --bki.SupplierToInrMarkup,                
 bki.SupplierToInrFinal,                
 bki.AgentToInrROE --bki.AgentToInrMarkup, bki.AgentToInrFinal                
                     
  FROM Rail.Bookings bk                    
  inner JOIN AgentLogin al ON bk.AgentId = al.UserID                   
  left JOIN B2BRegistration b2b ON bk.AgentId = b2b.FKUserID                    
  inner JOIN RAIL.BookingItems bki ON bk.Id=bki.fk_bookingId                    
  --inner join rail.PaxDetails pax on  pax.bookingItemId=bki.bookingItemId                
 --inner join Rail.PaxDetails pax on pax.fk_ItemId = bki.Id                
 inner join Rail.PaxDetails pax on CASE         
WHEN bki.isRoundTrip = 1 AND pax.bookingItemId=bki.bookingItemId THEN 1        
WHEN bki.isRoundTrip = 0 AND pax.fk_ItemId = bki.Id THEN 1        
ELSE 0        
END = 1        
  --inner JOIN  mBranch MB on MB.BranchCode=b2b.BranchCode                     
  Left join PaymentGatewayMode PGM on bk.PaymentMode = PGM.Mode                     
  LEFT JOIN mUser usr ON bk.RiyaUserId = usr.ID                      
  where                     
                
  (( @RiyaUserID ='') or (bk.RiyaUserId IN  (select Data from sample_split(@RiyaUserID,','))) )                        
  And (( @Branch ='') or (b2b.BranchCode IN  (select Data from sample_split(@Branch,','))) )                       
  And ((@Agent ='') or (bk.AgentID IN  (select Data from sample_split(@Agent,','))) )                   
   --And ((@Status='') or (bk.bookingStatus IN (select Data from sample_Split(@Status,','))) )                  
  And ((@BookingID ='') or (bk.BookingReference = @BookingID))                    
  And (PGM.PGID = 2 or PGM.PGID is null)                    
-- and bk.bookingStatus = 'CREATED'                   
 and pax.leadTraveler=1                   
 and (@BookingFromDate = '' or Convert(date,bk.creationDate) >= Convert(date,@BookingFromDate))                  
 and (@BookingToDate = '' or Convert(date,bk.creationDate) <= Convert(date,@BookingToDate))                  
     And ((@RiyaPnr='')or (bk.RiyaPnr=@RiyaPnr))              
  )as bookings                    
                    
                    
  ;with cte as(                    
  select ROW_NUMBER() OVER(PARTITION BY BookingId                      
       ORDER BY [BookingAmount] DESC) as TransactionNumber, *  from #bookingExcel)                    
                    
    select                     
      Service,RiyaPnr,[BookingReference],BookingId ,BranchCode, AgencyName,UserID,[UserName],AgentId,[LeaderName],dateOfBirth,PassportNumber,[PanNumber],[PanName],    
   IssueDate,ExpiryDate,[BookingDate],[CheckOutDate],[TravelDate],  
 
   Destination,[TicketType],  
   [ActivationPeriodStart], [ActivationPeriodEnd], [ValidityPeriodStart], [ValidityPeriodEnd],   
   [CurrentStatus],bookingStatus,                    
  [BookingCurrency], [AgentCommission], [RiyaCommission],[AgentAmount],[RiyaAmount],[ModeOfPayment],[PaymentGatewayType],[GSTNumber],Currency,AgentCurrency,ROE,FinalROE,[City],                    
  [Country],numberOfTravelDays,OBTCNo,[MarkUpOnBookingFee], [TaxOnBookingFee],BFFinalROE,BFROE,bookingItemId,NetAmountINR,                     
      (case when TransactionNumber  = 1 then CAST(BookingFeesINR as varchar) when TransactionNumber >1 then '' end) as BookingFeesINR,                    
      (case when TransactionNumber  = 1 then CAST(BookingFee as varchar) when TransactionNumber >1 then '' end) as BookingFee,                  
    (case when TransactionNumber  = 1 then CAST([BookingAmount] as varchar) when TransactionNumber >1 then '' end) as [BookingAmount],                    
    --(case when TransactionNumber  = 1 then CAST(MarkUpOnBookingFee as varchar) when TransactionNumber >1 then '' end) as MarkUpOnBookingFee,                    
     --(case when TransactionNumber  = 1 then CAST(TaxOnBookingFee as varchar)  when TransactionNumber >1 then '' end) as TaxOnBookingFee,                    
   (case when TransactionNumber  = 1 then CAST(PaymentGatewayCharge as varchar)  when TransactionNumber >1 then '' end) as PaymentGatewayCharge,                
     SupplierToInrROE,                
 --SupplierToInrMarkup,                
 SupplierToInrFinal,                
 AgentToInrROE --AgentToInrMarkup, AgentToInrFinal                
     from cte  order by RiyaPnr desc                  
    DROP TABLE #bookingExcel               
  END                    
  if(@Status !='All' )                  
Begin                  
select * into #bookingExcel1 from (SELECT DISTINCT                     
  'EURAIL' as 'Service',                    
  isnull(bk.RiyaPnr,'')as 'RiyaPnr',                    
  bki.bookingReference as 'BookingReference',                    
  bk.BookingId ,                   
  bki.bookingItemId,                  
  -- MB.Name as'Branch',                    
  b2b.BranchCode,                    
  b2b.AgencyName,       
   CASE                  WHEN  ISNULL(LTRIM(RTRIM(B2B.BillingID)), '') <> ''                  THEN ISNULL(B2B.Icast, 'NA') +' ' + ' /' +' ' + B2B.BillingID                  ELSE ISNULL(B2B.Icast, 'NA')              END AS 'AgentId' ,      
 -- bk.AgentId,                    
  usr.UserName as 'UserID',                    
  usr.FullName as 'UserName',                    
  (select top 1 pax.FirstName +' '+ pax.LastName from Rail.PaxDetails pax where pax.fk_ItemId=bki.Id) as 'LeaderName',                   
  pax.dateOfBirth,     
    --FORMAT(CAST(pax.dateOfBirth AS datetime),'dd MMM yyyy') as dateOfBirth,     
  pax.PassportNumber,                    
 pax.Pan as 'PanNumber',                    
 pax.PanName as 'PanName',       
   
     
 pax.IssueDate,                    
 pax.ExpiryDate,                    
  bk.creationDate as 'BookingDate',                    
  bk.expirationDate as 'CheckOutDate',                    
  bki.Departure as'TravelDate',                    
  bki.Destination as 'Destination',                    
  bki.Type as 'TicketType',                    
  bki.activationPeriodStart as 'ActivationPeriodStart',     
  bki.activationPeriodEnd as 'ActivationPeriodEnd',                    
  bki.validityPeriodStart as 'ValidityPeriodStart',                    
  bki.validityPeriodEnd as 'ValidityPeriodEnd',                    
 '--' as'Deadline',                  
  CASE                   
 WHEN bk.bookingStatus = 'INVOICED'                  
 THEN 'CONFIRMED'                  
 WHEN bk.bookingStatus = 'PREBOOKED'                  
 THEN 'ON-HOLD'                  
 WHEN bk.bookingStatus = 'MODIFIED'                  
 THEN 'MODIFIED'                
 WHEN bk.bookingStatus = 'CREATED'                
 THEN 'CREATED'                
 END AS [CurrentStatus],                
 bk.bookingStatus,                
 bk.AmountPaidbyAgent as 'BookingAmount',                    
 bki.Currency as 'BookingCurrency',                  
  bki.Currency,                    
 bki.AgentCurrency,                  
 bki.AgentCommission as 'AgentCommission',                     
 bki.AgentAmount As 'AgentAmount',                    
 bki.RiyaCommission as 'RiyaCommission',                    
 bki.RiyaAmount as 'RiyaAmount',                    
  bk.PaymentMode as 'ModeOfPayment',                    
 bk.PaymentType 'PaymentGatewayType',                    
 b2b.GST_No as 'GSTNumber',                    
 bki.ROE,                    
 bki.FinalROE,                    
 bk.BFFinalROE,                  
 bk.BFROE,                  
 '----' as 'Supplierrate (INR)',                    
 b2b.AddrCity as 'City',                    
 bki.Country as'Country',                    
   bki.numberOfTravelDays,                    
 bk.OBTCNo,                    
                     
 bk.BookingFee,                    
 '0' as 'MarkUpOnBookingFee',                    
 '0' as 'TaxOnBookingFee',                    
 (bk.AmountPaidbyAgent - ((bk.AmountPaidbyAgent)/((PGM.Charges/100) + 1))) as PaymentGatewayCharge,                   
 Round((bki.RiyaAmount)*(bki.FinalROE),2) as NetAmountINR,                  
 Round((bk.BookingFee)*(bk.BFFinalROE),2) as BookingFeesINR,                    
     bki.SupplierToInrROE,         
 --bki.SupplierToInrMarkup,                
 bki.SupplierToInrFinal,                
 bki.AgentToInrROE --bki.AgentToInrMarkup, bki.AgentToInrFinal                
                     
  FROM Rail.Bookings bk                    
  inner JOIN AgentLogin al ON bk.AgentId = al.UserID                    
  left JOIN B2BRegistration b2b ON bk.AgentId = b2b.FKUserID                    
  inner JOIN RAIL.BookingItems bki ON bk.Id=bki.fk_bookingId                    
  --inner join Rail.PaxDetails pax on pax.fk_ItemId = bki.Id                
  --inner join rail.PaxDetails pax on  pax.bookingItemId=bki.bookingItemId         
   inner join Rail.PaxDetails pax on CASE         
WHEN bki.isRoundTrip = 1 AND pax.bookingItemId=bki.bookingItemId THEN 1        
WHEN bki.isRoundTrip = 0 AND pax.fk_ItemId = bki.Id THEN 1        
ELSE 0        
END = 1        
 -- inner JOIN  mBranch MB on MB.BranchCode=b2b.BranchCode                     
  Left join PaymentGatewayMode PGM on bk.PaymentMode = PGM.Mode                     
  LEFT JOIN mUser usr ON bk.RiyaUserId = usr.ID                      
  where                     
                       
  (( @RiyaUserID ='') or (bk.RiyaUserId IN  (select Data from sample_split(@RiyaUserID,','))) )                        
  And (( @Branch ='') or (b2b.BranchCode IN  (select Data from sample_split(@Branch,','))) )                       
  And ((@Agent ='') or (bk.AgentID IN  (select Data from sample_split(@Agent,','))) )                   
   And ((@Status='') or (bk.bookingStatus IN (select Data from sample_Split(@Status,','))) )                  
  And ((@BookingID ='') or (bk.BookingReference = @BookingID))                    
  And (PGM.PGID = 2 or PGM.PGID is null)                    
 --and bk.bookingStatus != 'CREATED'                   
 and pax.leadTraveler=1                    
 and (@BookingFromDate = '' or Convert(date,bk.creationDate) >= Convert(date,@BookingFromDate))                  
 and (@BookingToDate = '' or Convert(date,bk.creationDate) <= Convert(date,@BookingToDate))                  
      And ((@RiyaPnr='')or (bk.RiyaPnr=@RiyaPnr))              
  )as bookings                    
                    
                    
  ;with cte as(                    
  select ROW_NUMBER() OVER(PARTITION BY BookingId                      
       ORDER BY [BookingAmount] DESC) as TransactionNumber, *  from #bookingExcel1 )                    
                    
    select                     
      Service,RiyaPnr,[BookingReference],BookingId ,BranchCode, AgencyName,UserID,[UserName],AgentId,[LeaderName],  
   dateOfBirth,  
   PassportNumber,[PanNumber],[PanName],  
  
   IssueDate,ExpiryDate,[BookingDate],[CheckOutDate],[TravelDate],  
  Destination,[TicketType],  
  [ActivationPeriodStart],[ActivationPeriodEnd], [ValidityPeriodStart], [ValidityPeriodEnd],   
  [CurrentStatus],bookingStatus,                    
  [BookingCurrency], [AgentCommission], [RiyaCommission],[AgentAmount],[RiyaAmount],[ModeOfPayment],[PaymentGatewayType],[GSTNumber],Currency,AgentCurrency,ROE,FinalROE,[City],                    
  [Country],numberOfTravelDays,OBTCNo,[MarkUpOnBookingFee], [TaxOnBookingFee],BFFinalROE,BFROE,bookingItemId, NetAmountINR,                    
      (case when TransactionNumber  = 1 then CAST(BookingFeesINR as varchar) when TransactionNumber >1 then '' end) as BookingFeesINR,                    
      (case when TransactionNumber  = 1 then CAST(BookingFee as varchar) when TransactionNumber >1 then '' end) as BookingFee,                  
    (case when TransactionNumber  = 1 then CAST([BookingAmount] as varchar) when TransactionNumber >1 then '' end) as [BookingAmount],                    
    --(case when TransactionNumber  = 1 then CAST(MarkUpOnBookingFee as varchar) when TransactionNumber >1 then '' end) as MarkUpOnBookingFee,                    
     --(case when TransactionNumber  = 1 then CAST(TaxOnBookingFee as varchar)  when TransactionNumber >1 then '' end) as TaxOnBookingFee,                    
   (case when TransactionNumber  = 1 then CAST(PaymentGatewayCharge as varchar)  when TransactionNumber >1 then '' end) as PaymentGatewayCharge,                
     SupplierToInrROE,                
 --SupplierToInrMarkup,                
 SupplierToInrFinal,                
 AgentToInrROE --AgentToInrMarkup, AgentToInrFinal                
     from cte  order by RiyaPnr desc                  
DROP TABLE #bookingExcel1                    
END                    
  END                    
  --[Rail].[GetRailBookingsExcel] '','2023-10-17','2023-10-17','','','','','CREATED';                  
  --[Rail].[GetRailBookingsExcel] '','','','','','','','CREATED';                  
                  
  --[Rail].[GetRailBookingsExcel] '','','','','','','','','';                   
                    
  --select * from rail.Bookings where creationDate between Convert(varchar(12),Convert(datetime,'01/10/2023',103),102) and Convert(varchar(12),Convert(datetime,'10/10/2023',103),102)                  
                  
  --select * from rail.Bookings where Convert(date,creationDate) between Convert(date, '2023-10-09') and Convert(date, '2023-10-10') and bookingStatus='INVOICED' order by creationDate desc 