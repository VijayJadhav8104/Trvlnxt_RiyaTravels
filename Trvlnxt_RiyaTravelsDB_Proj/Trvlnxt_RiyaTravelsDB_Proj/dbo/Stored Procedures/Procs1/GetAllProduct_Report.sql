--Exec GetAllProduct_Report '01-Jan-2025' ,'13-Aug-2025', 0, 'Hotels,Activities,Rail'                 
 --Exec GetAllProduct_Report '15-June-2024' ,'24-June-2024', 0, 'Rail,Cruise'                 
  
                 
CREATE proc [dbo].[GetAllProduct_Report]                                               
    @StartDate VARCHAR(20) = '',                                                                                                        
    @EndDate VARCHAR(20) = '',                                                                                                       
    @SearchByDate VARCHAR(40) = '',                                                                            
    @SearchByProduct VARCHAR(40) = ''                                                    
                                         
 as                                               
 begin                                                
     
     
  
 create table #rptAllProduct (           
-- SrNo int,          
 Bookingreference varchar(max),                                                
 service varchar(max),                                                
 UserType varchar(max),                                                             
 Customer_Type varchar(max),                                                                                                                                                                                             
 Branch  varchar(max),                                                                                                 
 Agency_User varchar(max),                                                                                                                                                     
 Agenct_ID varchar(max),                                                                                                  
 Leader_Guest_Name varchar(max),                                                                                                                                                      
 Booking_Date    varchar(max),                                                                                                
 Service_start_date varchar(max),                                                                                                                                                  
 Service_end_date  varchar(max),                                                                                                                                                       
 Cancellation_Deadline  varchar(max),                                                                                                                                    
 Booking_Status  varchar(max),                                                                                   
 Mode_Of_Payment varchar(max),                                                                          
 Booking_Currency varchar(max),                                                                                                                    
 Booking_Amount varchar(max),                                                                                                                                                                                 
 Supplier varchar(max),                                                                                                                                                       
 Supplier_Currency varchar(max),                                                                                                                                                      
 Supplier_Gross varchar(max),                                                                                                                                 
 City varchar(max),                                                                                                                                
 Country varchar(max),                                  
 Service_Name varchar(max),                                                                         
 No_of_Passengers varchar(max),                                                                
 No_of_Nights varchar(max),                                                            
 No_of_Rooms varchar(max),                                                                                                                                  
 Total_Room_Nights varchar(max),                                 
Supplier_Confirmation varchar(max),                                                
 PAN_Card_No varchar(max),                                                  
 Nationality varchar(max),                                                                
 Passport_No varchar(max)                                        
 )                                                                                                       
         
         
 if(exists(select value from dbo.fn_split(@SearchByProduct,',') where value='Hotels'))                                                          
 BEGIN         
         
                                     
insert into #rptAllProduct                                                
                                                       
select    distinct        
  --ROW_NUMBER() OVER(ORDER BY (HB.pkId) DESC) as SrNo,        
  HB.BookingReference                                                                                     
  ,'Hotel' as 'Service'                                                                                                                                                       
  ,mcn.Value as 'UserType'                                                                   
  ,case when HB.MainAgentID!=0 then  'Internal'  --add column on 13-04-23                                                                                                   
   when HB.MainAgentID=0 then  'Agent'                                                                                                                                                                                            
   end as 'Customer Type'                                                                                                                                                                                               
  ,mybranch.Name as Branch                                                                                                        
  ,BR.AgencyName as 'Agency  User'                                                                                                                                                      
  ,Br.Icast as 'Agenct ID'                                                                                                      
  ,HB.LeaderTitle+' '+ HB.LeaderFirstName+' '+HB.LeaderLastName  as 'Leader Guest Name'                                                                                                                                                      
  ,FORMAT(case isdate( HB.inserteddate)when 1 then HB.inserteddate else '' end , 'dd-MMM-yyyy HH:mm') as  [Booking Date]                                                                                                     
 ,format(case isdate(HB.CheckInDate) when 1 then  HB.CheckInDate else '' end ,'dd-MMM-yyyy') as 'Service start_date'       -- add format of date on 24-4-23                                                                                                   
  
    
             
 ,format(case isdate(HB.CheckOutDate) when 1 then HB.CheckOutDate else '' end ,'dd-MMM-yyyy') as 'Service end_date'                                                                                                                                            
  
    
      
         
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
 ,HB.SupplierName  as 'Supplier'                                                          
 ,HB.SupplierCurrencyCode as 'Supplier Currency'                                                                                                                                               
 ,HB.SupplierRate as 'Supplier Gross'                                                                                                                            
                                                                                                                                                        
 ,HB.cityName as 'City'                                                                                                                                
 ,Case  when CHARINDEX(',',CountryName) >0  THEN right(CountryName, charindex(',', reverse(CountryName)) - 1)                            
  else CountryName end  as 'Country'    --add on 01-9-23                                                                       
