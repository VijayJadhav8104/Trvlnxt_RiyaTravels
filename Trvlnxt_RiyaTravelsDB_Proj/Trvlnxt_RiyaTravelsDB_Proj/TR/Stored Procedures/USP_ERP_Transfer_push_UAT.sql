      
                                                                                                   
CREATE PROCEDURE [TR].[USP_ERP_Transfer_push_UAT] --@Action = 'TransferBooking'             
 @Action varchar(50)=null,                                                                                                    
 @empcode varchar(50) =null,                                                                                                    
 @ERPResponceID varchar(500) = null,                                                                                                    
@CanERPResponceID varchar(500) = null,                                                                                                    
@PKID int = null                                                                                                    
AS                                                                                                            
BEGIN                                                    
                                                  
 IF @Action = 'TransferBooking'                                                                                                      
             
   BEGIN                                                                                                    
            
select  trm.BookingId 'MoDocumentNo',BookingRefId 'TicketNoPolicyNo', br.AgencyName            
,trm.creationDate 'inserteddate',tsh.CreateDate 'PostingDate',    
trm.CountryCode,

  al.BookingCountry 'BookingCountry', 
CASE                                                                                                     
  WHEN ', ' + trm.CityName + ',' LIKE '%, india,%'                                                                                                    
   THEN 'Car-Dom'                                                                                                    
  ELSE 'Car-INT'                                                                                                    
  END    
  AS 'ProductType',            
   'E-Ticket' AS 'TicketType'  ,            
   TripStartDate,isnull(TripEndDate,TripStartDate) 'TripEndDate'            
 ,SUBSTRING(trm.providerName, 1, 10) AS 'SupplierCode'               
 ,BR.CustomerCOde 'ShipToCustomer'             
 ,trm.CountryCode            
  ,CASE                                                                                         
  --WHEN trm.CountryCode = 'AE'                                                                                                    
  WHEN al.BookingCountry = 'AE'                                                                                                    
   THEN 'VEND00137'                                                                                      
  WHEN al.BookingCountry = 'SA'                                                                                                            
   THEN 'VEND00024'                                   
    --NEw for US CA                                    
  WHEN al.BookingCountry = 'US'                                                      
   THEN 'UVEND01021'                                                
   WHEN al.BookingCountry = 'CA'                                                                                    
   THEN 'CVEND00242'                                            
  --ELSE 'VEND000151'                                                                           
  else 'BOMVEND002137' end as 'PayToVendor',            
CASE                                                                                                     
  WHEN al.BookingCountry = 'AE'                                                                                                    
   THEN 'CC1012000'                                                                                      
  WHEN al.BookingCountry = 'US'                                                                                           
   THEN 'CC1010000'                                                              
  WHEN al.BookingCountry = 'CA'                                                         
  THEN 'CC1011000'                     
  WHEN al.BookingCountry = 'GB'                                                          
   THEN 'CC1013000'                                  
  WHEN al.BookingCountry = 'SA'                                                                            
   THEN 'CC1013000'                                                             
  ELSE 'CC1001000'                                                                                                    
  END AS 'DivisionCode'                                                                                      
 ,isnull(MU.EmployeeNo,'') as 'EmployeeCode'                                                                                                    
,trm.AgentCurrencyCode AS 'SalesCurrencyCode'            
,trm.AgentCurrencyCode AS 'PurchCurrencyCode'            
,trm.AmountAfterPgCommision 'BaseAmount'            
 ,0 'TaxAmount'                                                                                                 
 ,trm.Markup 'MarkupOnBaseFare' --need clarity                                                                                                   
 ,0 'VendorMarkup'                                                                                 
 ,'' 'CardNumber'            
 ,'' 'CardType'            
 ,0 'ExtraCharges'                                                      
 ,0 'ExtraBedCharges'             
 ,trm.ProviderConfirmationNumber 'riyaPNR'            
 ,trm.PaymentMode ,CASE                                                                         
  WHEN trm.PaymentMode = 3                                                             
   THEN '1'                                                                                                    
  ELSE '0'                                                                       
  END AS 'PaymentMode_UATP'                                                                                                    
 ,BR.LocationCode 'CustomerLocationCode'               
 ,'Adult' 'PassangerType'            
 ,px.Titel 'LeaderTitle'            
 ,px.Name 'PaxName'            
 ,BR.BranchCode -- Ask Gary                                                                                                      
             
 ,trm.BookingId 'book_Id'            
 , cars.CarId 'CarId'            
 ,AgentId            
 ,px.Contact 'PassengerPhone'            
 ,px.Email 'PassengerEmail'            
 ,'TRVLNXT' AS 'BookingType'                                                              
 ,'' AS 'NOOfRooms'                                                                                                    
 ,'' AS 'RoomNights'                                                                                                    
 ,Replace(cast(cars.CarDesc as varchar), '&', 'and') AS'CarDesc'-- 'RoomType'                                                                                                    
 ,trm.CityName AS 'TrvlingCity' --'HotelCity'                                                                                                    
 ,Replace(cars.CarName, '&', 'and') AS 'CarName'                                                                                                    
 , trm.TotalAdult AS 'NOOfAdults'                                                                        
 ,trm.TotalChildren as 'NOOfChildren'            
 ,'' 'NOOfInfant'                                                                                                    
 ,trm.BookingRate 'RatePerNight-No'            
 ,'' 'ChildRate'                                                
 ,'' 'ExtraBed'             
