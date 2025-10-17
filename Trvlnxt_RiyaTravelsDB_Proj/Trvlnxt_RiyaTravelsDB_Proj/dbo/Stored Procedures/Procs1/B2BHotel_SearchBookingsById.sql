 -- exec [B2BHotel_SearchBookingsById]   224211                                                                        
                              
                                                                                                    
CREATE PROCEDURE [dbo].[B2BHotel_SearchBookingsById]                                                                                                                                                                             
 -- Add the parameters for the stored procedure here                                                                                                                                                                            
                                                                                                                                                                             
 @Id int=0                                                                                                                                                                            
                                                                                                                                                                            
AS                                                                                                                                                                            
BEGIN                                
                              
 declare @MarkupAmount numeric(18,2)=0;                                                                                                                                                                            
 set @MarkupAmount =(select MarkupAmount from Hotel_BookMaster where pkId=@Id)                                                                                                                                                                                 
  
                                                                                                                                      
  declare @SuppRate numeric(18,2)=0;                                                                                                                                    
  set @SuppRate=( select SUM(SupplierRateInBookingCurrency) from Hotel_Room_master where book_fk_id=@Id)                                                                                                                   
                                                                                                                
      DECLARE @Policy NVARCHAR(MAX)                                                                                                               
   SET @Policy = (REPLACE(REPLACE((select CancellationPolicy from Hotel_BookMaster where pkId=@Id), '<p>', ''), '</p>', ''))                                                                                                              
                                                                                                                  
       Declare @Paxcount int                                                                                                    
   set @Paxcount=(select Count(room_fk_id) from Hotel_Pax_master where book_fk_id=@Id)                                                                                                    
                                                                                                    
   declare @SupplierBookingPolicy nvarchar(max)                                        
   -- set @SupplierBookingPolicy =(select top 1  PolicyText From hotel.HotelCancelBookPolicies  WITH(NOLOCK) where FKBookingId=@Id and GroupName in ('Booking Policies') order by 1 desc)                                   
     Set @SupplierBookingPolicy=(select STRING_AGG (PolicyText,',') as PolicyText    From hotel.HotelCancelBookPolicies  WITH(NOLOCK) where FKBookingId=@Id and GroupName='Booking Policies')       
  DECLARE @supplierDisclaimer NVARCHAR(MAX);        
        
SELECT @supplierDisclaimer = STRING_AGG('Room ' + CAST(RoomNo AS VARCHAR) + ' : ' + RoomText, CHAR(13) + CHAR(10))        
FROM (        
    SELECT RoomNo,         
           STRING_AGG(Text, ', ') AS RoomText        
    FROM Hotel.AdditionalCharges WITH (NOLOCK)        
    WHERE FkBookId = @Id        
    GROUP BY RoomNo        
) AS RoomDetails;        
        
   declare @PaymentMode varchar(20)=0;                                                                          
    set @PaymentMode =(select top 1 ModeOfPayment from B2BMakepaymentCommission WITH(NOLOCK) where FkBookId=@Id order by CreateDate desc)                               
                           
  DECLARE @PANCARD VARCHAR(200)=NULL              
SET @PANCARD =(SELECT TOP 1 PANCARD FROM Hotel_Pax_master WHERE book_fk_id=@Id AND IsLeadPax=1)              
   
   DECLARE @GivenTime DATETIME = (select CancellationDeadLine from Hotel_BookMaster where pkid=@Id) ;  
DECLARE @Offset VARCHAR(6) =(select HotelOffsetGMT from Hotel_BookMaster where pkid=@Id) ; -- Timezone of the given time (UTC or IST)  
  
