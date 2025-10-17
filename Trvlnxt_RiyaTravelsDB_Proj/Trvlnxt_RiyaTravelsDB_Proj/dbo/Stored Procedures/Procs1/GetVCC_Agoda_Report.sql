                      
                      
  --  GetVCC_Agoda_Report                      
                      
   --GetVCC_Agoda_Report @StartDate='01-Sep-2024',@EndDate='04-Sep-2024',@SearchBy='1'          
                        
                        
CREATE Proc [dbo].[GetVCC_Agoda_Report]                                        
                                        
@StartDate varchar(20) = null,                                            
@EndDate varchar(20)=null,                                       
@SupplierName varchar(100)=null,                        
@BookingID varchar(40)=null,                        
@SearchBy varchar(40)='0'                        
as                                              
 begin                                        
                         
 if @SearchBy='0'                        
 Begin                        
                        
SELECT                                          
                                        
BookingReference  AS 'Booking_ID',                                               
SupplierReferenceNo AS 'Supplier_Booking_ID',                                     
SupplierName as 'SupplierNme',                                                   
HotelName as 'Hotel_Name',                            
(HB.LeaderTitle + ' ' + HB.LeaderFirstName + ' ' + HB.LeaderLastName+'') as PassengerName,                            
-- (HP.Salutation+' '+HP.FirstName +' '+ HP.LastName+ ' ' )  as PassengerName,                                   
CurrentStatus as 'Supplier_Status',                                             
--HB.inserteddate as 'Booking_date',
FORMAT(CAST(HB.inserteddate AS datetime),'dd MMM yyyy hh:mm tt') as Booking_date , 
                                  
--HB.CheckInDate as 'Check_In',   
FORMAT(CAST(HB.CheckInDate AS datetime),'dd MMM yyyy hh:mm tt') as Check_In, 

--HB.CheckOutDate as 'Check_Out' ,                                     
FORMAT(CAST(HB.CheckOutDate AS datetime),'dd MMM yyyy hh:mm tt') as Check_Out,

--  case when HB.SupplierRate is null then 0 else HB.SupplierRate end as 'VccAmt' , 
case when HCCD.Amount is null then 0 else CAST(HCCD.Amount as decimal(18,2)) end as 'VccAmt' , --09/06/25 added after added 1% on vccamt
case when HB.SupplierCurrencyCode='INR' and HB.CurrencyCode='INR' then 1 else ISNULL(HB.SupplierINRROEValue,Hb.ROEValue)             
end as 'ROE',                                   
HB.SupplierCurrencyCode as 'Vcc_Currency',                                
--case when HB.CurrencyCode='INR' and HB.CurrencyCode='INT' then (isnull(HB.SupplierRate,0)*1) else  isnull(cast(HB.SupplierRate * isnull(HB.SupplierINRROEValue,Hb.ROEValue) as decimal(18,2)),0)             
--end  as [VCCinINR],
Cast(CAST(HCCD.Amount as decimal(18,2)) * HB.SupplierINRROEValue as decimal(18,2))    as [VCCinINR],                                   
'INR' as 'Currency',                                
                                                            
                               
 SUBSTRING(number,LEN(number)-4,5) AS 'Vcc_CardNo',                              
HCCD.CardType as 'CardType',                               
                                                    
  --case when HB.SupplierPkId in (3,30) and (HB.SupplierBookingUrl IS NULL)  then '' when (HB.SupplierBookingUrl='') then '' when HB.SupplierPkId in (3,30)  HB.SupplierBookingUrl END AS 'Self_Service_URL'      --OK                                         
  
   
 case when HB.SupplierPkId in (3,30) then  HB.SupplierBookingUrl else '' END AS 'Self_Service_URL'      --OK                                            
                                    
,Isnull(HCCD.vccCardStatus,'Active')   as vccCardStatus                
FROM Hotel_BookMaster HB  WITH (NOLOCK)                                      
                                     