from TR.TR_BookingMaster trm left Join b2bregistration br on br.FKUserID =trm.AgentID            
left join TR.TR_BookedCars cars on cars.BookingId=trm.BookingId            
left join TR.TR_PaxDetails px on px.BookingId=trm.BookingId            
left join ( SELECT BookingId                                
  ,max(id) AS max_id                                                                 
  ,FkStatusId,CreateDate  ,IsActive                                                                                                  
 FROM tr.TR_Status_History AS cc                                                                                                     
 WHERE cc.FKStatusId = 4 and IsActive=1                                                           
 GROUP BY BookingId             
  ,FkStatusId,CreateDate,IsActive ) tsh on tsh.BookingId=trm.BookingId  and tsh.IsActive=1            
LEFT JOIN Muser MU ON MU.ID = trm.MainAgentID                                                          
left join agentLogin al on al.UserID=trm.AgentID            
            
where             
tsh.FkStatusId=4 and             
al.UserTypeId in (2,3) and            
trm.PaymentMode=2 and             
--cast(tsh.CreateDate as date)> cast((GETDATE() - 60) as date)         
--AND    cast(tsh.CreateDate as date)>= cast('2025-05-30' as date)        
--AND  trm.Transfer_ERPPushResponseID IS NULL                                                                                                    
-- AND (                                                                                                    
--  trm.Transfer_ERPPushStatus = 0                                                                  
--  OR  trm.Transfer_ERPPushStatus IS NULL            
--  )   and      
  BookingRefId in('TNC0000078','TNC0000077'  )    
order by 1 desc            
            
            
 END                                 
                                                                                                    
 IF @Action = 'TransferCancellation'                                                                                                        
   BEGIN                                           
 select  top 100 trm.BookingId 'MoDocumentNo',BookingRefId 'TicketNoPolicyNo', br.AgencyName            
,al.UserTypeId,trm.creationDate 'inserteddate',tsh.CreateDate 'PostingDate',br.country 'BookingCountry',            
CASE                                                                                                     
  WHEN ', ' + trm.CityName + ',' LIKE '%, india,%'                                                                                                    
   THEN 'CAR-Dom'                                                                                                    
  ELSE 'CAR-INT'                                                                                                    
  END AS 'ProductType',            
   'E-Ticket' AS 'TicketType'  ,            
   TripStartDate,isnull(TripEndDate,TripStartDate) 'TripEndDate'            
 ,SUBSTRING(trm.providerName, 1, 10) AS 'SupplierCode'               
 ,BR.CustomerCOde 'ShipToCustomer'             
 ,trm.CountryCode            
  ,CASE                                                                                         
  WHEN al.BookingCountry = 'AE'                                                                                                    
   THEN 'VEND00137'                                                                                      
  WHEN al.BookingCountry= 'SA'                                                                                                            
   THEN 'VEND00024'                                   
    --NEw for US CA                                    
  WHEN al.BookingCountry = 'US'                                                      
   THEN 'UVEND01021'                                                
   WHEN al.BookingCountry= 'CA'                                                                                    
   THEN 'CVEND00242'                                            
  --ELSE 'VEND000151'                                                                           
  else 'BOMVEND002137' end as 'PayToVendor',            
CASE                                                                                   
  WHEN al.BookingCountry = 'AE'                                                                                                    
   THEN 'CC1012000'                                                                                      
  WHEN al.BookingCountry = 'US'                                                                                           
   THEN 'CC1010000'                                                              
   WHEN al.BookingCountry = 'CA'                                                      
   THEN 'CC1011000'                                                                                                
  WHEN al.BookingCountry = 'GB'                                                                                                            
   THEN 'CC1013000'                                                                                               
  WHEN al.BookingCountry = 'SA'                                      
   THEN 'CC1013000'                                                             
  ELSE 'CC1001000'                                                                                                    
  END AS 'DivisionCode'                                                               
 ,isnull(MU.EmployeeNo,'') as 'EmployeeCode'                                                                                                    
