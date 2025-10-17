CREATE proc [dbo].[InsertHistory_ServiceFee_GST_Quatation]        
@Action varchar(50),    
@MarketPoint varchar(30),        
@AirportType varchar(50),  
@AirlineType varchar(50),  
@UserType varchar(40),    
@GroupType varchar(50),        
@FlightNo bit,        
@FlightNoValue varchar(max),        
@TravelValidity_From datetime,        
@TravelValidity_To datetime,        
@SalesValidity_From datetime,        
@SalesValidity_To datetime,        
@RBD  bit,        
@RBDValue varchar(max)=null,        
@FareBasis bit,        
@FareBasisValue varchar(max)=null,        
@Origin  bit,        
@OriginValue varchar(max)=null,        
@Destination bit,        
@DestinationValue varchar(max)=null,     
@Flag bit,    
@FlightSeries bit,        
@AgentCategory varchar(max)=null,        
@AgencyNames varchar(max)=null,        
@AgencyId varchar(max)=null,        
@FlightSeriesValue varchar(max)=null,        
@Remark varchar(max)= null,        
@Cabin varchar(max),        
@ServiceFee Decimal(18,2)= NULL,        
@GST int= Null,        
@Quatation int =null,          
@UserID int,        
@Currency varchar(10),        
@TransactionType Varchar(50)=null ,       
@CRSType  varchar(50)=null,       
@OriginCountry VARCHAR(MAX)=NULL,      
@DestinationCountry VARCHAR(MAX)=NULL      
as        
begin     
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
     VALUES    
           (@Action,@MarketPoint,@AirportType ,@AirlineType   
           ,@UserType,@GroupType,@AgencyId,@AgentCategory,    
     @AgencyNames    
           ,@Remark    
           ,@TravelValidity_From    
           ,DATEADD(s, 43199,@TravelValidity_To)    
           ,@SalesValidity_From    
           ,DATEADD(s, 43199,@SalesValidity_To)    
           ,@RBD    
           ,@RBDValue    
           ,@FareBasis    
           ,@FareBasisValue    
           ,@FlightSeries    
           ,@FlightSeriesValue    
           ,@Origin    
           ,@OriginValue    
           ,@Destination    
           ,@DestinationValue    
           ,GETDATE()     
           ,@Flag    
           ,@FlightNo    
           ,@FlightNoValue    
           ,@Cabin    
           ,@ServiceFee    
           ,@GST    
           ,@Quatation    
           ,@UserID    
           ,GETDATE()      
           ,@Currency)    
    
End    


    