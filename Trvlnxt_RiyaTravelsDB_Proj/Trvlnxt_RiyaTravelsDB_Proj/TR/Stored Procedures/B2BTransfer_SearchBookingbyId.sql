CREATE PROCEDURE [TR].[B2BTransfer_SearchBookingbyId]                   
    @Id INT = 0                  
AS                  
BEGIN                  
    DECLARE @IsModify INT = (SELECT IsModify FROM TR.TR_BookingMaster WHERE BookingId =@Id);                  
                  
    IF (@IsModify = 1)                  
    BEGIN                  
        -- Logic for @IsModify = 1                  
        SELECT                   
            -- Booking Information                  
            BM.BookingId,                  
            BM.BookingRefId,                  
            BM.BookingStatus AS 'BookingStatus',
			 FORMAT(CAST(BM.creationDate AS datetime),'dd MMM yyyy hh:mm tt') as BookingDate,
			 FORMAT(CAST(QPD.TripStartDate AS datetime),'dd MMM yyyy hh:mm tt') as StartDate,
			FORMAT(CAST(QPD.CancellationDeadline AS datetime),'dd MMM yyyy hh:mm tt') as DeadlineDate,
          
            QPD.PickupLocation,                  
            QPD.DropOffLocation,                  
            CASE                  
                WHEN BM.RoundTrip = 1 THEN 'YES'                  
                WHEN BM.RoundTrip = 0 THEN 'NO'                  
                ELSE CAST(BM.RoundTrip AS VARCHAR)                  
            END AS RoundTrip,                  
            ISNULL(BM.CityName, 'NA') AS 'CityName',                  
            ISNULL(BM.CountryCode, 'NA') AS 'CountryName',                  
            BM.AgentID AS 'TRAgentId',                  
            ISNULL('', 'NA') AS 'OBTCNumber',                  
            -- Vehicle and Customer Details                  
            BA.PricingPackageType as CategoryVehicleType,                   
            QPD.CarName,                  
            BA.CarCode,                  
            QPD.EstimatedTime,                  
            QPD.FlightCode,                  
            QPD.FlightArrivalTime,                  
            QPD.Remark,                  
                  
            -- CancellationPolicy                  
            COALESCE(QPD.CancellationPolicyText, '') AS 'CancellationPolicy',                  
                  
            -- Pax Details                  
            ISNULL(PD.Titel, '') + ' ' + ISNULL(PD.Name, '') + ' ' + ISNULL(PD.Surname, '') AS 'LeadPaxName',                  
            --ISNULL(PD.Titel, '') + ' ' + ISNULL(PD.Name, '') + ' ' + ISNULL(PD.Surname, '') AS 'TravelerName',                  
   QPD.PassengerName AS 'TravelerName',                  
            ISNULL(QPD.Nationality, 'NA') AS 'PaxNationality',                  
            CAST(QPD.TotalPax AS VARCHAR) + ' (' +                  
            CAST(BM.TotalAdult AS VARCHAR) + ' ADULT, ' +                  
            CAST(BM.TotalChildren AS VARCHAR) + ' CHILD)' AS PaxCount,                  
            QPD.TotalPax,                  
            QPD.Email AS PassengerEmail,                  
            QPD.Contact AS PassengerPhone,                  
            ISNULL(QPD.PassportNumber, 'NA') AS 'PassportNumber',                  
            ISNULL(QPD.PancardNo, 'NA') AS 'PancardNo',                  
            ISNULL(QPD.PanCardName, 'NA') AS 'PanCardName',                  
            ISNULL(QPD.Luggage, '0') AS 'Luggage',                  
                  
            ---Rate Information--                            
   Concat(BM.BookingCurrency,' ',BM.AmountBeforePgCommission,'(',BM.SupplierCurrency,' ','-->',BM.BookingCurrency,'=',ISnull(BM.ROEValue,1),')',' ','Markup:',BM.Markup,'%') as 'AgentRate',                                                      
    '--' as ServiceTax,                           
 case when BM.PaymentMode=3 then 'Yes' else 'No' end as 'PaymentGathway',                           
 CASE                                     
    WHEN BM.PaymentMode = 3 THEN                                     
        CONCAT(BM.BookingCurrency, ' ', CONVERT(varchar, BM.BookingRate))                                    
    ELSE                                     
        'NA'                             