DECLARE @IST_Time varchar(200)=Null  
set @IST_Time = (SELECT FORMAT(  
    CASE  
        -- If already IST (either marked as +05:30 or +00:00 in your system)  
        WHEN @Offset = '+05:30' OR @Offset = '+00:00'  
            THEN @GivenTime  
        -- If positive offset (e.g., +09:00 for Japan)  
        WHEN LEFT(@Offset, 1) = '+'  
            THEN DATEADD(  
                    MINUTE,  
                    330 - ((CAST(SUBSTRING(@Offset, 2, 2) AS INT) * 60)  
                          + CAST(SUBSTRING(@Offset, 5, 2) AS INT)),  
                    @GivenTime  
                 )  
        -- If negative offset (e.g., -04:00 for New York)  
        WHEN LEFT(@Offset, 1) = '-'  
            THEN DATEADD(  
                    MINUTE,  
                    330 + ((CAST(SUBSTRING(@Offset, 2, 2) AS INT) * 60)  
                          + CAST(SUBSTRING(@Offset, 5, 2) AS INT)),  
                    @GivenTime  
                 )  
        ELSE @GivenTime  
    END,  
    'dd MMM yyyy hh:mm tt'  
) AS ISTDate);  
  
Declare @UTC_Time varchar(200)=null  
Set @UTC_Time = (SELECT FORMAT(  
        CASE  
            WHEN LEFT(ISNULL(@Offset, '+00:00'), 1) = '+'  
                 THEN DATEADD(HOUR, -CAST(SUBSTRING(@Offset, 2, 2) AS INT), @GivenTime)  
            WHEN LEFT(ISNULL(@Offset, '+00:00'), 1) = '-'  
                 THEN DATEADD(HOUR, CAST(SUBSTRING(@Offset, 2, 2) AS INT), @GivenTime)  
            ELSE @GivenTime  
        END,  
        'dd MMM yyyy hh:mm tt'  
     ) AS JapanUTCConversion); 
  
  