,HB.HotelName as 'Service Name'                                                                                                                                
 ,(convert(int, isnull(TotalAdults,'0'))+convert(int, isnull(TotalChildren,'0')))  as 'No_of_Passengers'                                                                                                                                                      
  ,HB.SelectedNights as 'No_of_Nights'                                                                                                                                  
  ,TotalRooms as 'No_of_Rooms'                                                                                                                                  
 ,(Cast( isnull (HB.SelectedNights, 1 )as int) * Cast( isnull (HB.TotalRooms, 1 )as int)) as 'Total Room Nights'                                                                                                                          
 ,HB.HotelConfNumber as  'Supplier Confirmation'                                                                                                                                                      
 ,isnull(HP.Pancard,'NA') as 'PAN Card No'                                                                                                                          
                                                                   
 ,HP.Nationality as 'Nationality'                                                                  
 ,HP.PassportNum  as 'Passport No'                                                                                                                        
                                                           
  from Hotel_BookMaster HB WITH (NOLOCK)                                                                                                                                    
   left join mUser MU WITH (NOLOCK) on MU.ID=HB.MainAgentID                                                   
   left join Hotel_Pax_master HP WITH (NOLOCK) on HB.pkId=HP.book_fk_id    and IsLeadPax=1                           
   left join Hotel_Status_History SH WITH (NOLOCK) on HB.pkId=SH.FKHotelBookingId                                                  
   left join B2BRegistration BR WITH (NOLOCK) on HB.RiyaAgentID=BR.FKUserID                                                                                                                  
   join AgentLogin AGL WITH (NOLOCK) on HB.RiyaAgentID=AGL.UserID                                                                     
   left join B2BMakepaymentCommission MP WITH (NOLOCK) on HB.pkId=MP.FkBookId and ProductType='Hotel'                                                                                                           
   left join Hotel_Status_Master HM WITH (NOLOCK) on SH.FkStatusId=HM.Id                                                                                         
                                                                                           
   left join(                                                                                                    
 select mbr.BranchCode,MAx(name) as 'Name',Max(Division) as 'Division',max(id) as maxid from mBranch as mbr  group by BranchCode                                                                                         
                                              
                                               
) as  mybranch                                                                                                    
 on br.BranchCode=mybranch.BranchCode                                                  
                                                                                  
   left join roe R WITH (NOLOCK) on HB.pkId = R.Id                                                                                                                                                                     
   left join Hotel_ROE_Booking_History Roe WITH (NOLOCK) on Roe.FkBookId=Hb.pkId                                                                                                                                  
   left join Hotel_BookingGSTDetails HBGD WITH (NOLOCK) on HBGD.PKID=HB.pkId             -- add column on 31-03-23                                                                                                                                     
   left join B2BHotel_Commission HCC WITH (NOLOCK) on HB.pkId=HCC.Fk_BookId              -- add on 05-04-23                                                                                                                                                   
   
   
                 
   left join mCommon  mcn WITH (NOLOCK) on mcn.ID=AGL.userTypeID                         --add on 12-04-23                                                                                                                                                     
  
    
                               
   Left join Hotel.tblApiCreditCardDeatils HCCD WITH (NOLOCK) on Hb.BookingReference= HCCD.BookingId                                                                                                                                        
   left join tblAgentBalance tba WITH (NOLOCK) on HB.orderId=tba.BookingRef           --add join on 8-8-23                                                                                                               
   Left Join Hotel_UpdatedHistory HH WITH (NOLOCK) on HB.pkId=HH.fkbookid                                                                                                                   
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
                                                                                 
 --order by HB.pkId desc           
         
         
 END                                                                            
         
         
 if(exists(select value from dbo.fn_split(@SearchByProduct,',') where value='Activities')) --Sightseeing                                                                        
                                       
  BEGIN        
 insert into #rptAllProduct                                                    
                                             
 select     distinct  
          
   --  ROW_NUMBER() OVER(ORDER BY (BM.creationDate) DESC) as SrNo,        
   BM.BookingRefId as BookingReference                                                                                                          
   ,'Sightseeing' as 'Service'                                                                                                    
   ,mcn.Value as 'UserType'                                                                   
                                                                   
   ,case when BM.MainAgentID!=0 then  'Internal'  --add column on 13-04-23                                                                                                   
   when BM.MainAgentID=0 then  'Agent'                                                                                                     
   end as 'Customer Type'                                                                                                                                                                                               
                                                                      
  ,'NA' as Branch                                                                                                        
  ,'NA' as 'Agency  User'                                                                                                                                                      
  ,Br.Icast as 'Agenct ID'                                                                                                      
                                                 
   ,PD.Titel+' '+PD.Name+' '+PD.Surname  as 'Leader Guest Name'                                                                                                                                 
   ,FORMAT(CAST(BM.creationDate AS datetime) , 'dd-MMM-yyyy HH:mm') as  [Booking Date]                                                                                    
   ,format(cast(BM.TripStartDate as datetime),'dd-MMM-yyyy  ') as 'Service start_date'       -- add format of date on 24-4-23                                        
                  
   ,format(cast(BM.TripEndDate  as datetime),'dd-MMM-yyyy') as 'Service end_date'               
   ,convert(varchar,CancellationDeadLine,0) as 'Cancellation Deadline'                                                                                                                                  
  ,Case When HM.Status = 'Confirmed' Then 'Hold'  WHEN HM.Status=NULL THEN 'NA' else HM.Status                                  
                        
                                
 End as 'Booking Status'                                                                    
 ,Case                                                                                                                       
  when BM.PaymentMode=1 then 'Hold'                                                        
  when BM.PaymentMode=2 then 'Credit Limit'                                                      
  when BM.PaymentMode=3 then 'Make Payment'                                     
  when BM.PaymentMode=4 then 'Self Balance'                                                                                                                                                 
  when BM.PaymentMode=5 then 'PayAtHotel'                                                          
  else 'NA'                                                                                              
  ENd as 'Mode Of Payment'                                                                          
  ,BM.BookingCurrency as 'Booking Currency'                                                                                                                 
  ,BM.BookingRate  as  'Booking Amount'                                                                                                   
 ,BM.providerName  as 'Supplier'                                                            
 ,BM.SupplierCurrency as 'Supplier Currency'                                          
 ,BM.SupplierRate as 'Supplier Gross'                                                      
                                                                                                                                                        
 ,BM.cityName as 'City'                                                                                                                                
 ,BM.CountryCode as 'Country'    --add on 01-9-23                                                                       
                                                                                                                  
 ,BA.ActivityName as 'Service Name'                                                                      
 ,PD.totalPax  as 'No_of_Passengers'                                                                                                             
  ,'NA' as 'No_of_Nights'                                                                                                                                  
  ,'NA' as 'No_of_Rooms'                                                                                                                                  
 ,'NA' as 'Total Room Nights'                                                                               
 ,BM.ProviderConfirmationNumber as 'Supplier Confirmation'                                                                                                                                         
 ,isnull(PD.PancardNo,'NA') as 'PAN Card No'                                            
                                                                   
 ,PD.Nationality as 'Nationality'                                                                  
 ,PD.PassportNumber  as 'Passport No'                                                             
                                                              
  FROM                                                                           
            ss.SS_BookingMaster BM WITH (NOLOCK)                                                                                                                    
            LEFT JOIN SS.SS_BookedActivities BA WITH (NOLOCK) ON BM.BookingId = BA.BookingId                                                      
   JOIN SS.SS_PaxDetails PD WITH (NOLOCK) ON BM.BookingId = PD.BookingId  and pd.LeadPax=1                                                                                                           
            LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BM.AgentID = BR.FKUserID                                                                                         
            LEFT JOIN mUser MU WITH (NOLOCK) ON BM.MainAgentID = MU.ID                                                                   
   join AgentLogin AGL WITH (NOLOCK) on BM.AgentID=AGL.UserID                                                                                                          
   JOIN mCommon  mcn WITH (NOLOCK) on mcn.ID=AGL.userTypeID                                                                    
            LEFT JOIN Hotel_Status_Master HM WITH (NOLOCK) ON BM.BookingStatus = HM.Status                                                                                                
            LEFT JOIN Ss.SS_Status_History SH WITH (NOLOCK) ON BM.BookingId = SH.BookingId                                                                           
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
        --ORDER BY                                                                             
        --    BM.creationDate DESC         
           
    END                                
         
          
 if(exists(select value from dbo.fn_split(@SearchByProduct,',') where value='Cruise')) --Cruise                                                                        
                                       
 BEGIN         
        
 insert into #rptAllProduct                                                    
                              
 select      
 distinct
        
