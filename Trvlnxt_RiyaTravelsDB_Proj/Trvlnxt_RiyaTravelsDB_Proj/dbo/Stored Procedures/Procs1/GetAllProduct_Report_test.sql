CREATE PROCEDURE GetAllProduct_Report_test --'10-Aug-2023','05-Jan-2024','0','4,1'                                    
    @StartDate VARCHAR(20) = '',                                        
    @EndDate VARCHAR(20) = '',                                       
    @SearchByDate VARCHAR(40) = '0',            
    @SearchByProduct VARCHAR(40) = ''                
AS              
BEGIN                              
    
	SET NOCOUNT ON;            
            if(OBJECT_ID('tempdb..#allRpt')is not null)
			drop table #allRpt
    IF exists(select Item from dbo.SplitString(@SearchByProduct,',')where Item in ('1'))    --Hotel        
    BEGIN            
      print '1'          
 select                                                               
    HB.BookingReference                                                                                                                                                                
    ,'Hotel' as [Service]                                                                                       
    ,mcn.Value as 'UserType'                                                         
    ,case when HB.MainAgentID!=0 then  'Internal'  --add column on 13-04-23                                   
   when HB.MainAgentID=0 then  'Agent'                                                                                                                            
   end as 'Customer Type'                                                                                                                               
    ,HB.BookingReference as [Booking Id]                                                                                         
    ,mybranch.Name as Branch                                        
  ,BR.AgencyName as 'Agency  User'                                                                                      
  ,Br.Icast as 'Agenct ID'                                      
  ,Case                                                            
    when HB.MainAgentID=0 then BR.AgencyName else Mu.FullName                                                               
   end  as 'User Name'                                                                                                 
   ,HB.LeaderTitle+' '+HB.LeaderFirstName+' '+HB.LeaderLastName  as 'Leader Guest Name'                                                                                      
   ,FORMAT(CAST(HB.inserteddate AS datetime) , 'dd-MM-yyyy HH:mm') as  [Booking Date]                                     