select                               
 DISTINCT                              
                               
                             
 HP.Salutation+' '+ HP.FirstName +' '+ HP.LastName+ ' ' +case PassengerType when 'Child' then '('+age+' Yrs)' else ''end   as PassengerName,                                   
  HP.Salutation  as 'title',                                     
    HP.FirstName  as 'fname',                                                            
  HP.LastName  as 'Lname',            
  -- CASE WHEN HD.book_fk_id=@ID and HD.book_fk_id=HP.book_fk_id  THEN (HD.TITLE+' '+ HD.FName + ' ' + HD.LName+ ' ' + case hp.PassengerType when 'Child' then '('+ hp.age + ' Yrs)' else ''end) ELSE                    
  --(HP.Salutation+' '+ HP.FirstName +' '+ HP.LastName+ ' ' +case PassengerType when 'Child' then '('+age+' Yrs)' else ''end) END  as PassengerName,  --modify                  
                    
  -- CASE WHEN HD.book_fk_id=HP.book_fk_id  THEN HD.TITLE ELSE HP.Salutation END as 'title',              --modify                                                                                                               
  -- CASE WHEN HD.book_fk_id=HP.book_fk_id  THEN HD.FName ELSE HP.FirstName END as 'fname',    --modify                             
  -- CASE WHEN HD.book_fk_id=HP.book_fk_id  THEN HD.LName ELSE HP.LastName END as 'Lname',    --modify               --isnull(@Paxcount,0) as PaxCount ,                                                                                             
  Isnull(Hp.Age,'0') as Age ,                                                                                         
 Isnull(Hp.PassengerType,'NA') as PassengerType,                                                                                       
   HB.BookingReference as book_Id,                                                                                                                                                    
   Hb.DisplayDiscountRate as 'SuppRoomRate',                                                                                     
  Coalesce ( @SuppRate,0) as  'BookAmt',                                                                                                       
   hb.B2BPaymentMode,                                                                                                                                  
   HB.HotelConfNumber as HotelConfirmation,                                                                                  
   SM.Status as CurrentStatus,                                                                                                                        
   '' as VoucherID,                                                                                                                                
   CONVERT(varchar, HB.inserteddate,106) as BookingDate,                                                                                                                                                                                  
   --convert (varchar ,convert(datetime,HB.CancellationDeadLine), 106) as DeadlineDate,    
    FORMAT(TRY_CAST(HB.CancellationDeadLine AS datetime2), 'dd MMM yyyy hh:mm tt') AS DeadlineDate,    

    Isnull(@UTC_Time,FORMAT((TRY_CAST(HB.CancellationDeadLine AS datetime2) AT TIME ZONE 'UTC'), 'dd MMM yyyy hh:mm tt')) AS UTC_DeadlineDateTime,    
    -- IST Date + Time    
   ISnull(@IST_Time,FORMAT((TRY_CAST(HB.CancellationDeadLine AS datetime2) AT TIME ZONE 'UTC' AT TIME ZONE 'India Standard Time'), 'dd MMM yyyy hh:mm tt')) AS IST_DeadlineDateTime,    
       
   '' as BranchName,                                                                                     
   '' as ReservationID,                                                                                                                             
  CASE WHEN B2BPaymentMode = 3 THEN 'Yes - '+ @PaymentMode + ' / ' + case when HB.PGStatus='Failure' then HB.PGStatus + '<span style="color:red; font-weight:bold">(!)</span>' Else HB.PGStatus end  ELSE 'No' END as PaymentGateway,                          
 
    
       
        
          
            
  case when B2BPaymentMode = 3 and HB.PGStatus='Failure' then HMR.FailureMsg  else '' end as  PaymentGatewayFailure,                                      
   CASE WHEN B2BPaymentMode = 5 THEN 'Yes' ELSE 'No' END as PayHotel,                            
                                                                                        
   --CONVERT(varchar,HB.CheckInDate,106) as CheckInDate,                                                    
      convert(varchar,HB.CheckInDate,106)+' '+ case when HB.ServiceTimeModified=1 then HB.ModifiedCheckInTime else HB.CheckInTime end as CheckInDate                                                                            
                                                  
   --CONVERT(varchar,HB.CheckOutDate,106) as CheckOutDate,                                                   
      ,convert(varchar,HB.CheckOutDate,106)+' '+case when HB.ServiceTimeModified=1 then HB.ModifiedCheckOutTime else  HB.CheckOutTime end as CheckOutDate                                                    
                                                
   ,case when HB.ServiceTimeModified=1 then ISNULL(CONVERT(varchar(8),  HB.ModifiedCheckInTime) ,'NA')   when HB.CheckInTime='NA' then HB.CheckInTime else  ISNULL(CONVERT(varchar(8), HB.CheckInTime), 'NA') end AS CheckInTime      --added by Aman 8march24 
  
    
      
        
         
             
              
               
                                      
    ,case when HB.ServiceTimeModified=1 then ISNULL(CONVERT(varchar(8), HB.ModifiedCheckOutTime), 'NA')   when HB.CheckOutTime='NA' then HB.CheckOutTime else ISNULL(CONVERT(varchar(8),  HB.CheckOutTime),  'NA') end AS CheckOutTime                         
  
    
      
        
          
            
              
                
                  
                    
                     
   ,Isnull(HB.ServiceTimeVerified,0) as ServiceTimeVerified   --added by Aman 8march24                                              
   ,Isnull(HB.ServiceTimeModified,0) as ServiceTimeModified --added by Aman 8march24                                              
                                              
   ,isnull(HB.SelectedNights,'0') as NoofNights,                                                                          
   HB.ClosedRemark as Remarks,                                                                                         
   HB.HotelName as HotelName,                                                   
   ISNULL (HB.HotelPhone,'02522-Null Case') as HotelPhoneNo,                                                                                                                                                               
   HB.HotelAddress1 as HotelAddress,                                                                          
   HB.HotelAddress2 as HotelAddress2,                                                                                                              
   @Policy AS PlainTextPolicy,                               
                                 
   HB.cityName as HotelCity,                                                                                                                                                               
   HB.CountryName as HotelCountry,                                                                                              
   HB.pkId,                                                                  
   HB.book_Id as BId,                                               
   HB.CancellationPolicy,                                                           
   HB.ContractComment as ContractComment,                                                                                                                                             
   HB.SpecialRemark,                                                            
   HB.CancellationCharge,                                                                                              
   HB.RiyaAgentID as RiyaUserID,                                                                                                                          
   ISNULL( HB.request,'')as request,                                                                                                       
   HB.BookingReference,                                                                             
   ------> Passanger Details                                                                                                            
    RM.RoomTypeDescription  as RoomType,                                                                                                         
   RM.room_no as 'NumberofRoom',                                                                               
   HB.TotalRooms as RoomNo,                                                                                                             
   RM.NumberOfRoom as 'NoRooms',                                                                                                 
    RM.RoomMealBasis  as 'Meal',                                                                                                                                                                 
                           
                                  
   HB.Nationalty as Nationality,                 -- earlier coolumn    NM.Nationality as Nationality,                                                         
   HB.PassengerPhone,                                                                                                                 
   HB.PassengerEmail,                                                                                              
   HB.TotalAdults,                                                                                         
   ISNULL(HB.TotalChildren,0)as TotalChildren,                                                           
   HB.TotalRooms,                                                                                                                                              
   hp.room_fk_id as RoomId,                                                                       
  cast(cast(DisplayDiscountRate as float) / cast(TotalRooms as float)as float)  as 'TotalPrice',                                                           
  HB.SupplierRate as 'SupplierRate',                                                    
 Concat(HB.CurrencyCode,' ',Isnull(HB.TotalServiceCharges,0)) as 'TotalServiceCharge',                                                                            