--ROW_NUMBER() OVER(ORDER BY (bk.BookingId) DESC) as SrNo,        
  bk.BookingReferenceid                                                                                     
  ,'Cruise' as 'Service'                                                                                                                                        
  ,mc.[Value] as 'UserType'                                                                   
  ,'NA' as 'Customer Type'                                                                                              
  ,mb.Name as Branch                                                                                          
  ,b2b.AgencyName as 'Agency  User'                                                                                                                                                      
  ,bk.AgentId as 'Agenct ID'                                                                                                      
  ,(select  pax.FirstName +' '+ pax.LastName from Cruise.BookedPaxDetails pax where pax.FkBookingId=bk.Id and pax.IsPrimaryPax=1)                              
  as 'Leader Guest Name'                                                                                                                                                      
  ,FORMAT(case isdate( bk.CreatedOn)when 1 then bk.CreatedOn else '' end , 'dd-MMM-yyyy HH:mm') as  [Booking Date]                                                                                                     
 ,format(case isdate(BI.StartDate) when 1 then  BI.StartDate else '' end ,'dd-MMM-yyyy ') as 'Service start_date'                                                                                         
 ,format(case isdate(BI.EndDate) when 1 then BI.EndDate else '' end ,'dd-MMM-yyyy') as 'Service end_date'                                                                                                                                                     
  
 ,'NA' as 'Cancellation Deadline'                               
                                                                                                                                   
   ,(case when bk.Status=0 then 'NA' when bk.Status=1 then 'Confirmed'  when bk.Status=2 then 'Hold' when bk.Status=3 then 'PendingTicket'  when bk.Status=4 then 'Cancel'                              
 when bk.Status=5 then 'Close'  when bk.Status=6 then 'Cancellation'  when bk.Status=7 then 'ToBeReschedule'                               
 when bk.Status=8 then 'Reschedule'  when bk.Status=9 then 'HoldCancel'  when bk.Status=10 then 'BookingTrack'                               
 when bk.Status=11 then 'OnlineCancellation'  when bk.Status=12 then 'TicketingAccess'  when bk.Status=13 then 'ConsoleInserted' when bk.Status=14 then 'Failed' END)                               
 as 'Booking Status',                                                                                   
 CASE                               
  WHEN bk.PaymentMode = 1                              
     THEN 'Hold'                              
    WHEN bk.PaymentMode = 2                              
     THEN 'Credit Limit'                              
    WHEN bk.PaymentMode = 3                              
     THEN 'Make Payment'                              
    WHEN bk.PaymentMode = 4                              
     THEN 'Self Balance'                              
    END as 'Mode Of Payment'                                                                          
 ,'INR' as 'Booking Currency'                                                                                                                    
 ,bk.AmountPaidbyAgent  as  'Booking Amount'                                                     
 ,bk.Supplier  as 'Supplier'                                                          
 ,'INR' as 'Supplier Currency'                                                                                                                                               
 ,'NA' as 'Supplier Gross'                                                                                                                            
 ,BI.DestinationPort as 'City'                                                                                                                                
 ,al.Country as 'Country'                                                                         
