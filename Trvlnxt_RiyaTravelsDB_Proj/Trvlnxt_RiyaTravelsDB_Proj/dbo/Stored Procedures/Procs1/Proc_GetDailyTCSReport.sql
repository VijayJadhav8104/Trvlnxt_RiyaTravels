    
--[dbo].[Proc_GetDailyTCSAndRBTReport]    
CREATE Procedure Proc_GetDailyTCSReport              
As        
Begin        
   
  WITH SourceData AS (          
    SELECT           
        HB.LeaderFirstName+' '+HB.LeaderLastName AS NameOfEmployee,       
  '' as InvoiceNo,      
  ISNULL(mu.FullName,'') as Travelofficer,    
  '' as AirTicketingVendor,      
  '' as FromCity,      
  HB.cityName as ToCity,      
  HB.CheckInDate as CheckInDate,      
  HB.CheckOutDate as CheckOutDate,      
  HPM.RoomType as RoomCategory,      
  --HPM.RoomType as RoomType,      
  HB.SelectedNights as NoOfNightsAtHotel,      
  HB.SCurrency as Currency,      
  cast(HB.SBaseRate as float) / cast(HB.SelectedNights as float) as RoomRatePerNightInForeignCurrencyExcludingTax,      
  cast(HB.HotelTaxes as float) / cast(HB.SelectedNights as float) as TaxPerNightInForeignCurrency,  --pending    
  HB.SBaseRate as TotalInForeignCurrencyExcludingTax,      
  HB.HotelTaxes as TotalTaxInForeignCurrency,  --Pending    
  HB.STotalRate as TotalAmountInForeignCurrencyIncludingManagementFee,      
  '0' as RoomRateNightINRExcludingTax,      
  '0' as TotalINRExcludingTax,      
  '0' as TotalTaxINR,      
  '0' as TotalAmountRoomRentTaxINR,      
  HB.ChainName as HotelGroup,      
  HB.HotelName as HotelBrand,      
  HB.HotelPostalCode as Zipcode,      
  HB.HotelName as HotelName,      
  HB.HotelAddress1 AS HotelAddress,      
  '' as Comments,      
  --'' as CorporateOrNonCorporateRate,      
  --'' as CorporateCode,      
  --'' as ManagementFee,      
  'Riya' as Vendor,      
  HM.Status as [Status],      
  HB.BookingReference as BookingID,      
  HB.HotelConfNumber as BookingConfirmation,    
  HB.SupplierReferenceNo as GDSPNR,    
        HA.Attributes,           
        HA.AttributesValue          
    FROM           
 Hotel_BookMaster HB WITH (NOLOCK)                       
 join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and  HH.FkStatusId=4                      
 join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                                                                                                                                 
 left join B2BHotel_Commission BC on BC.Fk_BookId = hb.pkId       
 left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1      
 left join tblSelfBalance tbs on tbs.BookingRef = HB.orderId and tbs.UserID = HB.MainAgentID                                                 
 left join tblAgentBalance tbla on tbla.BookingRef = HB.orderId  and  tbla.AgentNo = HB.RiyaAgentID                        
 left join B2BMakepaymentCommission B2BMC on B2BMC.FkBookId=HB.pkId                      
 left join B2BRegistration B2B on B2B.FKUserID=HB.RiyaAgentID                      
 left join agentLogin AL on AL.UserID=B2B.FKUserID       
 left join mUser mu on mu.ID=HB.MainAgentID     
 left join mAgentGroup MAG on MAG.Id=AL.GroupId                      
 left join Hotel_BookingGSTDetails gst on gst.PKID=HB.pkId or gst.OrderId=HB.orderId                      
 left join Hotel_AttributesData HA on HA.FKBookId=HB.pkId                
where  AL.userTypeID=5  and B2B.EntityName='TATA CONSULTANCY SERVICES LIMITED'                                                       
  and HB.BookingPortal in('TNH','TNHAPI')                                 
  and HB.RiyaAgentID is not null                                                                                                                                                           
  --and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')     
  and (Convert(date,HH.CreateDate) >= Convert(date,getdate()))                
          
          
  UNION          
  --- Cancelled Booking          
   SELECT           
         HB.LeaderFirstName+' '+HB.LeaderLastName AS NameOfEmployee,         
   '' as InvoiceNo,    
   ISNULL(mu.FullName,'') as Travelofficer,    
   '' as AirTicketingVendor,      
   '' as FromCity,      
   HB.cityName as ToCity,     
   HB.CheckInDate as CheckInDate,      
   HB.CheckOutDate as CheckOutDate,      
   HPM.RoomType as RoomCategory,      
   --HPM.RoomType as RoomType,      
   HB.SelectedNights as NoOfNightsAtHotel,      
   HB.SCurrency as Currency,      
   cast(HB.SBaseRate as float) / cast(HB.SelectedNights as float) as RoomRatePerNightInForeignCurrencyExcludingTax,      
   cast(HB.HotelTaxes as float) / cast(HB.SelectedNights as float) as TaxPerNightInForeignCurrency,      
   HB.SBaseRate as TotalInForeignCurrencyExcludingTax,      
   HB.HotelTaxes as TotalTaxInForeignCurrency,      
   HB.STotalRate as TotalAmountInForeignCurrencyIncludingManagementFee,      
   '0' as RoomRateNightINRExcludingTax,      
   '0' as TotalINRExcludingTax,      
   '0' as TotalTaxINR,      
   '0' as TotalAmountRoomRentTaxINR,      
   HB.ChainName as HotelGroup,      
   HB.HotelName as HotelBrand,      
   HB.HotelPostalCode as Zipcode,      
   HB.HotelName as HotelName,      
   HB.HotelAddress1 AS HotelAddress,      
   '' as Comments,      
   --'' as CorporateOrNonCorporateRate,      
   --'' as CorporateCode,      
   --'' as ManagementFee,      
   'Riya' as Vendor,      
   HM.Status as [Status],      
   HB.BookingReference as BookingID,      
   HB.HotelConfNumber as BookingConfirmation,    
   HB.SupplierReferenceNo as GDSPNR,    
        HA.Attributes,           
        HA.AttributesValue          
    FROM           
 Hotel_BookMaster HB WITH (NOLOCK)                       
 join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and  HH.FkStatusId=7                      
 join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                                                                                                                                 
 left join B2BHotel_Commission BC on BC.Fk_BookId = hb.pkId        
 left join Hotel_Pax_master HPM on HPM.book_fk_id=HB.pkId and HPM.IsLeadPax=1      
 left join tblSelfBalance tbs on tbs.BookingRef = HB.orderId and tbs.UserID = HB.MainAgentID                                                 
 left join tblAgentBalance tbla on tbla.BookingRef = HB.orderId  and  tbla.AgentNo = HB.RiyaAgentID                       
 left join B2BMakepaymentCommission B2BMC on B2BMC.FkBookId=HB.pkId                      
  left join B2BRegistration B2B on B2B.FKUserID=HB.RiyaAgentID                      
 left join agentLogin AL on AL.UserID=B2B.FKUserID     
 left join mUser mu on mu.ID=HB.MainAgentID     
 left join mAgentGroup MAG on MAG.Id=AL.GroupId                      
 left join Hotel_BookingGSTDetails gst on gst.PKID=HB.pkId or gst.OrderId=HB.orderId                      
 left join Hotel_AttributesData HA on HA.FKBookId=HB.pkId                      
where AL.userTypeID=5  and B2B.EntityName='TATA CONSULTANCY SERVICES LIMITED'                                
  and HB.BookingPortal in('TNH','TNHAPI')                                 
  and HB.RiyaAgentID is not null                                                                                                                         
 and (Convert(date,HH.CreateDate) >= Convert(date,getdate()))          
    --order by HH.CreateDate desc             
)          
SELECT          
          
    [RequestNo] as [RequestNo],          
 '' as [GESSReceivedDate],      
 NameOfEmployee,      
 [EmployeeNo] as [EmployeeNo],      
 [SWONNo] as [SWONNo],      
 InvoiceNo,      
 --[Travel officer] as [Travel officer],      
 Travelofficer,    
 AirTicketingVendor,      
 FromCity,      
 ToCity,      
 CheckInDate,      
 CheckOutDate,      
 RoomCategory,      
 --RoomType,      
 [RoomType Attribute] as [RoomType Attribute],    
 NoOfNightsAtHotel,      
 Currency,      
 RoomRatePerNightInForeignCurrencyExcludingTax,      
 TaxPerNightInForeignCurrency,      
 TotalInForeignCurrencyExcludingTax,      
 TotalTaxInForeignCurrency,      
 TotalAmountInForeignCurrencyIncludingManagementFee,      
 RoomRateNightINRExcludingTax,      
 TotalINRExcludingTax,      
 TotalTaxINR,      
 TotalAmountRoomRentTaxINR,      
 HotelGroup,      
 HotelBrand,      
 Zipcode,      
 HotelName,      
 HotelAddress,      
 Comments,      
 [Remarks] as [Remarks],      
 --CorporateOrNonCorporateRate,      
 [Corporate Or Non-CorporateRate ] as [Corporate Or Non-CorporateRate ],    
 --CorporateCode,      
 [CorporateCode] as [CorporateCode],    
 --ManagementFee,      
 [Management Fee] as [Management Fee],    
 Vendor,      
 [Status],      
 BookingID,      
 BookingConfirmation,    
 GDSPNR    
FROM           
    SourceData          
PIVOT (          
    MAX(AttributesValue)          
    FOR Attributes IN ([RequestNo],[GESSReceivedDate],[EmployeeNo],[SWONNo],    
 --[Travel officer],    
 [RoomType Attribute],    
 [Remarks],    
 [Corporate Or Non-CorporateRate ],    
 [CorporateCode],    
 [Management Fee])) AS PivotTable;     
           
END