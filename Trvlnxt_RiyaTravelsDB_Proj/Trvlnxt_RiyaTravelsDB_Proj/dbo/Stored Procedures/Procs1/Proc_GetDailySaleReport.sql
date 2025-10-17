 -- [dbo].[Proc_GetDailySaleReport] 0,830,'2023-02-01','2023-10-02'  
CREATE PROCEDURE [dbo].[Proc_GetDailySaleReport]  
@AgentId int = 0 ,                            
@MainAgentId int = 0,                        
@FromDate varchar(100)='',                        
@ToDate varchar(100)=''        
AS   
BEGIN   
 IF @ToDate IN ('',NULL)   
  SET @ToDate = DATEADD(DAY,1,@FromDate)                                                                                
 ELSE                   
  SET @ToDate = DATEADD(DAY,1,@ToDate)     
  
  
 Select     
 row_number() over(order by HB.pkid) AS SrNo,  
 HB.RiyaAgentID AS RiyaUserId, -- b2bregistration tbl api_userid in bm  
 HH.CreateDate AS BookingDate,  
 HM.Status AS Status,  
 HB.providerConfirmationNumber AS TRNumber,   --- provider confirmation num in bm  
 0 AS EntityCode,  --   
 '' AS EmployeeId,  
 '' AS EmployeeName,  
 '' AS TravelPlan,  
 '' AS EmployeeBand,  
 HB.CountryName AS Country,  
 HB.BookingCountry AS CountryCode,  
 HB.cityName AS City,  
 HB.CheckInDate AS CheckInDate,  
 HB.CheckOutDate AS CheckOutDate,  
 HB.SelectedNights AS RoomNight,   -- no of night from bm  
 HB.HotelName AS BookedHotel,  
 HB.ChainName AS HotelBrand,  -- chain name bm  
 ISNULL(HB.HotelAddress1,HB.HotelAddress2) AS HotelAddress,  
 '' AS PostalCode,  
 HB.RatePerNight AS RatePerNightExcludesOfTax,  -- Hotel_RoomRatesPerNight (MULTIPLE RECORDS IN TBL)  
 HB.HotelIncludes AS Inclusion,  
 HB.ConfirmationNumber AS ConfirmationNumber,  
 '' AS RateType, --   
 HB.CurrencyCode AS HotelCur,  
 0 AS RatePerNightIncludesOfTax,  
 tbs.TranscationAmount AS TranscationAmount,  
 HB.ROEValue AS ROE,  
 CASE WHEN HB.AgentCommission > 0 THEN 'Yes' ELSE 'No' END AS Commission,  
 CASE WHEN HB.AgentCommission > 0 THEN (HB.AgentCommission/HB.SelectedNights) ELSE 0 END AS CommissionAmountPerNight,  
 HB.AgentCommission AS AgentCommission  
 from Hotel_BookMaster HB  WITH (NOLOCK)                                                                                          
  join Hotel_Status_History HH on HB.pkId = HH.FKHotelBookingId and HH.FkStatusId = 4                                                                        
  join Hotel_Status_Master HM on HH.FkStatusId = HM.Id                                                                                                                      
  left join B2BHotel_Commission BC on BC.Fk_BookId = hb.pkId                                                             
  left join tblSelfBalance tbs on tbs.BookingRef = HB.orderId and tbs.UserID = HB.MainAgentID                       
  left join tblAgentBalance tbla on tbla.BookingRef = HB.orderId  and  tbla.AgentNo = HB.RiyaAgentID                       
 where (HB.RiyaAgentID = @AgentId or (HB.MainAgentID = @MainAgentId and HB.MainAgentID > 0))                            
  and HB.BookingPortal in('TNH','TNHAPI')                           
  and HB.RiyaAgentID is not null                                                                                                                               
    --and HH.IsActive=1                         
  and ((Convert(date,HH.CreateDate) >= Convert(date,@FromDate) and Convert(date,HH.CreateDate) < @ToDate) or @FromDate='')        
  and (tbs.TransactionType='Debit' or tbla.TransactionType='Debit')           
  or (tbs.BookingRef='Credit' or tbla.BookingRef='Credit')     
END  
   
  
   
  
  
 