---Proc_GetHotelBookingRecoData 46999,1261,'2025-03-21','2025-03-21',null,null,null          
CREATE procedure Proc_GetHotelBookingRecoData          
@AgentId int=0,          
@MainAgentId int=0,          
@FromDate varchar(100)=null,          
@ToDate varchar(100)=null,          
@CheckinFromDate varchar(100)=null,          
@CheckInToDate varchar(100)=null,          
@BookingId varchar(100)=null          
As          
Begin          
  Select         
 'TrvlNxtLog' as LogsPortal,         
 HM.inserteddate as BookingDate,
 isnull(HM.BookingReference,'') as BookingId,
 isnull(HSM.Status,'') as Status,
 isnull(HM.CheckInDate,'') as CheckInDate,        
 isnull(HM.CheckOutDate,'') as CheckOutDate, 
 isnull(HM.CancellationDeadLine,'') as DeadlineDate, 
 isnull(HM.TotalRooms,'') as TotalRooms,
 isnull(HM.LeaderFirstName+' '+HM.LeaderLastName ,'') as LeadPaxName,
 isnull(HM.HotelName,'') as HotelName,
 isnull(HM.HotelAddress1,'') as HotelAddress, 
 isnull(HM.cityName,'') as City,
 isnull(HM.BookingCountry,'') as Country, 
 isnull(HM.DisplayDiscountRate,'') as TotalPrice,
 isnull(HM.HotelConfNumber,'') as HCNnumber,
 isnull(HM.ConfirmationDate,null) as ConfirmationDate, 
 isnull(HM.SupplierName,'') as SupplierName,                          
 isnull(HM.CurrencyCode,'') as Currency                          
  
 from        
 Hotel_BookMaster HM  WITH (NOLOCK)        
 Left Join        
 Hotel_Status_History HSH  WITH (NOLOCK)        
 ON HM.pkId=HSH.FKHotelBookingId and IsActive=1        
 Left Join        
 Hotel_Status_Master HSM  WITH (NOLOCK)        
 ON HSM.Id=HSH.FkStatusId        
 Where         
 (HM.RiyaAgentID = @AgentId or (HM.MainAgentID = @MainAgentId AND HM.MainAgentID > 0))        
 and HM.RiyaAgentID is not null        
  AND HM.BookingPortal in('TNH','TNHAPI')      
  AND (      
        -- If BookingReference is provided, filter by it      
        (@BookingId IS NOT NULL AND HM.BookingReference = @BookingId)      
        -- If BookingReference is NULL, filter by date range      
        OR (@BookingId IS NULL AND @FromDate IS NOT NULL AND @ToDate IS NOT NULL       
            AND HM.inserteddate >= @FromDate       
            AND HM.inserteddate < DATEADD(DAY, 1, @ToDate))      
      
   OR (@BookingId IS NULL AND @CheckinFromDate IS NOT NULL AND @CheckInToDate IS NOT NULL       
            --AND HM.CheckInDate>=@CheckInDate       
            --AND HM.CheckOutDate = DATEADD(DAY, 1, @CheckOutDate))      
   AND HM.CheckInDate between @CheckinFromDate and @CheckInToDate)     
    )         
           
          
 UNION ALL          
          
 Select           
 'SupplierLogs' as LogsPortal, 
 HM.inserteddate as BookingDate,
 isnull(HM.providerConfirmationNumber,'') as BookingId,       
 isnull(HRR.Status,'') as Status,  
 isnull(HRR.Check_in_date,'') as CheckInDate,          
 isnull(HRR.Check_out_date,'') as CheckOutDate,
 isnull(HM.CancellationDeadLine,'') as DeadlineDate, 
  '' as TotalRooms,
 isnull(HRR.GuestName,'') as LeadPaxName, 
 isnull(HRR.Hotel_Name,'') as HotelName,
 '' as HotelAddress,
 isnull(HRR.Booked_City,'') as City,
 '' as Country,
 isnull(HM.DisplayDiscountRate,'') as TotalPrice,
 '' as HCNnumber,
 null as ConfirmationDate,
 isnull(HRR.Supplier,'') as SupplierName, 
 isnull(HRR.Supplier_Currency,'') as Currency          
 from          
 Hotel_BookMaster HM  WITH (NOLOCK)          
 Left Join          
 Hotel_Status_History HSH  WITH (NOLOCK)          
 ON HM.pkId=HSH.FKHotelBookingId and IsActive=1       
 Left Join          
 Hotel_Status_Master HSM  WITH (NOLOCK)          
 ON HSM.Id=HSH.FkStatusId          
 Left join          
 hotel.HotelReconRpt HRR  WITH (NOLOCK)          
 ON HM.BookingReference=HRR.BookID and HRR.RowFlag='Supplier'       
 Where           
(HM.RiyaAgentID = @AgentId or (HM.MainAgentID = @MainAgentId AND HM.MainAgentID > 0))        
 and HM.RiyaAgentID is not null        
  AND HM.BookingPortal in('TNH','TNHAPI')      
  AND (      
        -- If BookingReference is provided, filter by it      
        (@BookingId IS NOT NULL AND HM.BookingReference = @BookingId)      
        -- If BookingReference is NULL, filter by date range      
        OR (@BookingId IS NULL AND @FromDate IS NOT NULL AND @ToDate IS NOT NULL       
            AND HM.inserteddate >= @FromDate       
            AND HM.inserteddate < DATEADD(DAY, 1, @ToDate))      
      
   --OR (@BookingId IS NULL AND @CheckInDate IS NOT NULL AND @CheckOutDate IS NOT NULL       
   --         AND HM.CheckInDate>=@CheckInDate       
   --         AND HM.CheckOutDate = DATEADD(DAY, 1, @CheckOutDate))      
   OR (@BookingId IS NULL AND @CheckinFromDate IS NOT NULL AND @CheckInToDate IS NOT NULL       
            --AND HM.CheckInDate>=@CheckInDate       
            --AND HM.CheckOutDate = DATEADD(DAY, 1, @CheckOutDate))      
   AND HM.CheckInDate between @CheckinFromDate and @CheckInToDate)     
    )            
 order by       
  HM.inserteddate desc ,LogsPortal desc         
End