,'Cruise' as 'Service Name'                
 ,(select Count(pax.FkBookingId) from Cruise.BookedPaxDetails pax where pax.FkBookingId=bk.Id) as 'No.of Passenger'                              
  ,BI.Nights as 'No_of_Nights'                                                                                                                                  
  ,pax.RoomNo as 'No_of_Rooms'                                                                                                                                  
 ,(Cast( isnull (pax.RoomNo, 1 )as int) * Cast( isnull (pax.RoomNo, 1 )as int)) as 'Total Room Nights'                                                          
 ,'NA' as  'Supplier Confirmation'                                                                                                                               
 ,pax.Pan as 'PAN Card No'                                                                                                                          
 ,pax.Country  as 'Nationality'                                   
 ,pax.PassportNumber  as 'Passport No'                                                                                                                        
                                                          
 from Cruise.Bookings bk WITH (NOLOCK)                                
  LEFT JOIN AgentLogin al WITH (NOLOCK) ON bk.AgentId = al.UserID                                
  left join mCommon mc WITH (NOLOCK) on al.UserTypeID=mc.ID                              
  LEFT join cruise.BookedPaxDetails pax WITH (NOLOCK) on bk.id=pax.FkBookingId                              
  LEFT join cruise.BookedItineraries BI WITH (NOLOCK) on bk.Id=BI.FkBookingId                               
  LEFT JOIN B2BRegistration b2b WITH (NOLOCK) ON bk.AgentId = b2b.FKUserID                                
  LEFT JOIN mUser usr WITH (NOLOCK) ON bk.RiyaUserId = usr.ID                               
  LEFT JOIN  mBranch MB WITH (NOLOCK) on MB.BranchCode=b2b.BranchCode                                
                                                                                                            
 where                                                                                                                                                       
                             