inner join Hotel.tblApiCreditCardDeatils HCCD WITH (NOLOCK) on Hb.BookingReference= HCCD.BookingId                                     
WHERE                                    
                                
(( HB.SupplierName  like '%' + @SupplierName + '%') or (@SupplierName Is null   ))                                  
                                
AND                                  
                         
                           
(( cast(HB.inserteddate as date) between @StartDate and  @EndDate )or (@StartDate is null and @EndDate is null))                       
                                     
order by HB.inserteddate desc                          
end                        
                
                        
else if @SearchBy='1'                        
begin                        
                        
SELECT                                       
                                        
BookingReference  AS 'Booking_ID',                                               
SupplierReferenceNo AS 'Supplier_Booking_ID',                                     
SupplierName as 'SupplierNme',                                                   
HotelName as 'Hotel_Name',                   
(HB.LeaderTitle + ' ' + HB.LeaderFirstName + ' ' + HB.LeaderLastName+'') as PassengerName,                            
                                 
CurrentStatus as 'Supplier_Status',                                             
--HB.inserteddate as 'Booking_date',
FORMAT(CAST(HB.inserteddate AS datetime),'dd MMM yyyy hh:mm tt') as Booking_date , 
                                  
--HB.CheckInDate as 'Check_In',   
FORMAT(CAST(HB.CheckInDate AS datetime),'dd MMM yyyy hh:mm tt') as Check_In, 

--HB.CheckOutDate as 'Check_Out' ,                                     
FORMAT(CAST(HB.CheckOutDate AS datetime),'dd MMM yyyy hh:mm tt') as Check_Out,
                                  
--  case when HB.SupplierRate is null then 0 else HB.SupplierRate end as 'VccAmt' , 
case when HCCD.Amount is null then 0 else CAST(HCCD.Amount as decimal(18,2)) end as 'VccAmt' , --09/06/25 added after added 1% on vccamt
case when HB.SupplierCurrencyCode='INR' and HB.CurrencyCode='INR' then 1 else ISNULL(HB.SupplierINRROEValue,Hb.ROEValue)             
end as 'ROE',                                   
HB.SupplierCurrencyCode as 'Vcc_Currency',                                
--case when HB.CurrencyCode='INR' and HB.CurrencyCode='INT' then (isnull(HB.SupplierRate,0)*1) else  isnull(cast(HB.SupplierRate * isnull(HB.SupplierINRROEValue,Hb.ROEValue) as decimal(18,2)),0)             
--end  as [VCCinINR],
Cast(CAST(HCCD.Amount as decimal(18,2)) * HB.SupplierINRROEValue as decimal(18,2))    as [VCCinINR],                                          
'INR' as 'Currency',                                
                                                    
                      
 --HCCD.number as 'CardNumber',  --OK                                 
 SUBSTRING(number,LEN(number)-4,5) AS 'Vcc_CardNo',                               
HCCD.CardType as 'CardType',                               
                                         
  --case when (HB.SupplierBookingUrl IS NULL)  then '' when (HB.SupplierBookingUrl='') then '' else HB.SupplierBookingUrl END AS 'Self_Service_URL'      --OK                                            
 case when HB.SupplierPkId in (3,30) then  HB.SupplierBookingUrl else '' END AS 'Self_Service_URL'      --OK                                            
          ,Isnull(HCCD.vccCardStatus,'Active')   as vccCardStatus                       
                               
                                        
FROM Hotel_BookMaster HB WITH (NOLOCK)                                       
                                        
--inner join Hotel_Pax_master HP on HB.pkId=HP.book_fk_id                                         
inner join Hotel.tblApiCreditCardDeatils HCCD WITH (NOLOCK) on Hb.BookingReference= HCCD.BookingId                                     
WHERE                                    
                                
(( HB.SupplierName  like '%' + @SupplierName + '%' ) or (@SupplierName Is null   ))                                  
                                