,format(cast(HB.CheckInDate as datetime),'dd-MM-yyyy ') as 'CheckIn Date'       -- add format of date on 24-4-23                                                                                 
   ,format(cast(HB.CheckOutDate  as datetime),'dd-MM-yyyy') as 'Checkout Date'                                                                                       
   ,convert(varchar,CancellationDeadLine,0) as 'Cancellation Deadline'                                                                    
  ,Case When HM.Status = 'Confirmed' Then 'Hold'  WHEN HM.Status=NULL THEN 'NA' else HM.Status                                                                                                                                                                 
  
    
      
       
             
   End as 'Booking Status'                   
 ,Case                                                                                                                            
  when HB.B2BPaymentMode=1 then 'Hold'                                                                                            
  when HB.B2BPaymentMode=2 then 'Credit Limit'                                                                                                                
  when HB.B2BPaymentMode=3 then 'Make Payment'                                                                                                 
  when HB.B2BPaymentMode=4 then 'Self Balance'                                                                                 
  when HB.B2BPaymentMode=5 then 'PayAtHotel'                                                                   
  else 'NA'                         
  ENd as 'Mode Of Payment'          
    ,HB.CurrencyCode as 'Booking Currency'                                                                                       
  ,HB.DisplayDiscountRate  as  'Booking Amount'                                                                                       
  ,HCC.EarningAmount as 'Agent Discount(Less TDS)'     --change column value as discussed with priti mam on 24-4-23                                                                                          
                                                 
 ,concat(HB.TotalServiceCharges, ' ','(', HB.GstAmountOnServiceChagres ,')') as 'Service Charges(including GST)'                                                          
 ,'' as 'Markup'     --add column on 31-8-23                                                          
 ,case when hb.currencycode='INR' then hb.DisplayDiscountRate else (isnull(hb.DisplayDiscountRate,0) * isnull(hb.FinalROE,1)) end as 'selling rate in INR'                                                          
  ,isnull(HB.providerConfirmationNumber,0)  as 'Supplier Ref. No'          -- add column on 11-04-23                                                          
 ,HB .SupplierName  as 'Supplier'                                                                                       
 ,HB.SupplierCurrencyCode as 'Supplier Currency'                                                                                      
 ,HB.SupplierRate as 'Supplier Gross (Base currency)'                                                                 
 ,ISnull(HB.SINRCommissionAmount,0) as 'Supplier Commission (Base Currency)'    --add on 10-8-23                                                 
 ,isnull(HB.ROEValue,0) as 'Sell ROE'    --Commented on 7-8-23                                                                                                           
 ,(isnull(HB.SupplierRate,0)-ISNULL(HB.SINRCommissionAmount,0))*HB.ROEValue  as 'Sell Net'    --commented on 10-8-23                                                                 
 ,isnull(HB.SupplierINRROEValue,0) as 'Supplier BuyRoE'                                                              
 ,isnull(HB.SupplierRate,0) * isnull(HB.SupplierINRROEValue,0) as 'BuyINR'                                  
 ,isnull(HB.SupplierCharges,0) as 'Supplier Service Charges'                                                                                      
 ,isnull(HB.VccValue,0) as 'VCC Bank Charges'                                           
 ,HCCD.CardType as 'VCC Card Type'                                      
 ,isnull(HB.SINRCommissionAmount,0) as 'Supplier Commission Net (INR)'                                                                                      
 ,isnull(HCC.EarningAmount,0) as 'Agent Part comm (INR)'                                                                                      
 ,cast(ISNULL(HB.HotelTDS,0) as varchar) +'( '+ cast( isnull(HCC.TDS,0) as varchar)+'%)'  as 'TDS on Agent Comm'                                                                                      
 ,'' as 'Riya Revenue'                                                  
 ,Cast(Isnull(MP.TotalCommission,0) as Varchar) +' ' +'('+Cast (ISnull (MP.ConvenienFeeInPercent,0.00) as varchar)+'%)' as 'PG Charges'                                                                                
 ,MP.ModeOfPayment as ' PG Confirmation No / PG Type'                                                                                           
 ,HB.cityName as 'City'                                                                
 ,Case  when CHARINDEX(',',CountryName) >0  THEN right(CountryName, charindex(',', reverse(CountryName)) - 1)                                                                                                                                    
 else CountryName end  as 'Country'    --add on 01-9-23       
                 
 ,HB.HotelName as 'Hotel Name'                                                                
 ,(convert(int, isnull(TotalAdults,'0'))+convert(int, isnull(TotalChildren,'0')))  as 'No. of Passengers'                                                                                      
  ,HB.SelectedNights as 'No. of Nights'                                                                  
  ,TotalRooms as 'No. of Rooms'                                                                  
 ,(Cast( isnull (HB.SelectedNights, 1 )as int) * Cast( isnull (HB.TotalRooms, 1 )as int)) as 'Total Room Nights'                                                          
 ,hb.OBTCNo AS 'OBTC NO'                                                          
 ,HB.HotelConfNumber as 'Hotel Confirmation'                                                                                      
 ,HB.ConfirmationDate  as 'Date of confirmation'                                                                                    
 ,isnull(HP.Pancard,'NA') as 'PAN Card No'                                                          
 ,isnull(HP.PanCardName,'NA') as 'PanCard Name'                                                 
 ,ISnull(REPLACE(HB.PanCardURL, '/Documents/PancardDocument/', 'https://trvlnxt.com/newhotel/Documents/PancardDocument/'),'NA') AS Declaration                                                                                      
 ,HP.PassportNum  as 'Passport No'                                                        
 ,HP.IssueDate as 'Date of Issue'                                                          
 ,HP.PassPortDOB as 'Date of Birth'                                                          
 ,HP.Expirydate as 'Date of Expire'                            
 ,HBGD.GstNumber as 'GST Number'                                                                                      
                                                               
 ,'' as 'Undertaking Doclink'                                                           
                                                          
 ,Case when HB.BookingReference like '%TNHAPI%'  then ' '                                                           
 when HB.B2BPaymentMode<>5 then ' '                                                        
 when HB.B2BPaymentMode=5 and  HB.orderId=tba.BookingRef then 'Received' else 'Pending'                                                          
 end as 'Pay@hotel Commission Status'       --add join on 8-8-23                                                                             
 ,HCC.[Actual Commission Received] as 'Pay@hotel Commission Received'                                                                      
 ,HCC.EarningAmount as 'Pay@hotel Commission Paid'    --add join on 8-8-23                                                            
   ,HB.SupplierBookingUrl as 'Agoda URL'                                                                                      
  ,HB.SupplierBookingPaymentDate as 'BNPL DeadLine Date'                                                          
                                                                 
 ------ for report of Cancellation type ---                                              
  ,ISnull(HB.SupplierCancellationCharges,0)  as 'Supplier Cancellation Amount'                                                          
  ,ISNULL(HB.agentCancellationCharges,0)  as 'Agent Cancellation Amount'                                              
  ,    ISNULL(CONVERT(varchar, HB.CancellationDate, 120), '-') AS 'Cancellation Date'                                                
                                                