mb.Division  like 'RTT%' and mb.BranchCode like 'BR%'                                                                                                                                  
                                                                                                                                                                                            
   and bk.IsActive=1                                                                  
   and bk.AgentId is not null                                                                                    
   and  bk.PaymentMode  is not null                                                                                                                                                                                                             
   --and HB.BookingReference is not null                                                                             
                                                  
            AND                                                                                  
            (                                                                            
                (@SearchByDate = '1' AND CAST(BI.StartDate AS DATE) BETWEEN @StartDate AND @EndDate)                                                                      
                OR                                                                      
                (@SearchByDate = '0' AND CAST(BI.StartDate AS DATE) BETWEEN @StartDate AND @EndDate)                                                                      
     OR                                                                            
                (@StartDate IS NULL AND @EndDate IS NULL)                                      
            )               
                                                                                 
 --order by bk.BookingId desc                               
 End                              
          
          
 if(exists(select value from dbo.fn_split(@SearchByProduct,',') where value='Rail')) --Rail                             
    declare @paxcount int  
 set @paxcount=(select top 1 count(fk_ItemId) as count from Rail.PaxDetails pax   
left join Rail.Bookings bk  on bk.id=pax.fk_ItemId where bk.Id=fk_ItemId  
group by fk_ItemId)  
  BEGIN         
          
         
 insert into #rptAllProduct                            
                            
 select           
 distinct