,trm.AgentCurrencyCode AS 'SalesCurrencyCode'            
,trm.AgentCurrencyCode AS 'PurchCurrencyCode'            
,trm.AmountAfterPgCommision 'BaseAmount'            
 ,trm.ProviderConfirmationNumber 'riyaPNR'            
          
 ,0 'TaxAmount'                                                                                                 
 ,trm.Markup 'MarkupOnBaseFare' --need clarity                                                                                                   
 ,0 'VendorMarkup'                                                                                 
 ,'' 'PM.CardNumber' -- need clatity            
 ,'' 'PM.CardType'            
 ,0 'ExtraCharges'                                                      
 ,0 'ExtraBedCharges'                             
 ,trm.PaymentMode ,CASE                                                                         
  WHEN trm.PaymentMode = 3                                                             
   THEN '1'                                                                                                    
  ELSE '0'                                                                       
  END AS 'PaymentMode_UATP'                                                                                                    
 ,BR.LocationCode 'CustomerLocationCode'                                                                               
 ,trm.BookingId 'book_Id'            
 , cars.CarId 'CarId'            
 ,AgentId            
 ,'Adult' 'PassangerType'            
           
 ,px.Contact 'PassengerPhone'            
 ,px.Email 'PassengerEmail'            
 ,'TRVLNXT' AS 'BookingType'                                                              
,px.Titel 'LeaderTitle'            
 ,px.Name 'PaxName'            
 ,BR.BranchCode -- Ask Gary                                                                                                      
             
 ,trm.BookingId 'book_Id'            
 , cars.CarId 'CarId'            
 ,AgentId            
 ,'' AS 'NOOfRooms'                                                                                                    
 ,'' AS 'RoomNights'                                                                                                    
 ,Replace(cast(cars.CarDesc as varchar), '&', 'and') AS'CarDesc'-- 'RoomType'                                                                                                    
 ,trm.CityName AS 'TrvlingCity' --'HotelCity'                                       
 ,Replace(cars.CarName, '&', 'and') AS 'CarName'                                                                                                    
 , trm.TotalAdult AS 'NOOfAdults'                                                                        
 ,trm.TotalChildren as 'NOOfChildren'     
 ,'' 'NOOfInfant'                                                                                                    
 ,trm.BookingRate 'RatePerNight-No'            
 ,'' 'ChildRate'                                                
 ,'' 'ExtraBed'            
 ,trm.PostCancellationCharges 'MarkupOnCancellation',                    
  0 'PenaltyAmount',0 'SerFeeOnCancellation', 0 'MgmtFeeOnCancellation',                                                                                                    
  case when tsh.FkStatusId=7 then  tsh.CreateDate else  '' End as 'CancelDate'          
from TR.TR_BookingMaster trm left Join b2bregistration br on br.FKUserID =trm.AgentID            
left join TR.TR_BookedCars cars on cars.BookingId=trm.BookingId            
left join TR.TR_PaxDetails px on px.BookingId=trm.BookingId            
left join TR.TR_Status_History tsh on tsh.BookingId=trm.BookingId  and tsh.IsActive=1            
LEFT JOIN Muser MU ON MU.ID = trm.MainAgentID                                                 
left join agentLogin al on al.UserID=trm.AgentID            
            
 Where tSh.IsActive=1                                                                                                     
  and tsh.FkStatusId=7                                                                                                     
  and AL.userTypeID in (2,3--,4                                              
  )                                                   
            
and trm.PaymentMode=2                                                                                                    
  --and tSH.CreateDate > =('2025-05-30') --'2022-03-31 23:59:59.999'                                                                                     
  and trm.Transfer_ERPCanResponseID is null and (trm.Transfer_ERPCanPushStatus = 0 or trm.Transfer_ERPCanPushStatus is null)                                                                                                               
   
 and BookingRefId in('TNC0000020'  )    
 Order by trm.BookingId desc                  
   END                                                                                               
                                                                                                    
                                                                                        
                                                                                                    
   IF @Action = 'Transfer_BookingSuccessResponce'                                                                                                  
   BEGIN                                                                                         
   Update tr.TR_BookingMaster SET Transfer_ERPPushResponseID = @ERPResponceID, Transfer_ERPPushStatus = 1                                                                                              
   Where BookingId = @PKID;                                                                                                    
   select @PKID                                                                                                    
   END                                                                                                      
   IF @Action = 'Transfer_CancellationSuccessResponce'                        
   BEGIN                                                                       
   Update tr.TR_BookingMaster           
   SET Transfer_ERPCanResponseID = @CanERPResponceID, Transfer_ERPCanPushStatus = 1                                                                                                    
    Where BookingId = @PKID;                                                                                                    
    select @PKID                                                                                                    
                                                                          
   END                                                                                                   
                                         
                                                                                                  
END 