HB.AgentCommission as 'AgentCommission',                                                                                                                                  
  RM.SupplierCommission as 'RMSupplierCommission',                                                                      
                                                                  
  --add Supplier Rate % 09-03-2022                                                                                                                                       
  HB.SupplierRate as 'Supplier Rate',                                                                 
                                                                                                                                    
  HB.AgentRate as 'AgentRate',   --add column on 9-5-23                                                                          
  HCC.EarningAmount as 'EarningAmt',  --add column on 9-5-23                                                                                                                           
  cast(cast(expected_prize as float) / cast(TotalRooms as float)as float)  as 'TotalPriceSupplier',    -- (as discussed with faizan sir commented on 09-03-23)                                                                                                
  
    
      
         
          
                   
                 
                             
                                                
  case                                                                                                                                                       
      when @MarkupAmount is null THEN cast((cast(cast(DisplayDiscountRate as float) - cast(expected_prize as float)as decimal(18,3)) * 100)/DisplayDiscountRate  as decimal(18,3))                                                                             
  
    
      
        
          
            
              
                             
                                                                            
   when @MarkupAmount is not null THEN cast((cast(HB.MarkupAmount as float) * 100)/DisplayDiscountRate  as decimal(18,3)) else 0                                                                                                                     
  End AS markup,                                                                              
  CASE                                                                                                                                                            
    WHEN @MarkupAmount  is null   and HB.BookingReference like '%RT%'THEN (cast(cast(DisplayDiscountRate as float) - cast(expected_prize as float)as decimal(18,3)))                                                                                           
  
    
  
        
          
            
              
                        
                             