--ROW_NUMBER() OVER(ORDER BY (bk.creationDate) DESC) as SrNo,        
         
  bk.RiyaPnr                                                                                    
  ,'Eurail' as 'Service'                                                    
  ,mc.[Value] as 'UserType'                   
  ,case when bk.AgentId!=0 then  'Internal'                                                                                                     
  when bk.AgentId=0 then  'Agent'                 
  end as 'Customer Type'                                                                                                                                                                                               
  ,mybranch.Name  as Branch                                                                                                        
  ,'' as 'Agency  User'                                           
  ,bki.AgentId as 'Agenct ID'                                                             
  ,(select top 1 pax.FirstName +' '+ pax.LastName from Rail.PaxDetails pax where pax.fk_ItemId=bki.Id)  as 'Leader Guest Name'                                                                                                                                 
 
    
      
        
          
 ,FORMAT(case isdate( bk.creationDate )when 1 then bk.creationDate  else '' end , 'dd-MMM-yyyy HH:mm') as  [Booking Date]                                                                                                     
 ,format(case isdate(bk.creationDate) when 1 then  bk.creationDate else '' end ,'dd-MMM-yyyy ') as 'Service start_date'                                                                                                                                     
                              
 ,format(case isdate(bk.expirationDate) when 1 then bk.expirationDate else '' end ,'dd-MMM-yyyy') as 'Service end_date'                                                                                                                               
   ,'NA' as 'Cancellation Deadline'                                                                                                                                    
   ,CASE                               
 WHEN bk.bookingStatus = 'INVOICED'                              
 THEN 'CONFIRMED'                              
 WHEN bk.bookingStatus = 'PREBOOKED'                         
 THEN 'ON-HOLD'                              
 WHEN bk.bookingStatus = 'MODIFIED'                              
 THEN 'MODIFIED'                            
 WHEN bk.bookingStatus = 'CREATED'                            
 THEN 'CREATED'                            
 END as 'Booking Status'                                                                                   
 ,bk.PaymentMode as 'Mode Of Payment'                                                                          
 ,bk.Currency  as 'Booking Currency'                                   
 ,bk.AmountPaidbyAgent  as  'Booking Amount'                                                     
 ,bki.SupplierId  as 'Supplier'                                                          
 ,bki.Currency as 'Supplier Currency'                                                                                                                                           
 ,Isnull(bki.SupplierToInrFinal,0) as 'Supplier Gross'                                                                                                                            
   ,ISNULL(bki.Origin +'=>' + bki.Destination,0) as 'City'                             
 --,b2b.AddrCity as 'City'                                              
 ,Case  when CHARINDEX(',',bki.Country) >0  THEN right(bki.Country, charindex(',', reverse(bki.Country)) - 1)                                                                                                                                                 
   
                     
 else bki.Country end  as 'Country'                                                                          