END AS PaymentGathwayCharges,                          
                          
 ---Supplier--                           
 BM.providerName,                           
  case when BM.ProviderConfirmationNumber is null then 'NA' when BM.ProviderConfirmationNumber='' then 'NA'                                     
 else BM.ProviderConfirmationNumber end as ProviderConfirmationNumber,              
  ISnull(BM.CorrelationId,'NA') AS Cid,              
  Concat(BM.SupplierCurrency,' ',BM.SupplierRate) as SupplierRate,                          
                          
                          
  --Cancel popup                      
  coalesce(BM.CancellationPolicyText,'') as 'CancellationPolicyC',             
  BM.AmountAfterPgCommision as AMT,          
   (Isnull(BM.BookingCurrency,'NA') + ' '+  CONVERT(varchar(200),BM.BookingRate)) as 'BookingAmount',                          
     BM.SupplierCanxCharges as 'SupplierCancellationChrgs',                          
  isnull(BM.RoeValue,1) as 'ROE',                          
  BM.AgentCanxCharges as 'AgentCancellationChrge',                          
  BM.CancellationRemark as 'CancellationRemark',                          
                          
  --Cancellation Rate          
  BM.PostCancellationCharges as 'postCancellationCharges',                          
   BM.SupplierCanxCharges as 'SupplierCancellationChrgsC',                          
   BM.SupplierCanxAgentChrge as 'SupplierCancAgntChrge',                          
    BM.AgentCanxCharges as 'AgentCancellationChrgeC',                          
     BM.CancellationRemark as 'CancellationRemarkC',                              
  --offline cancel reversal                          
  BM.PaymentMode as 'B2BpaymentmodeOC',                          
  BM.BookingRate as 'BookingRate',                          
  MC.ID as 'Agentcountry',                          
  BM.MainAgentID as 'MainAgentidOC',                          
  BM.BookingStatus as 'BookingStatusOC',                          
   BM.AgentID as 'TRAgentIdOC',                          
                          
     -------- Voucher---                                          
 ISNULL(BM.VoucherUrl,'NA')  as 'VaiterVoucher',                                          
ISNULL (SH.FkStatusId,0) as 'FKCurrentStatus',                                 
BM.PaymentMode as 'B2Bpaymentmode',                                
BM.MainAgentID as 'MainAgentid',                           
                          
                          
------PrintVoucher-------                          
                          
 MU.FullName as AgentName,                                                      
 BR.AgencyName +'-'+BR.Icast  as 'AgencyName',                                                  
 PD.Titel,                                                                    
 PD.Name,                            
 PD.Surname,                            
 BM.CorrelationId,                                                                                      
ISNULL( PD.Surname,'NA') AS   Surname,                                                
 BM.TripStartDate as ServiceInDate,                                                           
 BM.TripEndDate as ServiceOutDate,                                                                                                                
 ISnull(BM.CityName,'NA') as Destination,                          
 Isnull(BR.BranchCode,'NA') as 'BranchName' ,                                    