WHEN @MarkupAmount  is null   and HB.BookingReference like '%TNH%'THEN (Cast(isnull(HB.TotalRoomAmount,0) + ISNULL(HB.HotelTaxes,0) + isnull(MP.TotalCommission,0) as float)  - cast(ISNULL(HB.expected_prize,0) - isnull(HCC.SupplierCommission,0) as float)  
  
    
      
        
          
            
              
                
                  
                    
                         
                                                                                                     
)                                                                                                                  
  --(cast(cast(DisplayDiscountRate as float) - cast(expected_prize as float)as decimal(18,3)))                                                                                  
    WHEN @MarkupAmount is not null THEN HB.MarkupAmount                                                                                                                                                                            
   ELSE 0                                                                                                                          
  END AS ApproxRevenue,                                    
                                                                                                                            
  isnull(HB.DisplayDiscountRate,'0')-(isnull(HB.AgentRate,0)-isnull(HCC.SupplierCommission,0)) as 'Revenue',   --add column on 9-5-23                                                                                                                    
                                                 
   -------> Agent Information                                                                                           
   BR.AgencyName+'-'+BR.Icast as AgentName,                                                                                                                          
   HB.AgentRemark,  --remove agentref 3-3-23                                               
   MU.FullName +'-'+ MU.UserName as ConsultantName,              
   MU.EmailID as 'SalesManager',    --remove empty and add EmailId 08-03-2023                                                                                                                                                                    
   ------> Confirmation details                                                                                                                             
   ISNULL(HB.ConfirmationNumber, '0' ) as ConfirmationNumber,                                                                                             
   HB.HotelStaffName,                                                                                                                                                                                
   HB.SpecialRemark AS ConfirmationRemark ,                                                                                                                                      
   FORMAT (HB.ConfirmationDate, 'MM/dd/yyyy hh:mm tt') as ConfirmationDate,                                                                                                                                                                                
   ------> Voucher number                                            
   HB.VoucherNumber,                                                                                                             
   HB.CurrencyCode as 'Currency',                                                                                                                          
                                                                                                                                               
   HB.AgentId,                        
   HB.AgentRefNo as 'AgentRefNo',  -- add alias agentref 3-3-23                                                                                                                                                                               
   HB.TotalCharges as Amount                                                                                                                                         
   ,HB.SupplierName                             
   ,HB.SupplierReferenceNo as SupplierReferenceNo                                                                              
   ,HP.FirstName+' '+HP.LastName as TravellerName                                                                                                                                                                          
   ,HB.AdminNote                          
   ,HP.id as 'PaxId'                                                                                                     
   ,HLM.latitude                                                                                                                                     
   ,HLM.longitude                                                                                               
   --added by akash for voucher formate                                                                                                                            
   ,HP.PassengerType                                                                                          
                                                                                           
   --Rooms Information                                                                  
   ,HP.MealBasis                                                                                                                                                             
   ,HP.RoomNo                                                                                        
   ,RM.NumberOfRoom,                                       
   RM.RoomTypeDescription as RoomTypeDescription                                 
   ,RM.Room_Id as RM_FkroomdID                                                                                       
   ,RM.room_no as indivisualroomNo                                                                                        
   ,RM.RoomMealBasis                                                                                         
   ,SH.FkStatusId                                                                                                              
   ,isnull(HP.RoomType,RM.RoomTypeDescription) as 'RType'                                                                                                               
   --,isnull(MP.TotalCommission,0) as 'PgCommission'                                                                                                                                         
   ,case when HB.B2BPaymentMode=3 then Cast(Isnull(MP.TotalCommission,0) as Varchar) +' ' +'('+Cast (ISnull (MP.ConvenienFeeInPercent,0.00) as varchar)+'%)' else '0' end as 'PgCommission'                                            
                                                                                                                                 
   --new added                                                                                                                                                                
   ,isnull(HB.OBTCNo,'') as OBTCNo                                                                                                       
   ,mc.Value AS 'UserType',                                                                             
 Isnull(@supplierDisclaimer,'') as  SupplierDisclaimer                                                                           
  --  , (ac.Text+' '+'-'+' '+ ac.Description) as SupplierDisclaimer    --02-03-23                                                                             
 --,HP.Pancard as 'Pancard'    --add 08-03-2023              
   ,@PANCARD AS 'Pancard'              
   ,HP.PassportNum as 'Passport'   --add 08-03-2023                                                                                                                                                           
   ,HB.SupplierCurrencyCode as 'SupplierCurrency'   --add SupplierCurrencyCode 09-03-2023                                                                                                                                       
   --,HB.CurrencyCode as 'HBCurrencyCode'                                
   ,HB.HotelTotalGross as 'HotelTotalGross'                                                                                                          
                                                                                                                                               
   ,isnull(hb.ROEValue,0) as 'ROEvalue'     --add isnull  12-03-2023                                                                                                
   ,HB.orderId as 'OrderId'   ----add OrderId 24-03-2023                                                                  
   --,iSNULL(hb.TotalRoomAmount,0) AS 'AgentTotalGross'                                  
   ,iSNULL(hb.expected_prize,'0') AS 'AgentTotalGross'                                                                                    
   ,HCC.EarningAmount as 'EarningAmount'  ---> add by aman for payathotelfunctionalitiues  27/06/2023                                                                                                                                                     
   ,isnull(HCC.EarningAmount,0) + ISNULL(HCC.TDSDeductedAmount,0) as  'AgentShare'        --add TDSDeductedAmount in agentshare on 9-5-23                                                            
   ,cast(ISNULL(HB.HotelTDS,0) as varchar) +'( '+ cast( isnull(HCC.TDS,0) as varchar)+'%)'  as 'TDS'                                                                  
 --  ,Cast(isnull(HB.TotalRoomAmount,0) + ISNULL(HB.HotelTaxes,0) + isnull(MP.TotalCommission,0) as float) as 'TotalNetPayble'                                          
  ,isnull(HB.DisplayDiscountRate,'0') as 'TotalNetPayble'                                  
  , 'INR' as 'InrCurrency'                                                                                                              
                                                                             
 --,isnull(HCC.Commission,0) as 'AgentShare(%)'                                                                                                                                           
                                                                                        
 ,Concat( Hb.MarkupCurrency,' ', cast(ISNULL(HB.MarkupAmount,0) as varchar),' ', +'( '+ cast( isnull(HCC.Commission,0) as varchar)+'%)')   as 'AgentShare(%)'                                                                                                 
  
    
      
        
          
                     
                                                                                                                                          
   ,ISNULL(HB.MarkupAmount, 0) as 'MarkupAmount'                                                                                                                  
   ,ISNULL(HB.expected_prize,'0') as 'SupplierTotalGross'                                                                                                                                                   
   ,isnull(HCC.SupplierCommission,0)  as 'SupplierCommission'  --> changed after supplier commison not properly displayed  earlier was hb.agentcommisson                                                                                                       
  
    
      
       
          
   --,cast(isnull(Hcc.RiyaCommission,0) - isnull(HCC.EarningAmount,0) as int) as 'RiyaShare'      --commented on 4-5-23                                                                                                                                        
  
    
      
        
          
   ,case when isnull(HCC.SupplierCommission,0)>=0 then                                                                                                                                            
   cast(isnull(Hcc.RiyaCommission,0) - (isnull(HCC.EarningAmount,0) +ISNULL(HCC.TDSDeductedAmount,0)) as int)                                                                                                        
         when isnull(HCC.SupplierCommission,0)<=0 then isnull(HB.MarkupAmount,0) end as 'RiyaShare'  --add column on 4-5-23 &  --add TDSDeductedAmount in Riyashare on 9-5-23                                                                            
                                                                                                                               
   --,ISNULL(HB.ROEValue, 0) as 'Roe'                                                                                                                                          
   ,ISNULL(HB.FinalROE,HB.ROEValue) as 'Roe'                                                                                                                                        
   ,CAST(ISNULL(CAST(HB.expected_prize AS float), 0) - ISNULL(CAST(HCC.SupplierCommission AS float), 0) AS float) AS SupplierNet        -- earlier line      cast(ISNULL(HB.expected_prize,'0') - isnull(HCC.SupplierCommission,0) as float) as 'SupplierNet'  
  
    
      
        
          
            
                          
                                                      
   ,Cast(100 - Isnull(HCC.Commission,0) as float ) as 'RiyaShare(%)'                                                                 
   ,ISNULL(HB.SupplierCurrencyCode,'NA') as 'SupplierCurrencyCode'                                                                                                                                                              
   --,ISNULL(MP.ModeOfPayment,'NA' ) as PgMode                               
   ,case when HB.B2BPaymentMode=3 then ISNULL(@PaymentMode,'NA' ) else 'NA' end  as PgMode                              
   --,isnull(HCC.GSTAmount,0) as 'GSTAmount'                                                             
    ,ISnull(Concat(HB.CurrencyCode ,' ',HCC.GST),0) as 'GSTAmount'        
                                                                                                                                         
   ,isnull(HB.Post_addCancellationCharges,'0') as 'CancelledCharges'      --add column on 21-04-23                                                                                                                                                          
   ,isnull(HB.Post_addCancellationRemarks,'NA') as 'CancelledRemarks'      --add column on 21-04-23                                                                                                             
   ,isnull(HB.searchApiId,'NA') as 'SuppItenaryId' --add column on 03-05-23                                                                                                                                                  
                                                                                                                                                 
   ,case when isnull(HCC.RiyaCommission,0)>0 then                                                                                                  
   isnull(HB.AgentRate,0)-isnull(HCC.SupplierCommission,0)             --+ cast(isnull(Hcc.RiyaCommission,0) - (isnull(HCC.EarningAmount,0)+ ISNULL(HCC.TDSDeductedAmount,0)) as int)    --as dsicussed with faizan sir commented on 9-5-23                    
  
   
       
       
           
                   
                              
                                              
   when isnull(HB.MarkupAmount,0)>0 then                                                                                              
     ISNULL( HB.DisplayDiscountRate,0)-isnull(HCC.SupplierCommission,0) + cast(isnull(Hcc.RiyaCommission,0) - isnull(HCC.EarningAmount,0) as int) end as 'SupplierTotal'--add column on 4-5-23  & add TDSDeductedAmount on 9-5-23                             
   
    
      
        
          
            
                        
                                                                                                                                                        
 , case when (HB.SupplierBookingPaymentDate IS NULL) then 'NO' when (HB.SupplierBookingPaymentDate='') THEN 'NO' else 'Yes' end as BNPLStatus ,   --- ADDED ON 24-04-23                                                                                        
  
    
      
        
          
                                                                                                   
  case When (HB.SupplierBookingPaymentDate IS NULL) then 'NA' when (HB.SupplierBookingPaymentDate='') THEN 'NA' else HB.SupplierBookingPaymentDate end as SupplierBookingPaymentDate,  --- ADDED ON 24-04-23                                                   
  
    
      
        
          
            
                            
  case when (HB.SupplierBookingUrl IS NULL)  then 'NA' when (HB.SupplierBookingUrl='') then 'NA' else HB.SupplierBookingUrl END AS SupplierBookingUrl,  --- ADDED ON 24-04-23                                                                                  
  
    
      
        
          
                                          
                                                                                                                            
  case when                                                                                                                        
  Exists(select (BookingRef)                                                                     
from tblAgentBalance where BookingRef = HB.orderId) then 'Yes' else 'No' end as PayAtHotelbutton,                                                         
-----Cancellation Rate--                                                                               
isnull(HB.Post_addCancellationRemarks,'NA') as 'Post_addCancellationRemarks',                             
isnull(HB.post_addCancellationCharges,'0') as 'post_addCancellationCharges',                                                 
isnull(HB.SupplierCancellationCharges,0) as 'SupplierCancellationCharges',                                                                             
isnull(HB.agentCancellationCharges,0) as 'agentCancellationCharges',                                                            
isnull(HCC.[Actual Commission Received],0) as 'ActualCmsnRcvd',     --add column 9-8-23                                                                                               
isnull(HB.SINRCommissionAmount,0) as 'SinrCmsnAmount' ,     --add column 10-8-23                                                                      
         -- for offline cancel ---                                                                                
 isnull(HB.DisplayDiscountRate,'0' ) as  BookingAmount,                                                                                
