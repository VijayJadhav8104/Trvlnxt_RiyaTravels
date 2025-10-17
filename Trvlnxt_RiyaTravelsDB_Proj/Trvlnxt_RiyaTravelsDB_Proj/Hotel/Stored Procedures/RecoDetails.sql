         -- [Hotel].[RecoDetails_1] @BookingId='TNHAPI00029159',@SearchBy='3'      
   --sp_helptext '[Hotel].[RecoDetails_1]'      
   --sp_helptext [Hotel].[RecoDetails]  @SearchBy='0',    @StartDate='03-Jun-2024',@EndDate='04-Jun-2024'                            
                              
CREATE PROC [Hotel].[RecoDetails]                                                                                                          
@StartDate varchAR(50)=null,                                                                                                        
@EndDate varchAR(50)=NULL                                                                                      
,@SearchBy varchar(40)='0'                   
,@BookingId nvarchar(Max)=null                  
AS                                                                                                          
BEGIN                                                                                                          
                                                                                                        
 if(@SearchBy!=3)                                                                                                       
 Begin     --- date filter end                                                                                                   
 IF OBJECT_ID ( 'tempdb..#tempTableHotelReco') IS NOT NULL                                                                                                            
  DROP table #tempTableHotelReco                                                                                                        
                                                                                                        
 SELECT                                                                                                       
    *                                                                                                      
 INTO #tempTableHotelReco FROM                                                                                                   
                                                                                             
