            
 -- [dbo].[Proc_GetRBTReport] 48536,0,'2024-07-16','2024-07-17'                    
CREATE PROCEDURE [dbo].[Proc_GetRBTReport]                    
@AgentId int = 0 ,                                              
@MainAgentId int = 0,                                          
@FromDate varchar(100)='',                                          
@ToDate varchar(100)=''                          
AS                     
BEGIN                     
 IF @ToDate IN ('',NULL)                     
  SET @ToDate = DATEADD(DAY,1,@FromDate)                                                                                                  
 ELSE                                     
  SET @ToDate = DATEADD(DAY,1,@ToDate);                     
  ---- Voucher Condition--              
                   WITH SourceData AS (  
    SELECT   
        HB.BookingReference AS RIYAPNR,      
  'Hotel' as ProductType,            
  MAG.GroupName as GroupName,    
  B2B.AgencyName as CorporateName,                  
  'Corporate' as CorporateType,                  
  B2B.Icast as CorporateID,                  
  HB.PassengerEmail as EmployeeEmailID,                  
  HB.PassengerPhone as EmployeeMobileNo,  
  HB.LeaderTitle as PAXTitle,                  
  HB.LeaderFirstName as FirstName,                  
  HB.LeaderLastName as LastName,  
  Case 
  WHEN HB.B2BPaymentMode=5 then 'PayAtHotel'
  WHEN HB.B2BPaymentMode=1 then 'Hold'
  WHEN HB.B2BPaymentMode=2 then 'CreditLimit'
  WHEN HB.B2BPaymentMode=3 then 'MakePayment'
  WHEN HB.B2BPaymentMode=4 then 'SelfBalance'
  else '' END as PaymentMode,                  
  '' as RequestedDate,   
  HH.CreateDate as BookedDate,  
  HB.BookingCountry as CountryCode,                  
  HB.CountryName as 'CountryName',   
  HB.HotelName as HotelName,                  
  ISNULL(HB.HotelAddress1,HB.HotelAddress2) AS 'AccommodationAddress',                  
  HB.HotelIncludes +''+HB.Meal AS Inclusion,                    
  HB.CheckInDate AS CheckInDate,                    
  HB.CheckOutDate AS CheckOutDate,                  
  CASE WHEN HB.CheckInTime ='NA' then HB.CheckInTime else HB.ModifiedCheckInTime end as CheckInTime, 
  CASE WHEN HB.CheckOutTime ='NA' then HB.CheckOutTime else HB.ModifiedCheckOutTime end as CheckOutTime,                
  HB.SelectedNights AS RoomNight,                  
  CASE WHEN HB.BookingCountry='IN' THEN 'Domestic' Else 'International' END  AS TravelScope,                                 
  ISNULL(HB.HotelConfNumber,'') as BookingRef,                  
  ISNULL(HB.providerConfirmationNumber,'') as GDSRef,                                
  '' AS RateType,                  
  HB.TotalRoomAmount as BaseFare,                  
  HB.HotelTaxes as TotalTax,                  
  0 as Markup,                  
  HB.AgentCommission as Discount,                  
  HB.agentCancellationCharges as Penalty,                  
  0 as CancellationMarkup,                  
  0 as Breakupoftaxes,                  
  bc.GSTAmount as GST,                  
  HB.AgentServiceFee as serviceFee,                  
  0 as GSTonSF,                  
  bc.TDSDeductedAmount as TDS,                  
  ISNULL(B2BMC.TotalCommission,0) as PGCharges,                  
  0 as GSTonPG,                  
  HB.agentCancellationCharges as CancelCharges,                  
  0 as RescheduleCharges,                  
  HB.STotalRate as NetAmount,                  
  hb.HotelTotalGross as GrossAmount,     
  (cast(HB.DisplayDiscountRate as float) / cast(HB.SelectedNights as float)) as PerNightRate,    
  --case             
  --when  ((ISNULL(HB.TotalRoomAmount,0)) - (isnull(HB.STotalRate,0) * (isnull(HB.ROEValue,0)) ) ) > 0 then ''             
  --when  ((ISNULL(HB.TotalRoomAmount,0)) - (isnull(HB.STotalRate,0) * (isnull(HB.ROEValue,0)) )) = 0  then 0            
  --else ((ISNULL(HB.TotalRoomAmount,0)) - (isnull(HB.STotalRate,0) * (isnull(HB.ROEValue,0)) ) )            
  --end as MissedSavings,     
  hb.ROEValue as ROE,                  
  Isnull(HB.FinalROE,0) as ROECurrency,                  
  isnull(gst.GstNumber,'') as GSTNo,                  
  isnull(gst.Address,'') as GSTAddress,                  
  isnull(gst.EmailId,'') as GSTMailID,                  
  isnull(gst.MobileNo,'') as GSTPhoneNo,     
  '' as ComplainceOrNonComplaince,                  
  '' as TravelPolicies,    
  ''  as 'CompanycodeNonBillable',                  
  '' as Durationoftravel,   
  '' as Natureoftravel,                  
  '' as ProjectCode,   
  '' as COMPANYCODE,            
  '' as Changed_Cost_Centre,   
        HA.Attributes,   
        HA.AttributesValue  
    FROM   
 Hotel_BookMaster HB WITH (NOLOCK)               
 join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and  HH.FkStatusId=4              
 join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                                                                                                                         
 left join B2BHotel_Commission BC on BC.Fk_BookId = hb.pkId                                                                               
 left join tblSelfBalance tbs on tbs.BookingRef = HB.orderId and tbs.UserID = HB.MainAgentID                                         
 left join tblAgentBalance tbla on tbla.BookingRef = HB.orderId  and  tbla.AgentNo = HB.RiyaAgentID                
 left join B2BMakepaymentCommission B2BMC on B2BMC.FkBookId=HB.pkId              
 left join B2BRegistration B2B on B2B.FKUserID=HB.RiyaAgentID              
 left join agentLogin AL on AL.UserID=B2B.FKUserID              
 left join mAgentGroup MAG on MAG.Id=AL.GroupId              
 left join Hotel_BookingGSTDetails gst on gst.PKID=HB.pkId or gst.OrderId=HB.orderId              
 left join Hotel_AttributesData HA on HA.FKBookId=HB.pkId        
where (HB.RiyaAgentID = @AgentId or (HB.MainAgentID = @MainAgentId and HB.MainAgentID > 0))                                              
  and HB.BookingPortal in('TNH','TNHAPI')                       
  and HB.RiyaAgentID is not null                                                                                                                                                 
  and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')   
  
  
  UNION  
  --- Cancelled Booking  
   SELECT   
        HB.BookingReference AS RIYAPNR,      
  'Hotel' as ProductType,            
  MAG.GroupName as GroupName,    
  B2B.AgencyName as CorporateName,                  
  'Corporate' as CorporateType,                  
  B2B.Icast as CorporateID,                  
  HB.PassengerEmail as EmployeeEmailID,                  
  HB.PassengerPhone as EmployeeMobileNo,  
  HB.LeaderTitle as PAXTitle,                  
  HB.LeaderFirstName as FirstName,                  
  HB.LeaderLastName as LastName,  
   Case 
  WHEN HB.B2BPaymentMode=5 then 'PayAtHotel'
  WHEN HB.B2BPaymentMode=1 then 'Hold'
  WHEN HB.B2BPaymentMode=2 then 'CreditLimit'
  WHEN HB.B2BPaymentMode=3 then 'MakePayment'
  WHEN HB.B2BPaymentMode=4 then 'SelfBalance'
  else '' END as PaymentMode,                
  '' as RequestedDate,   
  HH.CreateDate as BookedDate,  
  HB.BookingCountry as CountryCode,                  
  HB.CountryName as 'CountryName',   
  HB.HotelName as HotelName,                  
  ISNULL(HB.HotelAddress1,HB.HotelAddress2) AS 'AccommodationAddress',                  
  HB.HotelIncludes +''+HB.Meal AS Inclusion,                    
  HB.CheckInDate AS CheckInDate,                    
  HB.CheckOutDate AS CheckOutDate,                  
   CASE WHEN HB.CheckInTime ='NA' then HB.CheckInTime else HB.ModifiedCheckInTime end as CheckInTime, 
  CASE WHEN HB.CheckOutTime ='NA' then HB.CheckOutTime else HB.ModifiedCheckOutTime end as CheckOutTime,                       
  HB.SelectedNights AS RoomNight,                  
  CASE WHEN HB.BookingCountry='IN' THEN 'Domestic' Else 'International' END  AS TravelScope,                                 
  ISNULL(HB.HotelConfNumber,'') as BookingRef,                  
  ISNULL(HB.providerConfirmationNumber,'') as GDSRef,                                
  '' AS RateType,                  
  HB.TotalRoomAmount as BaseFare,                  
  HB.HotelTaxes as TotalTax,                  
  0 as Markup,                  
  HB.AgentCommission as Discount,                  
  HB.agentCancellationCharges as Penalty,                  
  0 as CancellationMarkup,                  
  0 as Breakupoftaxes,                  
  bc.GSTAmount as GST,                  
  HB.AgentServiceFee as serviceFee,                  
  0 as GSTonSF,                  
  bc.TDSDeductedAmount as TDS,                  
  ISNULL(B2BMC.TotalCommission,0) as PGCharges,                  
  0 as GSTonPG,                  
  HB.agentCancellationCharges as CancelCharges,       
  0 as RescheduleCharges,                  
  HB.STotalRate as NetAmount,                  
  hb.HotelTotalGross as GrossAmount,     
  (cast(HB.DisplayDiscountRate as float) / cast(HB.SelectedNights as float)) as PerNightRate,    
  --case             
  --when  ((ISNULL(HB.TotalRoomAmount,0)) - (isnull(HB.STotalRate,0) * (isnull(HB.ROEValue,0)) ) ) > 0 then ''             
  --when  ((ISNULL(HB.TotalRoomAmount,0)) - (isnull(HB.STotalRate,0) * (isnull(HB.ROEValue,0)) )) = 0  then 0            
  --else ((ISNULL(HB.TotalRoomAmount,0)) - (isnull(HB.STotalRate,0) * (isnull(HB.ROEValue,0)) ) )            
  --end as MissedSavings,     
  hb.ROEValue as ROE,                  
  Isnull(HB.FinalROE,0) as ROECurrency,                  
  isnull(gst.GstNumber,'') as GSTNo,                  
  isnull(gst.Address,'') as GSTAddress,                  
  isnull(gst.EmailId,'') as GSTMailID,                  
  isnull(gst.MobileNo,'') as GSTPhoneNo,     
  '' as ComplainceOrNonComplaince,                  
  '' as TravelPolicies,    
  ''  as 'CompanycodeNonBillable',                  
  '' as Durationoftravel,   
  '' as Natureoftravel,                  
  '' as ProjectCode,   
  '' as COMPANYCODE,            
  '' as Changed_Cost_Centre,   
        HA.Attributes,   
        HA.AttributesValue  
    FROM   
 Hotel_BookMaster HB WITH (NOLOCK)               
 join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and  HH.FkStatusId=7              
 join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                                                                                                                         
 left join B2BHotel_Commission BC on BC.Fk_BookId = hb.pkId                                                                               
 left join tblSelfBalance tbs on tbs.BookingRef = HB.orderId and tbs.UserID = HB.MainAgentID                                         
 left join tblAgentBalance tbla on tbla.BookingRef = HB.orderId  and  tbla.AgentNo = HB.RiyaAgentID               
 left join B2BMakepaymentCommission B2BMC on B2BMC.FkBookId=HB.pkId              
  left join B2BRegistration B2B on B2B.FKUserID=HB.RiyaAgentID              
 left join agentLogin AL on AL.UserID=B2B.FKUserID              
 left join mAgentGroup MAG on MAG.Id=AL.GroupId              
 left join Hotel_BookingGSTDetails gst on gst.PKID=HB.pkId or gst.OrderId=HB.orderId              
 left join Hotel_AttributesData HA on HA.FKBookId=HB.pkId              
where (HB.RiyaAgentID = @AgentId or (HB.MainAgentID = @MainAgentId and HB.MainAgentID > 0))                     
  and HB.BookingPortal in('TNH','TNHAPI')                       
  and HB.RiyaAgentID is not null                                                                                                               
  and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')     
    --order by HH.CreateDate desc     
)  
SELECT   
    RIYAPNR,  
 ProductType,  
 GroupName,  
 CorporateName,  
    CorporateType,   
 CorporateID,  
 EmployeeEmailID,  
 EmployeeMobileNo,  
 PAXTitle,  
 FirstName,  
 LastName,  
 PaymentMode,  
 RequestedDate,  
 BookedDate,  
 CountryCode,  
 CountryName, 
 HotelName,
 AccommodationAddress,  
 Inclusion,  
 CheckInDate,  
 CheckOutDate,  
 CheckInTime,  
 CheckOutTime,  
 RoomNight,  
 TravelScope,  
 BookingRef,  
 GDSRef,  
 RateType,  
 BaseFare,  
 TotalTax,  
 Markup,  
 Discount,  
 Penalty,  
 CancellationMarkup,  
 Breakupoftaxes,  
 GST,  
 serviceFee,  
 GSTonSF,  
 TDS,  
 PGCharges,  
 GSTonPG,  
 CancelCharges,  
 RescheduleCharges,  
 NetAmount,  
 GrossAmount,  
 PerNightRate,  
 --MissedSavings,  
 ROE,  
 ROECurrency,  
 GSTNo,  
 GSTAddress,  
 GSTMailID,  
 GSTPhoneNo,  
 ComplainceOrNonComplaince,  
 TravelPolicies,  
 CompanycodeNonBillable,  
 Durationoftravel,  
 Natureoftravel,  
 ProjectCode,  
 COMPANYCODE,  
 Changed_Cost_Centre,  
 [Employee Code] AS [EmployeeCode],   
 [Cost Center] AS [CostCenter],   
 [Traveller Type] as [TravellerType],  
 [Booking Type] as [BookingType],  
 [Book App Type] as [BookAppType],  
 [Stock Type] as [StockType],  
 [Approved Date] as [ApprovedDate],  
 [Approve By/E-Approver Booked By] as [Approve By/E-Approver Booked By],  
 [Booked By] as [BookedBy],  
 [Title] as [Title],  
 [Passive Seg Ref] as [Passive Seg Ref],  
 [Capping Limit] as [Capping Limit],  
 [Suggested Lowest Rate] as [Suggested Lowest Rate],  
 [L1 Hotel] as [L1 Hotel],  
 [L1 Rate] as [L1 Rate],  
 [L2 Hotel] as [L2 Hotel],  
 [L2 Rate] as [L2 Rate],  
 [L3 Hotel] as [L3 Hotel],  
 [L3 Rate] as [L3 Rate],  
 [Debit Cost Center] as [Debit Cost Center],  
 [Reference ID] as [Reference ID],  
 [Employee Working Location] as [Employee Working Location],  
 [Reason For Not Selecting Lowest Preferred Hotel] as [Reason For Not Selecting Lowest Preferred Hotel],  
 [SAP Code] as [SapCode],  
 [LOCATION CODE] as [LocationCode],  
 [FUNCTION] as [Function],  
 [Activity] as [Activity],  
 [DEPARTMENT] as [Department],  
 [Sub Department] as [SubDepartment],  
 [JOB BAND] as [JobBand],  
 [LOCATION] as [Location],  
 [COST CENTER DESCRIPTION] as [CostCenterDescription],  
 [CITY] as [City],  
 [DEPARTMENT CODE] as [DepartmentCode],  
 [SBU CODE] as [SbuCode],  
 [CORPORATE] as [Corporate],  
 [VERTICAL NAME] as [VerticalName],  
 [ZONE] as [Zone],  
 [BRANCH] as [Branch],  
 [DIVISION] as [Division],  
 [BAND CODE] as [BandCode],  
 [DESIGNATION] as [Designation],  
 [FUSION ID] as [FusionId],  
 [BUSINESS UNIT] as [BusinessUnit],  
 [COST CODE] as [CostCode],  
 [ENTITY CODE] as [EntityCode],  
 [TRAVEL CLASS] as [TravelClass],  
 [GRADE] as [Grade],  
 [STATE] as [State],  
 [Approver Remarks] as [ApproverRemarks],  
 [Booking Remarks] as [BookingRemarks],  
 [Travel Request No] as [TravelRequestNo]  
   