Hb.B2BPaymentMode as BookingPaymentmode,                         
ISNULL( MCC.ID,0)  as 'Agentcountry',                                                                            
 HB.MainAgentID as 'MainAgentID',                                                                        
                                                     
 ---- Pan card required trvlnxt--                      
case when (HB.PanCardURL IS NULL)  then 'NA' when (HB.PanCardURL='') then 'NA' else HB.PanCardURL END AS CorporateTrvaller_PanURL   --- ADDED ON 24-04-23                                                                            
   ,HB.PaymentRemark,            
 HB.PaymentStatus,                                        
 HB.DispositionStatus as DespositionStatus,                                        
 HB.ResolutionStatus as ResolutionStatus,                                    
                                     
  --Pancard Verification--                                          
 case when HP.IsLeadPax=1 then isnull(HP.PanCardName,'NA') else 'NA' end as PanCardName,                                          
 case when HP.IsLeadPax=1 then (HP.Salutation+' '+HP.FirstName +' '+ HP.LastName+ ' ') end as LeadpaxName,                                          
  case when HP.IsLeadPax=1 then ISnull(HP.Pancard,'NA') else '' end as Pancard,                                      
                              
  HP.IsLeadPax,                            
 -- voucher policies --                                  
                                     
 ISNULL(@SupplierBookingPolicy,' ') as 'SupplierBookingPolicy',          
 '' as SupplierDisclaimer,          
  isnull(HCN.HotelConfirmationNumber,'NA') as AutoHCN            
   --,HDR.RoomType                  