,CASE                                           
    WHEN HB.CancelledBy IS NULL THEN CONVERT(varchar(20), '-')                                          
    WHEN HB.CancelledBy = 0 THEN BR.AgencyName                                          
    ELSE CONVERT(varchar(40), Mu.FullName)      
END AS Cancelled_By                                           
                                              
,ISNULL(HB.ModeOfCancellation,'-')    as   'Mode Of Cancellation'                    
,HB.PaymentStatus as 'Payment Status'                        
,HB.PaymentRemark  as 'Payment Remark'                        
      
	  into #allRpt               
  from Hotel_BookMaster HB                                                                    
   left join mUser MU on MU.ID=HB.MainAgentID                                                                                                                                                       
   left join Hotel_Pax_master HP on HB.pkId=HP.book_fk_id    and IsLeadPax=1                                                                                               
   left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId                                                                                                                                       
   left join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                                                                                                                                                             
   join AgentLogin AGL on HB.RiyaAgentID=AGL.UserID                                                                                                                                                               
   left join B2BMakepaymentCommission MP on HB.pkId=MP.FkBookId and ProductType='Hotel'                                                                      
   left join Hotel_Status_Master HM on SH.FkStatusId=HM.Id                                                                                                         
                                
   left join(                                    
  select mbr.BranchCode,MAx(name) as 'Name',Max(Division) as 'Division',max(id) as maxid from mBranch as mbr  group by BranchCode                                                                                                                             
  
 ) as mybranch                                                                                        
 on br.BranchCode=mybranch.BranchCode                                         
                                                                                 
   left join roe R on HB.pkId = R.Id                                                                                                     
   left join Hotel_ROE_Booking_History Roe on Roe.FkBookId=Hb.pkId                                                                  
   left join Hotel_BookingGSTDetails HBGD on HBGD.PKID=HB.pkId             -- add column on 31-03-23                                                                     
   left join B2BHotel_Commission HCC on HB.pkId=HCC.Fk_BookId              -- add on 05-04-23                                                                                                                   
   left join mCommon  mcn on mcn.ID=AGL.userTypeID                         --add on 12-04-23                                                                                                                          
   Left join Hotel.tblApiCreditCardDeatils HCCD on Hb.BookingReference= HCCD.BookingId                                                                        
   left join tblAgentBalance tba on HB.orderId=tba.BookingRef           --add join on 8-8-23                                               
   --Left Join hotedupdatedhistory HH on HB.pkId=HH.fkbookid                                                   
                                            
 where                                                                                       
                                                                                                                                         
 mybranch.Division  like 'RTT%' and mybranch.BranchCode like 'BR%'                        
                                                                                                                            
   and SH.IsActive=1                                                                                                      
   and HB.RiyaAgentID is not null                    
   and HB.B2BPaymentMode is not null                                                                                                                                             
   --and HB.BookingReference is not null             
                     
            AND                  
            (            
                (@SearchByDate = '1' AND CAST(HB.CheckInDate AS DATE) BETWEEN @StartDate AND @EndDate)            
                OR            
                (@SearchByDate = '0' AND CAST(HB.inserteddate AS DATE) BETWEEN @StartDate AND @EndDate)            
                OR            
                (@StartDate IS NULL AND @EndDate IS NULL)            
            )            
                 
 order by HB.pkId desc           
        
    END            
        
    ELSE IF exists(select Item from dbo.SplitString(@SearchByProduct,',')where Item in('4'))     --Sightseeing        
    BEGIN  
	
	print '4'
        SELECT    
     BM.BookingRefId AS 'BookingReference'   
    ,'Sightseeing' as [Service]       
     ,BM.BookingStatus AS 'CurrentStatus',            
            ISNULL(BR.AgencyName + '-' + MU.FullName, '') AS 'AgencyName',            
            ISNULL(PD.Titel + ' ' + PD.Name + ' ' + PD.Surname, '') AS 'TravellerName',            
            CASE WHEN BM.creationDate = '1753-01-01 00:00:00.000' THEN '2023-01-01 00:00:00.000' ELSE ISNULL(BM.creationDate, '') END AS 'BookingDate',            
            BM.TripStartDate AS 'ActivityDate',            
            CASE WHEN BM.CancellationDeadline = '1753-01-01 00:00:00.000' THEN '2023-01-01 00:00:00.000' ELSE ISNULL(BM.CancellationDeadline, '') END AS 'DeadLineDate',            
            BA.ActivityName AS 'ActivityName',            
            BM.totalPax AS 'NoOfPassengers',            
            BM.CityCode AS 'City',            
            BM.CountryCode AS 'Country',            
            CASE            
                WHEN BM.PaymentMode = 1 THEN 'Hold'            
                WHEN BM.PaymentMode = 2 THEN 'Credit Limit'            
                WHEN BM.PaymentMode = 3 THEN 'Make Payment'            
                WHEN BM.PaymentMode = 4 THEN 'Self Balance'            
                ELSE ''            
            END AS 'ModeOfPayment',            
            BM.BookingCurrency AS 'BookingCurrency',            
            BM.BookingRate AS 'AgentBookingAmount',            
            '' AS 'ServiceChargesIncludingGST',            
            BM.Markup AS 'Markup',            
            '' AS 'ROE',            
            BM.BookingRate AS 'AgentRateInINR',            
            PD.PancardNo AS 'PanCardNo',            
            '' AS 'PanCardName',            
            '' AS 'Declaration',            
            PD.PassportNumber AS 'PassportNo',            
            CASE WHEN PD.PassportIssueDate = '1753-01-01 00:00:00.000' THEN '2023-01-01 00:00:00.000' ELSE ISNULL(PD.PassportIssueDate, '') END AS 'DateOfIssue',            
            CASE WHEN PD.DateOfBirth = '1753-01-01 00:00:00.000' THEN '2023-01-01 00:00:00.000' ELSE ISNULL(PD.DateOfBirth, '') END AS 'DateOfBirth',            
            CASE WHEN PD.PassportExpirationDate = '1753-01-01 00:00:00.000' THEN '2023-01-01 00:00:00.000' ELSE ISNULL(PD.PassportExpirationDate, '') END AS 'DateOfExpire',            
            BM.providerName AS 'SupplierName',            
            BM.ProviderConfirmationNumber AS 'SupplierReferenceNo',            
            BM.SupplierCurrency AS 'SupplierCurrency',            
            BM.SupplierRate AS 'SupplierBookingAmount',            
            '' AS 'ROE',            
            CONCAT(BM.SupplierCurrency, ' ', BM.SupplierRate) AS 'SupplierRateInINRAndAED',            
            '' AS 'SupplierServiceCharges',            
            '' AS 'VCCBankCharges',            
            '' AS 'VCCCardType',            
            CASE                 
                WHEN BM.PaymentMode = 3 THEN CONCAT(BM.BookingCurrency, ' ', CONVERT(VARCHAR, BM.BookingRate))            
                ELSE 'NA'            
            END AS 'PGCharges',            
            CASE WHEN BM.PaymentMode = 3 THEN 'Yes' ELSE 'No' END AS 'PGConfirmationNoPGType'            
	  into #allSRpt               
      
	  FROM                                                    
            ss.SS_BookingMaster BM                                                     
            LEFT JOIN SS.SS_BookedActivities BA ON BM.BookingId = BA.BookingId                                                    
            JOIN SS.SS_PaxDetails PD ON BM.BookingId = PD.BookingId                                                    
            LEFT JOIN B2BRegistration BR ON BM.AgentID = BR.FKUserID                                                                                                                                 
            LEFT JOIN mUser MU ON BM.MainAgentID = MU.ID                                            
   LEFT JOIN Hotel_Status_Master HM ON BM.BookingStatus = HM.Status                                
            LEFT JOIN Ss.SS_Status_History SH ON BM.BookingId = SH.BookingId                                
        WHERE                     
            SH.IsActive = 1                  
            AND                  
            (            
                (@SearchByDate = '1' AND CAST(BM.TripStartDate AS DATE) BETWEEN @StartDate AND @EndDate)            
                OR            
                (@SearchByDate = '0' AND CAST(BM.creationDate AS DATE) BETWEEN @StartDate AND @EndDate)            
                OR            
                (@StartDate IS NULL AND @EndDate IS NULL)            
            )            
        ORDER BY             
            BM.creationDate DESC            
               
    END 
	

	select * from #allRpt  
	UNION 
	select * from #allSRpt
	  --if(OBJECT_ID('tempdb..#allRpt')is not null)
			--drop table #allRpt
END;  
  
  