AND                                  
                         
                           
(( cast(HB.CheckInDate as date) between @StartDate and  @EndDate )or (@StartDate is null and @EndDate is null))                              
                                 
                           
                           
order by HB.CheckInDate desc                        
                        
end                        
                        
                        
else IF @SearchBy='2'                        
begin                        
                        
                        
SELECT                                          
                                        
BookingReference  AS 'Booking_ID',                                               
SupplierReferenceNo AS 'Supplier_Booking_ID',                             
SupplierName as 'SupplierNme',                                                   
HotelName as 'Hotel_Name',                            
(HB.LeaderTitle + ' ' + HB.LeaderFirstName + ' ' + HB.LeaderLastName+'') as PassengerName,                            
-- (HP.Salutation+' '+HP.FirstName +' '+ HP.LastName+ ' ' )  as PassengerName,                                   
CurrentStatus as 'Supplier_Status',                                             
--HB.inserteddate as 'Booking_date',
FORMAT(CAST(HB.inserteddate AS datetime),'dd MMM yyyy hh:mm tt') as Booking_date , 
                                  
--HB.CheckInDate as 'Check_In',   
FORMAT(CAST(HB.CheckInDate AS datetime),'dd MMM yyyy hh:mm tt') as Check_In, 

--HB.CheckOutDate as 'Check_Out' ,                                     
FORMAT(CAST(HB.CheckOutDate AS datetime),'dd MMM yyyy hh:mm tt') as Check_Out,
                                  
--  case when HB.SupplierRate is null then 0 else HB.SupplierRate end as 'VccAmt' , 
case when HCCD.Amount is null then 0 else CAST(HCCD.Amount as decimal(18,2)) end as 'VccAmt' , --09/06/25 added after added 1% on vccamt
case when HB.SupplierCurrencyCode='INR' and HB.CurrencyCode='INR' then 1 else ISNULL(HB.SupplierINRROEValue,Hb.ROEValue)             
end as 'ROE',                                   
HB.SupplierCurrencyCode as 'Vcc_Currency',                                
--case when HB.CurrencyCode='INR' and HB.CurrencyCode='INT' then (isnull(HB.SupplierRate,0)*1) else  isnull(cast(HB.SupplierRate * isnull(HB.SupplierINRROEValue,Hb.ROEValue) as decimal(18,2)),0)             
--end  as [VCCinINR],
Cast(CAST(HCCD.Amount as decimal(18,2)) * HB.SupplierINRROEValue as decimal(18,2))    as [VCCinINR],       
'INR' as 'Currency',                                
                                                      
                                       
 --HCCD.number as 'CardNumber',  --OK                                 
 SUBSTRING(number,LEN(number)-4,5) AS 'Vcc_CardNo',                              
HCCD.CardType as 'CardType',                               
                                                    
  --case when (HB.SupplierBookingUrl IS NULL)  then '' when (HB.SupplierBookingUrl='') then '' else HB.SupplierBookingUrl END AS 'Self_Service_URL'      --OK                                 
    case when HB.SupplierPkId in (3,30) then  HB.SupplierBookingUrl else '' END AS 'Self_Service_URL'      --OK                                            
          ,Isnull(HCCD.vccCardStatus,'Active')   as vccCardStatus                      
                                 
                                        
FROM Hotel_BookMaster HB  WITH (NOLOCK)                                      
                                        
--inner join Hotel_Pax_master HP on HB.pkId=HP.book_fk_id                                         
inner join Hotel.tblApiCreditCardDeatils HCCD WITH (NOLOCK) on Hb.BookingReference= HCCD.BookingId                                     
WHERE                                    
                         
                     
                       
 HB.BookingReference=@BookingID                        
                                
                        
                        
end                        
                        
ELSE                        
                        
BEGIN                        
                        
SELECT                                          
                                        