,CASE WHEN HD.book_fk_id=RM.book_fk_id THEN HD.RoomType ELSE RM.RoomTypeDescription END as RoomType --modify                       
,CASE WHEN HD.book_fk_id=RM.book_fk_id THEN HD.RoomMealBasis ELSE RM.RoomMealBasis END as Meal  --modify              
                              
  from Hotel_BookMaster HB                                                                                                                                                                      
  left join mUser MU on HB.MainAgentID=MU.ID                                                                                                                                                  
  LEFT join Hotel_Pax_master HP on HB.pkId=HP.book_fk_id                                                                                                        
  --LEFT join tblAgentBalance TBL on HB.orderId = TBL.BookingRef                                                                                                                        
  --LEFT join Hotel_Room_master HRM on HB.pkId=HRM.book_fk_id                                                                                                                                                                        
  LEFT join Hotel_Room_master RM on HP.room_fk_id=RM.Room_Id                                                                                                                                                                                  
  left join Hotel_Nationality_Master NM on HP.Nationality=NM.code                                           
  left join Hotel_CountryMaster HC on HP.Nationality=HC.CountryCode                                                                                                                                                         
  left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId                                                                       
  left join Hotel_Status_Master SM on SH.FkStatusId=SM.Id                                                                                                                                                           
  left join AgentLogin AL on HB.RiyaAgentID=AL.UserID                                                                                                   
  left join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID                                
  left join Hotel_List_Master HLM on HB.LocalHotelId=HLM.Hotel_id                                                                                                              
  left join B2BMakepaymentCommission MP on HB.pkId=MP.FkBookId and ProductType='Hotel'                              
                                                                   
  LEFT JOIN mCommon mc ON MC.ID=AL.UserTypeID AND Category='UserType'                               
 -- LEFt join hotel.AdditionalCharges ac on ac.FkBookId=HB.pkId    --02-03-23    commented becoz duplicate in gridview of supplierdisclaimer column                                                                                                           
  
    
      
                                           
  left join B2BHotel_Commission HCC on HB.pkId=HCC.Fk_BookId                                          
    left join mCountry MCC on HB.BookingCountry = MCC.CountryCode                                                                          
    left join HotelMakePaymentResponse HMR WITH(NOLOCK) ON HB.BookingReference = SUBSTRING(HMR.OrderId, CHARINDEX('-', HMR.OrderId) + 1, LEN(HMR.OrderId))                          
 LEFT Join Hotel.HotelAutoHCN HCN with(nolock) on HB.BookingReference= HCN.BookingReference  and HCN.Isactive=1                         
 LEFT JOIN Hotel.HotelBookingModifyDetails HD ON HB.pkId= HD.book_fk_id and RM.Room_Id=HD.room_fk_id and HP.ID=HD.pax_fk_id AND HD.IsActive=1                    
                          
                                                                                                                                                        
   where                                                                                                                                                                             
  (HB.pkId = @Id or @Id=0)                                                                                                                                                  
   and SH.IsActive=1                                                                                 
    and RM.IsActiveRoom=1                     
                     
 order by HP.room_fk_id asc, HP.IsLeadPax desc,HP.ID asc                                                    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[B2BHotel_SearchBookingsById] TO [rt_read]
    AS [dbo];