FROM   
    SourceData  
PIVOT (  
    MAX(AttributesValue)  
    FOR Attributes IN ([Employee Code], [Cost Center],[Trip ID],[Traveller Type],[Booking Type],[Book App Type],  
 [Stock Type],[Approved Date],[Approve By/E-Approver Booked By],[Booked By],[Title],[Passive Seg Ref],[Capping Limit],[Suggested Lowest Rate],[L1 Hotel]  
 ,[L1 Rate],[L2 Hotel],[L2 Rate],[L3 Hotel],[L3 Rate],[Debit Cost Center],[Reference ID],[Employee Working Location],[Reason For Not Selecting Lowest Preferred Hotel],[SAP Code],[LOCATION CODE],[FUNCTION]  
 ,[Activity],[DEPARTMENT],[Sub Department],[JOB BAND],[LOCATION],[COST CENTER DESCRIPTION],[CITY],[DEPARTMENT CODE],[SBU CODE],[CORPORATE],[VERTICAL NAME],[ZONE],[BRANCH],  
 [DIVISION],[BAND CODE],[DESIGNATION],[FUSION ID],[BUSINESS UNIT],[COST CODE],[ENTITY CODE],[TRAVEL CLASS],[GRADE],[STATE],[Traveller Remarks],[Approver Remarks],[Booking Remarks]  
 ,[Travel Request No])  
) AS PivotTable;  
                           
END 