BookingReference  AS 'Booking_ID',                                               
SupplierReferenceNo AS 'Supplier_Booking_ID',                                     
SupplierName as 'SupplierNme',                                                   
HotelName as 'Hotel_Name',                            
(HB.LeaderTitle + ' ' + HB.LeaderFirstName + ' ' + HB.LeaderLastName+'') as PassengerName,                            
-- (HP.Salutation+' '+HP.FirstName +' '+ HP.LastName+ ' ' )  as PassengerName,                                   
CurrentStatus as 'Supplier_Status',                                             
--HB.inserteddate as 'Booking_date',
FORMAT(CAST(HB.inserteddate AS datetime),'dd MMM yyyy hh:mm tt') as Booking_date , 
                                  
--HB.CheckInDate as 'Check_In',   
FORMAT(CAST(HB.CheckInDate AS datetime),'dd MMM yyyy hh:mm tt') as Check_In, 

--HB.CheckOutDate as 'Check_Out' ,                                     
FORMAT(CAST(HB.CheckOutDate AS datetime),'dd MMM yyyy hh:mm tt') as Check_Out,
             
 case when HB.SupplierRate is null then 0 else HB.SupplierRate end as 'VccAmt' ,                                      
case when HB.SupplierCurrencyCode='INR' and HB.CurrencyCode='INR' then 1 else ISNULL(HB.SupplierINRROEValue,Hb.ROEValue)             
end as 'ROE',                                   
HB.SupplierCurrencyCode as 'Vcc_Currency',                                
case when HB.CurrencyCode='INR' and HB.CurrencyCode='INT' then (isnull(HB.SupplierRate,0)*1) else  isnull(cast(HB.SupplierRate * isnull(HB.SupplierINRROEValue,Hb.ROEValue) as decimal(18,2)),0)             
end  as [VCCinINR],                                    
'INR' as 'Currency',                                
                                  
            
-- case when HB.SupplierRate is null then 0 else HB.SupplierRate end as 'VccAmt' ,                                      
--case when HB.SupplierCurrencyCode='AED' and HB.CurrencyCode='INR' THEN hb.FinalROE ELSE  HB.ROEValue END  as 'ROE',                                   
--HB.SupplierCurrencyCode as 'Vcc_Currency',                             
--CASE WHEN HB.SupplierCurrencyCode='AED' and HB.CurrencyCode='INR' THEN cast(COALESCE(COALESCE (HB.SupplierRate *hb.FinalROE ,HB.DisplayDiscountRate),0) as decimal(18,2))                               
--else  cast(COALESCE(COALESCE (HB.SupplierRate * HB.ROEValue,HB.DisplayDiscountRate),0) as decimal(18,2)) end as [VCCinINR],                                    
--'INR' as 'Currency',      --old code for all queries                            
                                       
 --HCCD.number as 'CardNumber',  --OK                                 
 SUBSTRING(number,LEN(number)-4,5) AS 'Vcc_CardNo',                               
HCCD.CardType as 'CardType',                               
                                                    
  --case when (HB.SupplierBookingUrl IS NULL)  then '' when (HB.SupplierBookingUrl='') then '' when HB.SupplierUsername != 'rt-agoda' then '' else HB.SupplierBookingUrl  END AS 'Self_Service_URL'      --OK                                            
 case when HB.SupplierPkId in (3,30) then  HB.SupplierBookingUrl else '' END AS 'Self_Service_URL'      --OK                                            
          ,Isnull(HCCD.vccCardStatus,'Active')   as vccCardStatus                       
                                        
FROM Hotel_BookMaster HB WITH (NOLOCK)                                       
                                        
--inner join Hotel_Pax_master HP on HB.pkId=HP.book_fk_id                                         
inner join Hotel.tblApiCreditCardDeatils HCCD WITH (NOLOCK) on Hb.BookingReference= HCCD.BookingId                        
                        
END                        
                        
                        
END