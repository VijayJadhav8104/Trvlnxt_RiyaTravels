    
    
    
    
    
    
CREATE proc [dbo].[Agent_ActiveDeactive_Markup]    
    
@ID int,    
@Flag bit,    
@UpdatedBy int=null    
    
as    
begin    
    
 if (@ID >0)    
  begin    
    
 declare @Action varchar(10)      
  if(@Flag=1)      
  BEGIN      
  SET @Action='Active'      
  END      
  ELSE      
  BEGIN      
  SET @Action='DeActive'      
  END      
    
  INSERT INTO [dbo].[Flight_MarkupTypeHistory]  
           ([Action]  
     ,[MarketPoint]  
           ,[AirportType]  
           ,[AirlineType]  
           ,[PaxType]  
           ,[Remark]  
           ,[OnBasic]  
           ,[OnTax]  
           ,[TravelValidityFrom]  
           ,[TravelValidityTo]  
           ,[SaleValidityFrom]  
           ,[SaleValidityTo]  
           ,[GroupType]  
           ,[Name]  
           ,[Flag]  
           ,[FareTypeRU]  
           ,[CalculationTypeRU]  
           ,[ValPerRU]  
           ,[FareTypeRP]  
           ,[CalculationTypeRP]  
           ,[ValPerRP]  
           ,[FareTypeM]  
           ,[CalculationTypeM]  
           ,[ValPerM]  
           ,[RUmaxAmt]  
           ,[RPmaxAmt]  
           ,[MmaxAmt]  
           ,[DisplayTypeRU]  
           ,[DisplayTypeRP]  
           ,[DisplayTypeM]  
           ,[BookingTypeM]  
           ,[BookingTypeRU]  
           ,[BookingTypeRP]  
           ,[UserType]  
           ,[AgencyId]  
           ,[AgentCategory]  
           ,[AgencyNames]  
           ,[UserID]  
           ,[UpdatedDate]  
           ,[RBD]  
           ,[RBDValue]  
           ,[FareBasis]  
           ,[FareBasisValue]  
           ,[FlightSeries]  
           ,[FlightSeriesValue]  
           ,[Origin]  
           ,[OriginValue]  
           ,[Destination]  
           ,[DestinationValue]  
           ,[FlightNo]  
           ,[FlightNoValue]  
           ,[Cabin]  
           ,[TransactionType]  
           ,[CRSType]  
           ,[AvailabilityPCC]  
           ,[OriginCountry]  
           ,[DestinationCountry])  
    
     select @Action  
     ,[MarketPoint]  
           ,[AirportType]  
           ,[AirlineType]  
           ,[PaxType]  
           ,[Remark]  
           ,[OnBasic]  
           ,[OnTax]  
           ,[TravelValidityFrom]  
           ,[TravelValidityTo]  
           ,[SaleValidityFrom]  
           ,[SaleValidityTo]  
           ,[GroupType]  
           ,[Name]  
           ,[Flag]  
           ,[FareTypeRU]  
           ,[CalculationTypeRU]  
           ,[ValPerRU]  
           ,[FareTypeRP]  
           ,[CalculationTypeRP]  
           ,[ValPerRP]  
           ,[FareTypeM]  
           ,[CalculationTypeM]  
           ,[ValPerM]  
           ,[RUmaxAmt]  
           ,[RPmaxAmt]  
           ,[MmaxAmt]  
           ,[DisplayTypeRU]  
           ,[DisplayTypeRP]  
           ,[DisplayTypeM]  
           ,[BookingTypeM]  
           ,[BookingTypeRU]  
           ,[BookingTypeRP]  
           ,[UserType]  
           ,[AgencyId]  
           ,[AgentCategory]  
           ,[AgencyNames]  
           ,@UpdatedBy  
           ,getdate()  
           ,[RBD]  
           ,[RBDValue]  
           ,[FareBasis]  
           ,[FareBasisValue]  
           ,[FlightSeries]  
           ,[FlightSeriesValue]  
           ,[Origin]  
           ,[OriginValue]  
           ,[Destination]  
           ,[DestinationValue]  
           ,[FlightNo]  
           ,[FlightNoValue]  
           ,[Cabin]  
           ,[TransactionType]  
           ,[CRSType]  
           ,[AvailabilityPCC]  
           ,[OriginCountry]  
           ,[DestinationCountry] from Flight_MarkupType    
      where id=@ID    
    
    
  update Flight_MarkupType    
  set Flag = @Flag    
  where ID = @ID    
 end    
 else    
 begin    
  update Flight_MarkupType    
  set Flag = @Flag    
  where MarketPoint in (select C.CountryCode  from mUserCountryMapping UM    
    INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@UpdatedBy  AND IsActive=1)    
 end    
    
end   

    
    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Agent_ActiveDeactive_Markup] TO [rt_read]
    AS [dbo];