(                                                                                          
select                                                                                                         
RowFlag as 'LogsFrom',                                                                              
case RowFlag when 'Dynamo' then 2 else 3 end as 'SEQ',                                                                            
FORMAT(Booking_Date, 'dd MMM yyyy hh:mm:ss tt') AS 'BookingDate',                                                                                
BookID as  'BookingId',                                                                                                        
Isnull(Upper(Supplier),UPPER(hb.SupplierName)) as 'Supplier',                                                                                                        
Isnull(Channel,' ') as 'Channel',                                                                                                        
ISnull(Status,' ') as 'status',                                                                                                        
Isnull(Agent_Currency,' ')  as 'AgenctCurrecny',                                                                                                          
Isnull(Supplier_Currency,' ') as 'SupplierCurrency',                                                                                                          
Isnull(ROE,0) AS 'Roe',                                                            
ISNULL(Round(SBaseRateSCurrency,3),0) as BaseRate_Supplier_Currency,                                
ISNULL(Round(Total_Amount,2,1),0) as 'TotalRate',                              
                            
ISNULL(Round(Commission,3),0) as 'Discount',                                                      
ISNULL(Round(Debit_to_Agent,3),0) as 'DebitToAgent' ,                                       
ISNULL(Round(Credit_to_Agent,3),0) as 'CreditToAgent',                                                                 
Isnull(Round(Revenue,3),0) as 'Revenue',                                 
cast(Payment_mode as varchar)  as 'PaymentMode',                
cast(Payment_mode as varchar) as 'PG_Mode',                                                                                                    
ISNULL(Round(Convience_Fees,3),0) as 'Convience Fees',                                                                                
case when isnull(ErrorDesc,'')='' then isnull(Cast(No_of_Night as varchar),'0') else 'NA' end as 'NoofNights',                                   
replace(''''+ isnull(No_of_Pax,'0')+'''','''/''','NA')        
as 'Pax_A_C',                                                                    
case when  isnull(ErrorDesc,'')='' then isnull(Cast(No_of_Room as varchar),'NA') else 'NA'  end as 'TotalRooms',                            
case when  isnull(ErrorDesc,'')='' then isnull(Room_Category,'NA') else 'NA'  end as Room_Category,                        
case when isdate(DeadlineDate)='1' then FORMAT(CONVERT(datetime,cast(DeadlineDate as datetime),113), 'dd MMM yyyy hh:mm tt') else DeadlineDate end as DeadlineDate,                        
GuestName as GuestName,                        
upper(Hotel_Name)  as 'HotelName',                            
upper(Booked_City) as HotelAddress,                            
upper(Booked_City)  as 'City',                                      
  Convert(Varchar,check_in_date,106)  as 'CheckIn',                                                        
                                                                      
  Replace(rc.Checkintime,'NA','00:00') as CheckinTime,                                                                       
                                                                      
  Convert(Varchar,Check_out_date,106) as 'CheckOut',                                                                                          
    Replace(rc.Checkouttime,'NA','00:00') as CheckOutTime,                                                                                      
Agency_Code as 'Agency_Code'  ,                                                                                                        
Agency_Name as 'Agency_Name',                                                    
Corelation_ID  as 'CorrelationId' ,                                                              
ErrorDesc as Error                             
,hb.pkId                    
, RC.Status AS BookingStatus                  
,'' as Remarks                  
                    
from  Hotel.HotelReconRpt  rc  WITH (NOLOCK)                    
right join Hotel_BookMaster hb WITH (NOLOCK) on hb.BookingReference= rc.BookID   and rc.IsActive=1                     
where                                                                    
(              
 ( (( cast(rc.Booking_Date as date) between @StartDate and isnull( @EndDate,GETDATE() )and @SearchBy='0' )              
  or (@StartDate is null and @EndDate is null  )) )              
  --or  (RowFlag='Supplier' and rc.Booking_Date is null)                                                         
                           
                               
  or                                                                                        
                                                                                          
 ( ((cast(rc.check_in_date as date) between @StartDate and  Isnull(@EndDate,GETDATE() ) and @SearchBy='1' )               
  or (@StartDate is null and @EndDate is null  ))  )              
  --or  (RowFlag='Supplier' and Booking_Date is null)                                                                  
                
                   
                    
                      
   or                                                                                       
                                                                                          
 ( ((cast(HB.ExpirationDate as date) between @StartDate and  Isnull(@EndDate,GETDATE() ) and @SearchBy='2' )              
  or (@StartDate is null and @EndDate is null  ))  )              
                   
 -- or  (RC.RowFlag='Supplier' and RC.Booking_Date is null)                
  )                                                           
UNION                                                                                                        
                                                                                                        
                                                                                        
select                                                                                                          
'TrvlNxt' as 'LogsFrom',                                                                                
1 as 'SEQ',                                                                            
                                                          
FORMAT(HB.inserteddate, 'dd MMM yyyy hh:mm:ss tt') AS 'BookingDate',                                                                                
BookingReference as 'BookingId',                                                     
Upper(SupplierName) as 'Supplier',                                              
HB.ChannelId as 'Channel',                                                                                                  
Case                                                                                                              
      when HB.B2BPaymentMode=1  THEN HB.CurrentStatus + ' / ' +  'Hold'                                                                                                                           
   when HB.B2BPaymentMode=2 then   HB.CurrentStatus  + ' / '+ 'Credit Limit'                                                                                                                                                                                  
   
   
       
        
         
            
              
                
                   
                      
   when  HB.B2BPaymentMode=3 then HB.CurrentStatus  + ' / '+ 'Make Payment'                                                                                                                          
   when  HB.B2BPaymentMode=4 then HB.CurrentStatus  + ' / '+ 'Self Balance'                                                                                                           
   when  HB.B2BPaymentMode=5 then HB.CurrentStatus  + ' / '+ 'Pay At Hotel'                                                                                                                                                                                    
  
    
      
        
          
            
              
                
                  
                        
   else  HB.CurrentStatus                                                                                                                                                                                                                                      
  
    
      
        
          
            
              
                
                  
                   
 End as 'status',                                                                
                                                                
 HB.CurrencyCode as 'AgenctCurrecny',                                                                                                          
 HB.SupplierCurrencyCode as 'SupplierCurrency',                                          
Isnull(ROUND(HB.ROEValue, 3),0) AS 'Roe',                                                              
 isnull(HB.SBaseRate,0) as BaseRate_Supplier_Currency,    
ISNULL(hB.HotelTotalGross,0) AS TotalRate,                                                                                
  Isnull(Round(HCC.EarningAmount,3),0) as 'Discount',                                                                   
                                                                                  
                                        
                                                                                                     
CASE   WHEN HB.B2BPaymentMode = 1 THEN 0                                                                    
        WHEN HB.B2BPaymentMode = 2 THEN ISNULL(CAST(TAB1.TranscationAmount AS DECIMAL(18, 3)), 0)                                                                                
        WHEN HB.B2BPaymentMode = 4 THEN ISNULL(CAST(TSB1.TranscationAmount AS DECIMAL(18, 3)), 0)                                                           
  ELSE 0                                                            
    END AS 'DebitToAgent',                                                     
                                                                                
    CASE                                                               
     WHEN HB.B2BPaymentMode = 1 THEN 0                                                            
        WHEN HB.B2BPaymentMode = 2 THEN ISNULL(CAST(TAB.TranscationAmount AS DECIMAL(18, 3)), 0)                                                                                
        WHEN HB.B2BPaymentMode = 4 THEN ISNULL(CAST(TSB.TranscationAmount AS DECIMAL(18, 3)), 0)                                                              
        ELSE 0                                                                                
    END AS 'CreditToAgent',                                                
                                                                 
 (                                       
    -- revenue formula: base rate + conveyance - debit to agent - discount                                                                
   ( ((Isnull(Hb.SBaseRate,0)) * (ISNULL(HB.ROEValue,0)) )  + isnull(MPC.TotalCommission,0)) - (( CASE                                                                
        WHEN HB.B2BPaymentMode = 2 THEN ISNULL(CAST(TAB1.TranscationAmount AS DECIMAL(18, 3)), 0)                                                                
        WHEN HB.B2BPaymentMode = 4 THEN ISNULL(CAST(TSB1.TranscationAmount AS DECIMAL(18, 3)), 0)                                                                
        ELSE ISNULL(CAST(HB.DisplayDiscountRate AS DECIMAL(18, 3)), 0)                                              
    END )- isnull(HCC.EarningAmount,0))                                                                
) AS 'Revenue'                                                                
                                            
                                                                
                                
 , Case                                                                                                              
      when B2BPaymentMode=1 then'Hold'                                                                                                       
   when B2BPaymentMode=2 then 'Credit Limit'                                                                                                                                                                                                                  
   
   
      
         
         
            
              
   when  B2BPaymentMode=3 then 'Make Payment'                                                                                                                                                    
   when  B2BPaymentMode=4 then 'Self Balance'                                                                                                           
   when  B2BPaymentMode=5 then 'Pay At Hotel'     
   else   ''                                                                                                          
   end as 'PaymentMode'                                                                                                          
   ,isnull(MPC.ModeOfPayment,null) as 'PG_Mode'                                                                   
                          
     
   , CASE                        
        WHEN Mpc.ModeOfPayment = 'UPI' THEN CONVERT(NVARCHAR(MAX), ISNULL(ROUND(MPC.TotalCommission, 3), 0))                        
        WHEN Mpc.ModeOfPayment != 'UPI' AND ISNULL(ROUND(MPC.TotalCommission, 3), 0) <= 0 THEN '<span style="color: red;">' + CONVERT(NVARCHAR(MAX), ISNULL(ROUND(MPC.TotalCommission, 3), 0)) + '</span>'                        
    END AS 'Convience Fees'                        
                        
                        
   ,isnull(HB.SelectedNights,'0') as 'NoofNights'                                                         
   ,''''+((isnull(HB.TotalAdults,'0')) +'/'+ (isnull(HB.TotalChildren,'0')))+'''' as 'Pax_A_C'                                                                                                          
   ,isnull(HB.TotalRooms,'0') as 'TotalRooms'                   
                               
  , ISNULL(                            
        STUFF((                            
            SELECT ' | ' + RM.RoomTypeDescription                            
            FROM Hotel_Room_master RM                            
            WHERE RM.book_fk_id = HB.pkId                            
            FOR XML PATH('')                            
        ), 1, 2, ''), 'NA') AS Room_Category                    
                            
 ,FORMAT(HB.ExpirationDate, 'dd MMM yyyy hh:mm tt') as DeadlineDate                          
                         
 , ISNULL(                            
        STUFF((                            
            SELECT     ' | ' + PM.Salutation +' '+ PM.FirstName + ' ' + PM.LastName                            
            FROM Hotel_Pax_master PM WITH (NOLOCK)                            
            WHERE PM.book_fk_id = HB.pkId                            
            FOR XML PATH('')                            
        ), 1, 2, ''), 'NA') AS GuestName                        
                        
   ,upper(HB.HotelName) as 'HotelName'                                                                       
   ,upper(HB.cityName) as 'City'                             
   ,HB.HotelAddress1 as HotelAddress                            
   --BEGIN Modified by bhushan, Faizan                                                                                          
  ,Convert(Varchar,HB.CheckInDate,106) as 'CheckIn',                                                                                          
                                                                      
  Replace(HB.CheckinTime,'NA','00:00') as CheckinTime,                                                                              
    Convert(Varchar,HB.CheckOutDate,106) as 'CheckOut',                                                                                          
                                                                      
    Replace(HB.CheckOutTime,'NA','00:00') as CheckOutTime                                                                              
 --END                                                                  
   ,BR.Icast as 'Agency_Code'                                                                                                          
   ,BR.AgencyName as 'Agency_Name'                                    
   ,cast(HB.searchApiId as nvarchar(max)) as 'CorrelationId'                                                               
   ,'' as Error                                                                
   ,HB.pkId                        
   , case when Lower(HB.CurrentStatus)='vouchered' then 'Confirmed'  else HB.CurrentStatus end  AS BookingStatus                  
                 
   ,ISNULL(                            
        STUFF((                            
            SELECT     ' | '  + HH.FieldName                             
            FROM  Hotel_UpdatedHistory HH WITH (NOLOCK)                
           WHERE HH.fkbookid= HB.pkId and HH.FieldName in ('Pax Modified','ServiceTime_Modified','ModifiedBooking','ModifiedRoE','Canx reconcilled','Reject')                        
            FOR XML PATH('')                            
        ), 1, 2, ''), 'NA')    as Remarks                  
                                                                                                
 from Hotel_BookMaster HB WITH (NOLOCK)                                                                                                      
 left join Hotel_Status_History SH WITH (NOLOCK) on HB.pkId=SH.FKHotelBookingId                                                                          
 left join Hotel_Status_Master SM WITH (NOLOCK) on SH.FkStatusId=SM.Id                                                      
 left join B2BHotel_Commission HCC WITH (NOLOCK) on HB.pkId=HCC.Fk_BookId                                                                                                           
 left join tblAgentBalance TAB WITH (NOLOCK) on TAB.BookingRef = HB.orderId and Tab.TransactionType='Credit'                                                                                                          
 left join tblAgentBalance TAB1 WITH (NOLOCK) on TAB1.BookingRef = HB.orderId and Tab1.TransactionType='Debit'                                                                                                          
 left join tblSelfBalance TSB WITH (NOLOCK) on TSB.BookingRef = HB.orderId and Tab.TransactionType='Credit'                                                                                
 left join tblSelfBalance TSB1 WITH (NOLOCK) on TSB1.BookingRef = HB.orderId and TSB1.TransactionType='Debit'                                      
                                                                                                          
 left join B2BMakepaymentCommission MPC WITH (NOLOCK) on  MPC.OrderId= HB.orderId and MPC.ProductType='Hotel'                                                                     
 left join B2BRegistration BR WITH (NOLOCK) on BR.FKUserID=HB.RiyaAgentID                            
 left join Hotel_Room_master  RM WITH (NOLOCK) on HB.pkId=RM.book_fk_id                         
 left join  Hotel_Pax_master PM WITH (NOLOCK) on HB.pkId =PM.book_fk_id                        
 where                              
                                 
                           
   isnull(HB.BookingReference,' ')!=' '                                                           
   and                                                                            
 ((( cast(HB.inserteddate as date) between @StartDate and  @EndDate and @SearchBy='0' )or (@StartDate is null and @EndDate is null))                                                                        
 or                                                                                               
  (( cast(HB.CheckInDate as date) between @StartDate and  @EndDate and @SearchBy='1' )or (@StartDate is null and @EndDate is null  ))                                                                                         
                    
  or                                                                                               
  (( cast(HB.ExpirationDate as date) between @StartDate and  @EndDate and @SearchBy='2' )or (@StartDate is null and @EndDate is null  ))                     
  )                                                                                        
                      
                    
 and SH.IsActive=1                                    
 and EXISTS (SELECT 1 FROM Hotel_Room_master RM WITH (NOLOCK) WHERE RM.book_fk_id = HB.pkId)                            
                     
                                                           
 )  Reco                                      
      order by BookingId  desc                                                         
                      
                    
  begin                    
   select                                                                                              
DENSE_RANK() over ( order by pkId desc  ) AS 'SrNo'                                                                       
, 'CorrelationId' = '''' + CAST(CorrelationId AS NVARCHAR(MAX)) + '''' ,                                        
CAST(TotalRate AS decimal(18,2)) AS TotalRate , *  from #tempTableHotelReco                                                                              
where cast(BookingDate as date)>=Cast('2023-12-20' as date) or cast(CheckIn as date)>=Cast('2023-12-20' as date)                    
  order by pkId desc,cast(BookingDate as datetime) asc, BookingId,SEQ  asc                                                     
  END                                                                                                
                     
 End --- date filter end                    
                     
 else if (@SearchBy=3) -- start booking id filter                    
                     
 Begin                    
 IF OBJECT_ID ( 'tempdb..#tempTableHotelReco_1') IS NOT NULL                                                                                                            
  DROP table #tempTableHotelReco                                                                                                        
                        
                     
 SELECT                                                                                                       
    *                                                                          
 INTO #tempTableHotelReco_1 FROM                                                                                                   
                                                                                             
(                                                                                          
select                                                                                                         
RowFlag as 'LogsFrom',                                                 
case RowFlag when 'Dynamo' then 2 else 3 end as 'SEQ',                                                                            
FORMAT(Booking_Date, 'dd MMM yyyy hh:mm:ss tt') AS 'BookingDate',                                                                                
BookID as  'BookingId',                                                                                                        
Isnull(Upper(Supplier),UPPER(hb.SupplierName)) as 'Supplier',                                                                                                        
Isnull(Channel,' ') as 'Channel',                                                                                                        
ISnull(Status,' ') as 'status',                                                                                                        
Isnull(Agent_Currency,' ')  as 'AgenctCurrecny',                                                                                                          
Isnull(Supplier_Currency,' ') as 'SupplierCurrency',                                                                                                          
Isnull(ROE,0) AS 'Roe',                                                            
ISNULL(Round(SBaseRateSCurrency,3),0) as BaseRate_Supplier_Currency,                                
ISNULL(Round(Total_Amount,2,1),0) as 'TotalRate',                              
                            
ISNULL(Round(Commission,3),0) as 'Discount',                                        
ISNULL(Round(Debit_to_Agent,3),0) as 'DebitToAgent' ,                            
ISNULL(Round(Credit_to_Agent,3),0) as 'CreditToAgent',                                                                 
Isnull(Round(Revenue,3),0) as 'Revenue',                                                                                
cast(Payment_mode as varchar)  as 'PaymentMode',                                                                                                        
cast(Payment_mode as varchar) as 'PG_Mode',                                                                                                          
ISNULL(Round(Convience_Fees,3),0) as 'Convience Fees',                                             
case when isnull(ErrorDesc,'')='' then isnull(Cast(No_of_Night as varchar),'0') else 'NA' end as 'NoofNights',                                   
replace(''''+ isnull(No_of_Pax,'0')+'''','''/''','NA')        
as 'Pax_A_C',                                                                    
case when  isnull(ErrorDesc,'')='' then isnull(Cast(No_of_Room as varchar),'NA') else 'NA'  end as 'TotalRooms',                            
case when  isnull(ErrorDesc,'')='' then isnull(Room_Category,'NA') else 'NA'  end as Room_Category,                        
case when isdate(DeadlineDate)='1' then FORMAT(CONVERT(datetime,cast(DeadlineDate as datetime),113), 'dd MMM yyyy hh:mm tt') else DeadlineDate end as DeadlineDate,                        
  
GuestName as GuestName,                        
upper(Hotel_Name)  as 'HotelName',                
upper(Booked_City) as HotelAddress,                            
upper(Booked_City)  as 'City',                                      
  Convert(Varchar,check_in_date,106)  as 'CheckIn',                                                        
                                                                      
  Replace(rc.Checkintime,'NA','00:00') as CheckinTime,                                       
                                                                      
  Convert(Varchar,Check_out_date,106) as 'CheckOut',                                                                                          
    Replace(rc.Checkouttime,'NA','00:00') as CheckOutTime,                                                                                      
Agency_Code as 'Agency_Code'  ,                                                                                                        
Agency_Name as 'Agency_Name',                                                    
Corelation_ID  as 'CorrelationId' ,                                                              
ErrorDesc as Error                             
   ,hb.pkId                  
   , RC.Status AS BookingStatus                  
,'' as Remarks                  
                  
                     
from  Hotel.HotelReconRpt  rc                      
left join Hotel_BookMaster hb on rc.BookID = hb.BookingReference                      
where                                                                    
IsActive=1                         
 and( (@BookingId ='') or (RC.BookID IN  (select Data from sample_split(@BookingId,','))) )                                                           
                                                                      
UNION                                                                                                        
                                                                                                        
                                                                                                        
select                                                                                                          
'TrvlNxt' as 'LogsFrom',                                                                                
1 as 'SEQ',                                                                
                                                                            
FORMAT(HB.inserteddate, 'dd MMM yyyy hh:mm:ss tt') AS 'BookingDate',                                                                   
BookingReference as 'BookingId',                                                                                      
Upper(SupplierName) as 'Supplier',                    
HB.ChannelId as 'Channel',                                                                                                  
Case                                                                                                              
      when HB.B2BPaymentMode=1  THEN HB.CurrentStatus + ' / ' +  'Hold'                                                    
   when HB.B2BPaymentMode=2 then   HB.CurrentStatus  + ' / '+ 'Credit Limit'                                                                                                                                                                                  
  
    
      
        
          
            
              
                
                  
                       
   when  HB.B2BPaymentMode=3 then HB.CurrentStatus  + ' / '+ 'Make Payment'                                                                                                                          
   when  HB.B2BPaymentMode=4 then HB.CurrentStatus  + ' / '+ 'Self Balance'                                                                                                           
   when  HB.B2BPaymentMode=5 then HB.CurrentStatus  + ' / '+ 'Pay At Hotel'                       
                        
   else  HB.CurrentStatus                                       
        
          
            
              
               
                   
                   
 End as 'status',                                                                
                                                                
 HB.CurrencyCode as 'AgenctCurrecny',                                                                                                          
 HB.SupplierCurrencyCode as 'SupplierCurrency',                                          
Isnull(ROUND(HB.ROEValue, 3),0) AS 'Roe',                                                              
 isnull(HB.SBaseRate,0) as BaseRate_Supplier_Currency,                                                               
ISNULL(hB.HotelTotalGross,0) AS TotalRate,                                                                                
  Isnull(Round(HCC.EarningAmount,3),0) as 'Discount',                                                       
                                                                                  
                                                                        
                                                                                                     
CASE   WHEN HB.B2BPaymentMode = 1 THEN 0                                                                    
        WHEN HB.B2BPaymentMode = 2 THEN ISNULL(CAST(TAB1.TranscationAmount AS DECIMAL(18, 3)), 0)                                                                                
        WHEN HB.B2BPaymentMode = 4 THEN ISNULL(CAST(TSB1.TranscationAmount AS DECIMAL(18, 3)), 0)                                                           
  ELSE 0                                                            
    END AS 'DebitToAgent',                                                                                
                                                                                
    CASE                                                               
     WHEN HB.B2BPaymentMode = 1 THEN 0                                                            
        WHEN HB.B2BPaymentMode = 2 THEN ISNULL(CAST(TAB.TranscationAmount AS DECIMAL(18, 3)), 0)                                                                                
        WHEN HB.B2BPaymentMode = 4 THEN ISNULL(CAST(TSB.TranscationAmount AS DECIMAL(18, 3)), 0)                                                                               
        ELSE 0                    
    END AS 'CreditToAgent',                                                                                                                                                 
                                                                 
 (                                                                
    -- revenue formula: base rate + conveyance - debit to agent - discount                                                                
   ( ((Isnull(Hb.SBaseRate,0)) * (ISNULL(HB.ROEValue,0)) )  + isnull(MPC.TotalCommission,0)) - (( CASE                                                    
        WHEN HB.B2BPaymentMode = 2 THEN ISNULL(CAST(TAB1.TranscationAmount AS DECIMAL(18, 3)), 0)                                                                
        WHEN HB.B2BPaymentMode = 4 THEN ISNULL(CAST(TSB1.TranscationAmount AS DECIMAL(18, 3)), 0)                                                                
        ELSE ISNULL(CAST(HB.DisplayDiscountRate AS DECIMAL(18, 3)), 0)                                          
    END )- isnull(HCC.EarningAmount,0))                                                                
) AS 'Revenue'                                                                
                                            
                                                                
                                
 , Case                                                                                                              
      when B2BPaymentMode=1 then'Hold'                                                                                                       
   when B2BPaymentMode=2 then 'Credit Limit'                                                                                                                                                                                                                  
  
    
      
         
         
            
              
   when  B2BPaymentMode=3 then 'Make Payment'                                                                                                                                                    
   when  B2BPaymentMode=4 then 'Self Balance'                                                                                                           
   when  B2BPaymentMode=5 then 'Pay At Hotel'                                                                     
   else   ''                                                                                                          
   end as 'PaymentMode'                                                                                                          
   ,isnull(MPC.ModeOfPayment,null) as 'PG_Mode'                                                                   
                          
                         
   , CASE                        
        WHEN Mpc.ModeOfPayment = 'UPI' THEN CONVERT(NVARCHAR(MAX), ISNULL(ROUND(MPC.TotalCommission, 3), 0))                        
        WHEN Mpc.ModeOfPayment != 'UPI' AND ISNULL(ROUND(MPC.TotalCommission, 3), 0) <= 0 THEN '<span style="color: red;">' + CONVERT(NVARCHAR(MAX), ISNULL(ROUND(MPC.TotalCommission, 3), 0)) + '</span>'                        
    END AS 'Convience Fees'                        
                        
                        
   ,isnull(HB.SelectedNights,'0') as 'NoofNights'                                                         
   ,''''+((isnull(HB.TotalAdults,'0')) +'/'+ (isnull(HB.TotalChildren,'0')))+'''' as 'Pax_A_C'                                                                                                          
   ,isnull(HB.TotalRooms,'0') as 'TotalRooms'                             
                               
  , ISNULL(                            
        STUFF((                            
            SELECT ' | ' + RM.RoomTypeDescription                            
            FROM Hotel_Room_master RM                            
            WHERE RM.book_fk_id = HB.pkId   
            FOR XML PATH('')                            
        ), 1, 2, ''), 'NA') AS Room_Category                            
                            
 ,FORMAT(HB.ExpirationDate, 'dd MMM yyyy hh:mm tt') as DeadlineDate                          
                         
 , ISNULL(                            
        STUFF((                            
            SELECT     ' | ' + PM.Salutation +' '+ PM.FirstName + ' ' + PM.LastName                            
            FROM Hotel_Pax_master PM                            
            WHERE PM.book_fk_id = HB.pkId                            
            FOR XML PATH('')                            
        ), 1, 2, ''), 'NA') AS GuestName                        
                        
   ,upper(HB.HotelName) as 'HotelName'                                                                                                          
   ,upper(HB.cityName) as 'City'                             
   ,HB.HotelAddress1 as HotelAddress                            
   --BEGIN Modified by bhushan, Faizan                            
  ,Convert(Varchar,HB.CheckInDate,106) as 'CheckIn',                                                            
                                                                      
  Replace(HB.CheckinTime,'NA','00:00') as CheckinTime,                                                                              
    Convert(Varchar,HB.CheckOutDate,106) as 'CheckOut',                                                                                          
                                                                      
    Replace(HB.CheckOutTime,'NA','00:00') as CheckOutTime                                                                   
 --END             
   ,BR.Icast as 'Agency_Code'                                                                                                          
   ,BR.AgencyName as 'Agency_Name'                                    
   ,cast(HB.searchApiId as nvarchar(max)) as 'CorrelationId'                                                               
   ,'' as Error                                                                
   ,HB.pkId                    
    , case when Lower(HB.CurrentStatus)='vouchered' then 'Confirmed'  else HB.CurrentStatus end  AS BookingStatus                  
   ,ISNULL(                            
        STUFF((                            
            SELECT     ' | '  + HH.FieldName                             
            FROM  Hotel_UpdatedHistory HH                 
   --left join Hotel_BookMaster HB on HH.fkbookid=HB.pkId                
            WHERE HH.fkbookid= HB.pkId and HH.FieldName in ('Pax Modified','ServiceTime_Modified','ModifiedBooking','ModifiedRoE','Canx reconcilled','Reject')                           
            FOR XML PATH('')                            
        ), 1, 2, ''), 'NA')    as Remarks                   
                                                                                                
 from Hotel_BookMaster HB WITH (NOLOCK)                                                                                                      
 left join Hotel_Status_History SH WITH (NOLOCK) on HB.pkId=SH.FKHotelBookingId                                             
 left join Hotel_Status_Master SM WITH (NOLOCK) on SH.FkStatusId=SM.Id                                                                 
 left join B2BHotel_Commission HCC WITH (NOLOCK) on HB.pkId=HCC.Fk_BookId                                                                                                           
 left join tblAgentBalance TAB WITH (NOLOCK) on TAB.BookingRef = HB.orderId and Tab.TransactionType='Credit'                                                                    
 left join tblAgentBalance TAB1 WITH (NOLOCK) on TAB1.BookingRef = HB.orderId and Tab1.TransactionType='Debit'                                                                                                          
 left join tblSelfBalance TSB WITH (NOLOCK) on TSB.BookingRef = HB.orderId and Tab.TransactionType='Credit'                                                                                
 left join tblSelfBalance TSB1 WITH (NOLOCK) on TSB1.BookingRef = HB.orderId and TSB1.TransactionType='Debit'                                                                                                          
                                                                                                          
 left join B2BMakepaymentCommission MPC WITH (NOLOCK) on  MPC.OrderId= HB.orderId and MPC.ProductType='Hotel'                                                                     
 left join B2BRegistration BR WITH (NOLOCK) on BR.FKUserID=HB.RiyaAgentID                            
 left join Hotel_Room_master  RM WITH (NOLOCK) on HB.pkId=RM.book_fk_id                         
 left join  Hotel_Pax_master PM WITH (NOLOCK) on HB.pkId =PM.book_fk_id                        
 where                              
                                 
                    
   isnull(HB.BookingReference,' ')!=' '                     
  and( (@BookingId ='') or (HB.BookingReference IN  (select Data from sample_split(@BookingId,','))) )                   
 and SH.IsActive=1                                    
 and EXISTS (SELECT 1 FROM Hotel_Room_master RM WHERE RM.book_fk_id = HB.pkId)                            
                                                               
                                                           
 )  Reco                                                                                                      
      order by BookingId  desc                                                         
                      
                    
 begin                    
   select                                                                                  
DENSE_RANK() over ( order by pkId desc  ) AS 'SrNo'                                         
, 'CorrelationId' = '''' + CAST(CorrelationId AS NVARCHAR(MAX)) + '''' ,                                        
CAST(TotalRate AS decimal(18,2)) AS TotalRate , *  from #tempTableHotelReco_1                     
where cast(BookingDate as date)>=Cast('2023-12-20' as date) or cast(CheckIn as date)>=Cast('2023-12-20' as date)                    
  order by pkId desc, cast(BookingDate as datetime) asc, BookingId,SEQ  asc                                          
                     
 END                                                                                                
                     
                                                 
                    
 End -- end boooking Id filter                    
                      
END 