,'EURAIL' as 'Service Name'                                                                                                                                
 ,Isnull(@paxcount,0) as 'No.of Passenger'                                                                                                                          
  ,'NA'as 'No_of_Nights'                                                                                                                                  
  ,'NA' as 'No_of_Rooms'                                                                                                                                  
 ,'NA' as 'Total Room Nights'                                                                                                                          
 ,'NA'as  'Supplier Confirmation'                                                                                                                                                      
 ,isnull( pax.Pan,'NA') as 'PAN Card No'                                                                                            
                                                                   
 ,pax.countryOfResidence as 'Nationality'                                                                  
 ,pax.PassportNumber  as 'Passport No'                                                                                                                        
                                                          
  FROM Rail.Bookings bk WITH (NOLOCK)                               
  inner JOIN AgentLogin al WITH (NOLOCK) ON bk.AgentId = al.UserID                                
  inner JOIN B2BRegistration b2b WITH (NOLOCK) ON bk.AgentId = b2b.FKUserID                                
  inner JOIN RAIL.BookingItems bki WITH (NOLOCK) ON bk.Id=bki.fk_bookingId                                
  inner join Rail.PaxDetails pax WITH (NOLOCK) on pax.fk_ItemId = bki.Id and pax.leadTraveler=1                           
  left join mCommon mc WITH (NOLOCK) on al.UserTypeID=mc.ID                            
  Left join PaymentGatewayMode PGM WITH (NOLOCK) on bk.PaymentMode = PGM.Mode                                 
  LEFT JOIN mUser usr WITH (NOLOCK) ON bk.RiyaUserId = usr.ID                             
 -- LEFT JOIN  mBranch MB WITH (NOLOCK) on MB.BranchCode=b2b.BranchCode
   left join(                                                                                                    
 select mbr.BranchCode,MAx(name) as 'Name',Max(Division) as 'Division',max(id) as maxid from mBranch as mbr  group by BranchCode                                                                                         
                                              
                                               
) as  mybranch                                                                                                    
 on b2b.BranchCode=mybranch.BranchCode  
 where                                                                                                                            
                                                                                                     
--MB.Division  like 'RTT%' and b2b.BranchCode like 'BR%'                                                                                                                                  
                                                                       
   --and 
   al.IsActive=1     
   and pax.leadTraveler=1 
   and bk.RiyaUserId is not null                                                                                    
   and bk.PaymentMode is not null                                                                                                                                                                                                             
                                                            
                                                                                     
            AND                                                                        
            (     (@SearchByDate = '1' AND CAST(bk.creationDate AS DATE) BETWEEN @StartDate AND @EndDate)                                       
                               
    OR                             
                (@SearchByDate = '0' AND CAST(bk.expirationDate AS DATE) BETWEEN @StartDate AND @EndDate)                                                                      
     OR                                                                            
                (@StartDate IS NULL AND @EndDate IS NULL)                                      
            )                                                                            
                                                                                 
 --order by bk.creationDate desc         
         
         
 end                           
         
         
 if(exists(select value from dbo.fn_split(@SearchByProduct,',') where value='Flights'))--Flights                                                          
 BEGIN                                                                            
                                       
insert into #rptAllProduct                                                
  select           
  distinct
--ROW_NUMBER() OVER(ORDER BY (B.pkId) DESC) as SrNo,        
  B.riyaPNR AS  'BookingReference'                            
  ,'Air' as 'Service'                                                                                                                                                       
  ,mc.Value as 'UserType'                                                                   
  ,case when B.AgentID!=0 then  'Internal'  --add column on 13-04-23                                                                                                   
  when B.AgentID=0 then  'Agent'                                
  end as 'Customer Type'                                                                                                                                                   
  ,MB.Name as Branch                                                                                                        
  ,BR.AgencyName as 'Agency  User'                                                                                                                                                      
  ,Br.Icast as 'Agenct ID'                                                                                                      
  ,(pb.paxFName+' '+pb.paxLName)  as 'Leader Guest Name'                                                                                                                                                      
  ,FORMAT(case isdate( B.inserteddate)when 1 then B.inserteddate else '' end , 'dd-MMM-yyyy HH:mm') as  [Booking Date]                                                                                                     
 ,format(case isdate(B.inserteddate) when 1 then  B.depDate else '' end ,'dd-MMM-yyyy ') as 'Service start_date'                            
 ,format(case isdate(B.inserteddate) when 1 then B.arrivalDate else '' end ,'dd-MMM-yyyy') as 'Service end_date'                            
   ,'NA' as 'Cancellation Deadline'                      
   ,(CASE WHEN (b.BookingStatus=1 or b.BookingStatus=6) THEN 'Confirmed' WHEN B.BookingStatus=2 THEN 'Hold' WHEN B.BookingStatus=3 THEN 'Pending'                            
    WHEN (B.BookingStatus=9 or B.BookingStatus=4) THEN 'Cancelled' WHEN B.BookingStatus=0 THEN 'Failed' WHEN B.BookingStatus=5 THEN 'Close'                            
    WHEN B.BookingStatus=10 THEN 'Manual Booking' WHEN B.BookingStatus=8 THEN 'Reschedule PNR' WHEN B.BookingStatus=12 THEN 'In-Process' END) AS  'Booking Status'                                                         
 ,payment_mode as 'Mode Of Payment'                                                                          
 ,B.AgentCurrency as 'Booking Currency'                                                                                                       
 ,pm.amount  as  'Booking Amount'                                                      
 ,B.VendorName  as 'Supplier'                                                          
 ,'N/A' as 'Supplier Currency'                                                                                                   
 ,'N/A' as 'Supplier Gross'                                                                                                                            
                                                                                                                                                        
 ,BR.AddrCity as 'City'                                                                                                                                
 ,b.Country  as 'Country'    --add on 01-9-23                                                                       
