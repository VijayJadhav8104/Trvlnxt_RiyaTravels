      
CREATE proc [dbo].[Agent_ActiveDeactive_ServiceFee_GST_Quatation]      
      
@ID int,      
@Flag bit,      
@UpdatedBy int     
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
    
 INSERT INTO [dbo].[tbl_ServiceFee_GST_QuatationDetailsDelete]      
           ([Action],[MarketPoint],[AirportType],[AirlineType]      
           ,[UserType],[GroupType],[AgencyId],[AgentCategory]      
           ,[AgencyNames],[Remark],[TravelValidityFrom],[TravelValidityTo]      
           ,[SaleValidityFrom],[SaleValidityTo],[RBD],[RBDValue]      
           ,[FareBasis],[FareBasisValue],[FlightSeries],[FlightSeriesValue]      
           ,[Origin],[OriginValue],[Destination],[DestinationValue]      
           ,[InsertedDate],[Flag],[FlightNo],[FlightNoValue]      
           ,[Cabin],[ServiceFee],[GST],[Quatation],[DeletedBy]      
           ,[DeletedOn],[Currency])    
         
     select @Action,[MarketPoint],[AirportType],[AirlineType]      
           ,[UserType],[GroupType],[AgencyId],[AgentCategory]      
           ,[AgencyNames],[Remark],[TravelValidityFrom],[TravelValidityTo]      
           ,[SaleValidityFrom],[SaleValidityTo],[RBD],[RBDValue]      
           ,[FareBasis],[FareBasisValue],[FlightSeries],[FlightSeriesValue]      
           ,[Origin],[OriginValue],[Destination],[DestinationValue]      
           ,[InsertedDate],[Flag],[FlightNo],[FlightNoValue]      
           ,[Cabin],[ServiceFee],[GST],[Quatation],@UpdatedBy    
           ,getdate(),[Currency] from tbl_ServiceFee_GST_QuatationDetails    
     where id=@ID    
    
  update tbl_ServiceFee_GST_QuatationDetails      
  set Flag = @Flag      
  where ID = @ID      
 end      
 else      
 begin      
  update tbl_ServiceFee_GST_QuatationDetails      
  set Flag = @Flag      
  where MarketPoint in (select C.CountryCode  from mUserCountryMapping UM      
    INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@UpdatedBy  AND IsActive=1)      
 end      
      
end      
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Agent_ActiveDeactive_ServiceFee_GST_Quatation] TO [rt_read]
    AS [dbo];

