-- =============================================  
-- Author:  Bhavika kawa  
-- Create date: 14/07/2020  
-- Description: Get ROE History  
-- =============================================  
CREATE PROCEDURE [dbo].[Sp_GetDealMappingUpdationHistory]  
 @Type varchar(50),  
 @FromDate   datetime,  
 @ToDate  datetime,  
 @Configuration varchar(100)=null,  
 @Start int=null,  
 @Pagesize int=null,  
 @Userid int=null,  
 @RecordCount INT OUTPUT  
AS  
BEGIN  
  
 IF(@Type='DealMapping')  
BEGIN  
 IF OBJECT_ID ( 'tempdb..#tempTableDeal') IS NOT NULL  
 DROP table  #tempTableDeal  
 SELECT * INTO #tempTableDeal   
 from  
 (   
 select   History.ID,  History.Action,  History.TravelValidityFrom,  
 History.TravelValidityTo,  History.SaleValidityFrom,  History.SaleValidityTo,  
 History.Flag,  History.cabin,  History.Origin,  History.OriginValue,  
 History.Destination,  History.DestinationValue,  History.FlightSeries, 
 History.Commission,  History.IATADealPercent,  History.AgencyNames, 
 History.PLBDealPercent,  History.MarkupAmount,  History.PaxType, 
 History.AvailabilityPCC,History.PNRCreationPCC,History.TicketingPCC, 
(CONVERT(varchar, History.TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, History.TravelValidityTo, 105)) as [TravelValidity],  
 (CONVERT(varchar, History.SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, History.SaleValidityTo, 105)) as [SaleValidity],  
 History.ModifiedOn,History.Remark,History.PricingCode,History.TourCode,History.Endorsementline,History.FareType,History.CardMapping1,  History.IATADiscountType,History.PLBDiscountType,History.MarkupType,History.DropnetCommission,  
  
 u.UserName as 'ModifiedUN',comm.UserType,comm.MarketPoint,
 comm.AirportType,comm.AirlineType,comm.AgentCategory,c.CategoryValue as 'CRSTypeValue',History.LoginId,  
 BankName + '[************' + substring(CardNumber,len(CardNumber)-3,len(CardNumber)) + ']  [' + CardType + ']' as Text  
 ,comm.InsertedDate,u1.UserName as 'CreatedBy', History.RBD,History.FareBasis   
 from FlightCommissionHistory History  
 left join tblCardMaster Cm on  Cm.pkid=History.CardMapping1  
 left join FlightCommission comm on comm.Id=History.ParentId  
 left join mUser u ON U.ID=History.ModifiedBy  
 left join mUser u1 ON U1.ID=comm.UserID  
 left join tbl_commonmaster c on c.pkid=History.CRSType  
  
 where  CONVERT(date,History.ModifiedOn) >= CONVERT(date,@FromDate)    
  and CONVERT(date,History.ModifiedOn) <= CONVERT(date,@ToDate)  
     AND ((@Configuration = '') or (History.ConfigurationType = @Configuration))  
  
   ) p   
 order by p.ModifiedOn desc  
  
  SELECT @RecordCount = @@ROWCOUNT  
  
  SELECT * FROM #tempTableDeal  
  ORDER BY  ModifiedOn desc  
  OFFSET @Start ROWS  
  FETCH NEXT @Pagesize ROWS ONLY  
  
END  
  
  
  
END  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetDealMappingUpdationHistory] TO [rt_read]
    AS [dbo];