Isnull(BR.AddrContactNo,'NA') as AgentcntNumber,                                                  
 BM.BookingCurrency,                          
  isnull('','-') as 'TourLanguage',                                                  
   isnull(BM.ROEValue,1) as  ROEValue,                                                  
  ISNULL('','NA') as agentRefName,      
  ISnull('','NA') as 'SalesMgr' ,                                        
   'NA' as 'Consultant'                           
        FROM                  
            TR.TR_BookingMaster BM                  
         LEFT JOIN TR.TR_BookedCars BA ON BM.BookingId = BA.BookingId                  
            LEFT JOIN TR.TR_PaxDetails PD ON BM.BookingId = PD.BookingId                  
   LEFT JOIN TR.TR_BookingMasterQuickModify QPD ON BM.BookingId = QPD.FkBookingId and QPD.IsActive=1                  
            LEFT JOIN B2BRegistration BR ON BM.AgentID = BR.FKUserID                  
            LEFT JOIN Hotel_CountryMaster CM ON PD.Nationality = CM.CountryCode                  
            LEFT JOIN mUser MU ON BM.MainAgentID = MU.ID                  
            LEFT JOIN Hotel_Status_Master HM ON BM.BookingStatus = HM.Status                  
            LEFT JOIN TR.TR_Status_History SH ON BM.BookingId = SH.BookingId                  
            LEFT JOIN SS.mcountry MC ON BM.BookingCurrency = MC.CurrencyCode                  
        WHERE                  
            (BM.BookingId = @Id OR @Id = 0)                  
            AND SH.IsActive = 1;                  
    END                  
    ELSE                  
    BEGIN            
        SELECT                   
            -- Booking Information                  
            BM.BookingId,                  
            BM.BookingRefId,                  
            BM.BookingStatus AS 'BookingStatus',
			 FORMAT(CAST(BM.creationDate AS datetime),'dd MMM yyyy hh:mm tt') as BookingDate,
			 FORMAT(CAST(BM.TripStartDate AS datetime),'dd MMM yyyy hh:mm tt') as StartDate,
			FORMAT(CAST(BM.CancellationDeadline AS datetime),'dd MMM yyyy hh:mm tt') as DeadlineDate,
       
            BM.PickupLocation,                  
            BM.DropOffLocation,                  
            CASE                  
                WHEN BM.RoundTrip = 1 THEN 'YES'                  
                WHEN BM.RoundTrip = 0 THEN 'NO'                  
                ELSE CAST(BM.RoundTrip AS VARCHAR)                  
            END AS RoundTrip,                  
            ISNULL(BM.CityName, 'NA') AS 'CityName',                  
            ISNULL(BM.CountryCode, 'NA') AS 'CountryName',                  
            BM.AgentID AS 'TRAgentId',                  
            ISNULL('', 'NA') AS 'OBTCNumber',                  
            -- Vehicle and Customer Details                  
   BA.PricingPackageType as CategoryVehicleType,                
            BA.CarName,                  
            BA.CarCode,                  
            BM.EstimatedTime,                  
            BM.FlightCode,                  
            BM.FlightArrivalTime,                  
            BM.Remark,                  
            -- CancellationPolicy                  
            COALESCE(BM.CancellationPolicyText, '') AS 'CancellationPolicy',                  
            -- Pax Details                  
         ISNULL(PD.Titel, '') + ' ' + ISNULL(PD.Name, '') + ' ' + ISNULL(PD.Surname, '') AS 'LeadPaxName',                  
            ISNULL(PD.Titel, '') + ' ' + ISNULL(PD.Name, '') + ' ' + ISNULL(PD.Surname, '') AS 'TravelerName',                  
            ISNULL(PD.Nationality, 'NA') AS 'PaxNationality',                  
            CAST(PD.TotalPax AS VARCHAR) + ' (' +                  
            CAST(BM.TotalAdult AS VARCHAR) + ' ADULT, ' +                  
            CAST(BM.TotalChildren AS VARCHAR) + ' CHILD)' AS PaxCount,                  
            PD.TotalPax,                  
            PD.Email AS PassengerEmail,                  
            PD.Contact AS PassengerPhone,                  
            ISNULL(PD.PassportNumber, 'NA') AS 'PassportNumber',                  
            ISNULL(PD.PancardNo, 'NA') AS 'PancardNo',                  
            ISNULL(PD.PanCardName, 'NA') AS 'PanCardName',                  
            ISNULL(BA.Luggage, '0') AS 'Luggage',                  
            ---Rate Information--                            
   Concat(BM.BookingCurrency,' ',BM.AmountBeforePgCommission,'(',BM.SupplierCurrency,' ','-->',BM.BookingCurrency,'=',ISnull(BM.ROEValue,1),')',' ','Markup:',BM.Markup,'%') as 'AgentRate',                                                      
    '--' as ServiceTax,                           
 case when BM.PaymentMode=3 then 'Yes' else 'No' end as 'PaymentGathway',                           
 CASE           
    WHEN BM.PaymentMode = 3 THEN                                     
        CONCAT(BM.BookingCurrency, ' ', CONVERT(varchar, BM.BookingRate))                                    
    ELSE                                     
        'NA'                               