,'Air' as 'Service Name'                                                      
 ,(select Count(pax.pid)as count from tblPassengerBookDetails pax with(NOLOCK) where pax.fkBookMaster=B.pkId)  as 'No_of_Passengers'                                                                                                                          
                        
   
      
       
  ,'N/A' as 'No_of_Nights'                                                                                                                                  
  ,'N/A' as 'No_of_Rooms'                                                                        
 ,'N/A' as 'Total Room Nights'                            
 ,'N/A' as  'Supplier Confirmation'                                                                                                                                                      
 ,(Select top 1 ISNULL(PanCardno,'') from mAttrributesDetails Where fkPassengerid=pb.pid) as 'PAN Card No'                                                                   
 ,pb.Nationality as 'Nationality'                                                                  
 ,pb.passportNum  as 'Passport No'                                                                                                         
             
            
  from tblBookMaster B WITH(NOLOCK)                                                                                                                                                                                                                        
   INNER JOIN tblPassengerBookDetails pb WITH(NOLOCK) on pb.fkBookMaster=b.pkId AND pb.totalFare>0                             
   LEFT JOIN B2BRegistration BR WITH(NOLOCK)ON CAST(BR.FKUserID AS VARCHAR(50))=b.AgentID                             
   LEFT JOIN agentLogin al WITH(NOLOCK) ON CAST(al.UserID AS VARCHAR(50))=b.AgentID                             
 INNER JOIN Paymentmaster pm WITH(NOLOCK) ON pm.order_id=b.orderId                             
   --left join mUser MU on MU.ID=B.MainAgentID                             
   LEFT JOIN  mBranch MB WITH(NOLOCK) on MB.BranchCode=BR.BranchCode                                                                                                        
   left join mCommon mc WITH(NOLOCK) on mc.ID=al.UserTypeID                                                                                                                 
                                                                     
 where                                                      
                                                                                                                                                                                                         
MB.Division  like 'RTT%' and BR.BranchCode like 'BR%'                                                                                                                                  
AND B.AgentID!='B2C'                                         
   and al.IsActive=1                                                                                                                                                                      
and B.AgentID is not null                                                                                    
   and pm.payment_mode is not null                                                                                                                                                                                                             
   --and HB.BookingReference is not null                                                                             
                                                                                     
            AND                                                                                  
      (                                                                            
             (@SearchByDate = '1' AND CAST(B.inserteddate AS DATE) BETWEEN @StartDate AND @EndDate)                                                                      
                OR                                                                      
                (@SearchByDate = '0' AND CAST(B.inserteddate AS DATE) BETWEEN @StartDate AND @EndDate)                                                                      
     OR                                                                            
                (@StartDate IS NULL AND @EndDate IS NULL)                                      
            )                                                                            
                                                                                 
 --order by B.pkId desc         
         
 END                             
                            
select distinct   * from #rptAllProduct order by service, Booking_Date desc                                               
drop table #rptAllProduct                                       
                                       
END   