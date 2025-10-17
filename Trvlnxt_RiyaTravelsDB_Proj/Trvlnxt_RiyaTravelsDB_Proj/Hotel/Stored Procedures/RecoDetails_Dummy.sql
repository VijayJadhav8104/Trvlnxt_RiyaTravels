                    
     --- exec [hotel].RecoDetails @StartDate='2023-12-20', @EndDate='2023-12-21', @SearchBy='1'             
                    
CREATE PROC [Hotel].[RecoDetails_Dummy]                    
@StartDate varchAR(50)=NULL,                    
@EndDate varchAR(50)=NULL  
,@SearchBy varchar(40)='0'   
AS                    
BEGIN                    
                  
                  
                  
 IF OBJECT_ID ( 'tempdb..#tempTableHotelReco') IS NOT NULL                      
  DROP table #tempTableHotelReco                  
                  
 SELECT                 
    *                
 INTO #tempTableHotelReco FROM             
       
(    
select                   
RowFlag as 'LogsFrom',                   
--FORMAT(CAST(Booking_Date AS datetime) , 'dd-MMM-yyyy HH:mm:ss') as 'BookingDate',        
FORMAT(CONVERT(datetime, Booking_Date, 106), 'MM/dd/yyyy h:mm:ss tt') as 'BookingDate',       
BookID as  'BookingId',                  
Supplier as 'Supplier',                  
Channel as 'Channel',                  
Status as 'status',                  
Agent_Currency  as 'AgenctCurrecny',                    
Supplier_Currency as 'SupplierCurrency',                    
isnull(ROE,0) as 'Roe',                   
isnull(Total_Amount,0) as 'TotalRate',                  
isnull(Commission,0) as 'Discount',                  
isnull(Debit_to_Agent,0) as   'DebitToAgent' ,                  
isnull(Credit_to_Agent,0) as'CreditToAgent',                  
isnull(Revenue,0) as 'Revenue',                  
cast(Payment_mode as varchar)  as 'PaymentMode',                  
cast(Payment_mode as varchar) as 'PG_Mode',                    
isnull(Convience_Fees,0) as 'Convience Fees',                    
isnull(No_of_Night,0) as 'NoofNights',                    
isnull(No_of_Pax,0) as 'Pax_A_C',                    
isnull(No_of_Room,0) as 'TotalRooms',                    
Hotel_Name as 'HotelName',                    
Booked_City as 'City'  ,          
--Convert(Varchar(11),Check_in_date,103) + CONVERT(varchar(11),ISNULL(Checkintime,'NA'),103) AS 'CheckIn',        
----Convert (varchar,check_in_date,106) as 'CheckIn',       
--Convert(Varchar(11),Check_out_date,106) + ISNULL(Checkouttime,'NA') AS 'CheckOut',      
----Convert(varchar,Check_out_date,106 ) as 'CheckOut',        
  Convert(Varchar,check_in_date,106)+' '+Convert(Varchar,case isdate(Checkintime) when 1 then Replace(Checkintime,'NA','00:00')else '' end,108)  as 'CheckIn',    
  Convert(Varchar,Check_out_date,106)+' '+Convert(Varchar, case ISDATE(Checkouttime)when 1 then Replace(Checkouttime,'NA','00:00') else '' end,108) as 'CheckOut',    
    
Agency_Code as 'Agency_Code'  ,                  
Agency_Name as 'Agency_Name',                    
Corelation_ID as 'CorrelationId'                    
from  Hotel.HotelReconRpt                 
where               
--(( cast(Hotel.HotelReconRpt.Booking_Date as date) between @StartDate and  @EndDate)or (@StartDate is null and @EndDate is null  ))  
  ((( cast(Hotel.HotelReconRpt.Booking_Date as date) between @StartDate and  @EndDate and @SearchBy='0' )or (@StartDate is null and @EndDate is null  )) or  
    
  (( cast(check_in_date as date) between @StartDate and  @EndDate and @SearchBy='1' )or (@StartDate is null and @EndDate is null  )))   
         and IsActive=1        
UNION                  
                  
                  
select                    
'TrvlNxt' as 'LogsFrom'                    
--,FORMAT(CAST(HB.inserteddate AS datetime) , 'dd-MMM-yyyy HH:mm:ss') as 'BookingDate',        
,FORMAT(CONVERT(datetime, HB.inserteddate, 106), 'MM/dd/yyyy h:mm:ss tt') as 'BookingDate',       
      
BookingReference as 'BookingId',                    
SupplierName as 'Supplier',                    
Case                     
 when BookingReference LIKE '%API%' then 'API-OUT'                    
 else 'TrvlNxt'                    
end                    
 as 'Channel',                    
 SM.Status as 'status',                    
 HB.CurrencyCode as 'AgenctCurrecny',                    
 HB.SupplierCurrencyCode as 'SupplierCurrency',                    
 HB.ROEValue as 'Roe',                    
 Cast( (isnull(HB.DisplayDiscountRate,0) + isnull(HCC.EarningAmount,0) ) as int)as 'TotalRate',                    
 isnull(HCC.EarningAmount,0) as 'Discount',                    
 --isnull(HB.DisplayDiscountRate,0) as 'DebitToAgent'                    
  case                     
      when B2BPaymentMode=2 then isnull(TAB1.TranscationAmount,0)                    
 when B2BPaymentMode=4 then isnull(TSB1.TranscationAmount,0)                    
   else  isnull(HB.DisplayDiscountRate,0)                    
   end as  'DebitToAgent'                    
 --,isnull(TAB.TranscationAmount,0) as 'CreditToAgent'                    
 --,isnull(TSB.TranscationAmount,0) as 'CreditToUser'                    
   ,case                     
      when  HB.B2BPaymentMode=2 then isnull(TAB.TranscationAmount,0)                    
      when  HB.B2BPaymentMode=2 then isnull(TSB.TranscationAmount,0)                    
   else 0                    
   end 'CreditToAgent'                    
                   ,case                     
  when HB.B2BPaymentMode=1 then (0 - isnull(cast(HB.DisplayDiscountRate as decimal),0))                     
  when HB.B2BPaymentMode=2 then (isnull(Cast(TAB1.TranscationAmount as decimal),0) - isnull(Cast(HB.DisplayDiscountRate as decimal),0))                     
  when HB.B2BPaymentMode=3 then (isnull(Cast(MPC.AmountWithCommission as decimal),0) - isnull(cast(HB.DisplayDiscountRate as decimal),0))                     
  when HB.B2BPaymentMode=4 then (isnull(cast(TSB1.TranscationAmount as decimal),0) - isnull(cast(HB.DisplayDiscountRate as decimal),0))                     
 else 0                    
 end as 'Revenue'                    
                    
 --,(Cast( (isnull(HB.DisplayDiscountRate,0) + isnull(HCC.EarningAmount,0) ) as int) -  isnull(HB.DisplayDiscountRate,0)) as 'Revenue'                    
 , Case                        
      when B2BPaymentMode=1 then'Hold'                                        
   when B2BPaymentMode=2 then 'Credit Limit'                                                                                                                                          
   when  B2BPaymentMode=3 then 'Make Payment'                                                                                                             
   when  B2BPaymentMode=4 then 'Self Balance'                     
   when  B2BPaymentMode=5 then 'Pay At Hotel'                                                                                                                                              
   else   ''                    
   end as 'PaymentMode'                    
   ,isnull(MPC.ModeOfPayment,null) as 'PG_Mode'                    
   ,ISNULL(MPC.TotalCommission, 0) as 'Convience Fees'                    
   ,isnull(HB.SelectedNights,'0') as 'NoofNights'                    
   ,((isnull(HB.TotalAdults,0)) +'/'+ (isnull(HB.TotalChildren,0))) as 'Pax_A_C'                    
   ,isnull(HB.TotalRooms,0) as 'TotalRooms'                    
   ,HB.HotelName as 'HotelName'                    
   ,HB.cityName as 'City'                    
   --BEGIN Modified by bhushan, Faizan    
    
 --,FORMAT(CONVERT(datetime, HB.CheckInDate, 106), 'MM/dd/yyyy') +' '+Isnull(HB.CheckInTime,'12:00 AM') as 'CheckIn'    
  ----,FORMAT(CONVERT(datetime, HB.CheckInDate, 106), 'MM/dd/yyyy h:mm:ss tt') as 'CheckIn'      
  --,FORMAT(CONVERT(datetime, HB.CheckOutDate, 106), 'MM/dd/yyyy') +' ' +Isnull(HB.CheckOutTime,'12:00 AM') as 'CheckOut'    
  ---- ,FORMAT(CAST(HB.CheckOutDate AS datetime) , 'dd-MMM-yyyy HH:mm') as 'CheckOu     
  ,Convert(Varchar,HB.CheckInDate,106)+' '+Convert(Varchar,case isdate(HB.CheckInTime) when 1 then Replace(HB.CheckInTime,'NA','00:00')else '' end,108)  as 'CheckIn',    
  Convert(Varchar,HB.CheckOutDate,106)+' '+Convert(Varchar, case ISDATE(HB.CheckOutTime)when 1 then Replace(HB.CheckOutTime,'NA','00:00') else '' end,108) as 'CheckOut'    
    --END    
   ,BR.Icast as 'Agency_Code'                    
   ,BR.AgencyName as 'Agency_Name'                    
   ,HB.searchApiId as 'CorrelationId'                    
          
 from Hotel_BookMaster HB                    
 left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId                           
 left join Hotel_Status_Master SM on SH.FkStatusId=SM.Id                            
 left join B2BHotel_Commission HCC on HB.pkId=HCC.Fk_BookId                     
 left join tblAgentBalance TAB on TAB.BookingRef = HB.orderId and Tab.TransactionType='Credit'                    
 left join tblAgentBalance TAB1 on TAB1.BookingRef = HB.orderId and Tab1.TransactionType='Debit'                    
 left join tblSelfBalance TSB on TSB.BookingRef = HB.orderId and Tab.TransactionType='Credit'                    
 left join tblSelfBalance TSB1 on TSB1.BookingRef = HB.orderId and TSB1.TransactionType='Debit'                    
                    
 left join B2BMakepaymentCommission MPC on  MPC.OrderId= HB.orderId and MPC.ProductType='Hotel'                    
 left join B2BRegistration BR on BR.FKUserID=HB.RiyaAgentID                    
 where                    
 --HB.inserteddate between DATEADD(day, -2, CAST(GETDATE() AS date)) and  DATEADD(day, 2, CAST(GETDATE() AS date))              
 --(( cast(HB.inserteddate as date) between @StartDate and  @EndDate)or (@StartDate is null and @EndDate is null))  
 SH.IsActive=1 and
 ((( cast(HB.inserteddate as date) between @StartDate and  @EndDate and @SearchBy='0' )or (@StartDate is null and @EndDate is null))  or  
    
  (( cast(HB.CheckInDate as date) between @StartDate and  @EndDate and @SearchBy='1' )or (@StartDate is null and @EndDate is null  )))                         
-- and B2BPaymentMode=4                   
                   
 ) Reco                  
           
   select        
 ROW_NUMBER() over (order by BookingId) AS 'SrNo'        
, *  from #tempTableHotelReco             
 order by BookingId                
                  
                    
          
                    
END 