END AS PaymentGathwayCharges,                          
                          
 ---Supplier--                           
 BM.providerName,                           
  case when BM.ProviderConfirmationNumber is null then 'NA' when BM.ProviderConfirmationNumber='' then 'NA'                                     
 else BM.ProviderConfirmationNumber end as ProviderConfirmationNumber,                
 ISnull(BM.CorrelationId,'NA') AS Cid,                  
  Concat(BM.SupplierCurrency,' ',BM.SupplierRate) as SupplierRate,                          
                          
                          
  --Cancel popup                          
  coalesce(BM.CancellationPolicyText,'') as 'CancellationPolicyC',          
  BM.AmountAfterPgCommision as AMT,          
   (Isnull(BM.BookingCurrency,'NA') + ' '+  CONVERT(varchar(200),BM.BookingRate)) as 'BookingAmount',                          
     BM.SupplierCanxCharges as 'SupplierCancellationChrgs',                          
  isnull(BM.RoeValue,1) as 'ROE',                          
  BM.AgentCanxCharges as 'AgentCancellationChrge',            
  BM.CancellationRemark as 'CancellationRemark',                          
                          
  --Cancellation Rate                
  BM.PostCancellationCharges as 'postCancellationCharges',                          
   BM.SupplierCanxCharges as 'SupplierCancellationChrgsC',                          
   BM.SupplierCanxAgentChrge as 'SupplierCancAgntChrge',                          
    BM.AgentCanxCharges as 'AgentCancellationChrgeC',                          
     BM.CancellationRemark as 'CancellationRemarkC',                       
  --offline cancel reversal                          
  BM.PaymentMode as 'B2BpaymentmodeOC',                          
  BM.BookingRate as 'BookingRate',                          
  MC.ID as 'Agentcountry',                          
  BM.MainAgentID as 'MainAgentidOC',                          
  BM.BookingStatus as 'BookingStatusOC',                          
   BM.AgentID as 'TRAgentIdOC',                          
                          
     -------- Voucher---                                          
 ISNULL(BM.VoucherUrl,'NA')  as 'VaiterVoucher',                                          
ISNULL (SH.FkStatusId,0) as 'FKCurrentStatus',                                 
BM.PaymentMode as 'B2Bpaymentmode',                                
BM.MainAgentID as 'MainAgentid',                           
                          
                          
------PrintVoucher-------                          
                          
 MU.FullName as AgentName,                                                      
 BR.AgencyName +'-'+BR.Icast  as 'AgencyName',                                                  
 PD.Titel,                                          
 PD.Name,                            
 PD.Surname,                            
 BM.CorrelationId,                                                                                      
ISNULL( PD.Surname,'NA') AS   Surname,                                                
 BM.TripStartDate as ServiceInDate,                                                           
 BM.TripEndDate as ServiceOutDate,                                                                                             
 ISnull(BM.CityName,'NA') as Destination,                          
 Isnull(BR.BranchCode,'NA') as 'BranchName' ,                                    
Isnull(BR.AddrContactNo,'NA') as AgentcntNumber,                                                  
 BM.BookingCurrency,                          
   isnull('','-') as 'TourLanguage',                                                  
   isnull(BM.ROEValue,1) as  ROEValue,                                                  
  ISNULL('','NA') as agentRefName,                                                  
  ISnull('','NA') as 'SalesMgr' ,                                        
   'NA' as 'Consultant'                           
        FROM                  
            TR.TR_BookingMaster BM                  
            LEFT JOIN TR.TR_BookedCars BA ON BM.BookingId = BA.BookingId                  
            LEFT JOIN TR.TR_PaxDetails PD ON BM.BookingId = PD.BookingId                  
            LEFT JOIN B2BRegistration BR ON BM.AgentID = BR.FKUserID                  
            LEFT JOIN Hotel_CountryMaster CM ON PD.Nationality = CM.CountryCode                  
            LEFT JOIN mUser MU ON BM.MainAgentID = MU.ID                  
            LEFT JOIN Hotel_Status_Master HM ON BM.BookingStatus = HM.Status                  
            LEFT JOIN TR.TR_Status_History SH ON BM.BookingId = SH.BookingId                  
            LEFT JOIN SS.mcountry MC ON BM.BookingCurrency = MC.CurrencyCode                  
        WHERE                  
            (BM.BookingId = @Id OR @Id = 0)                  
            AND SH.IsActive = 1;                  
    END                  
END 