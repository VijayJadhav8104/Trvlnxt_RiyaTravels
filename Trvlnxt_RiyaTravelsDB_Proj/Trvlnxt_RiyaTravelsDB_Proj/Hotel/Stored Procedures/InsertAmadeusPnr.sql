CREATE Proc [Hotel].[InsertAmadeusPnr]            
             @PNR varchar(100)=null            
            ,@CountryCode varchar(100)=null            
            ,@OfficeId varchar(100)=null            
            ,@CityCode varchar(100)=null            
            ,@CityName varchar(100)=null            
            ,@BookingDate Datetime=null            
            ,@CheckIndate Datetime=null            
            ,@CheckoutDate Datetime=null            
            ,@HotelName varchar(100)=null            
            ,@TAS_NUMBER varchar(100)=null            
            ,@Hotel_Confirmation_Number varchar(100)=null            
            ,@EntityCode varchar(100)=null            
            ,@EmployeeId varchar(100)=null            
            ,@EmployeeName varchar(100)=null            
            ,@EmployeeFirstName varchar(100)=null            
            ,@EmployeeSurname varchar(100)=null            
            ,@TravelPlan varchar(100)=null            
            ,@HotelAddress varchar(100)=null            
            ,@RateType varchar(100)=null            
            ,@BookedCurrency varchar(100)=null            
            ,@BookedRatePerNightExTax decimal(18,3)=null            
   ,@BookedRatePerNightIncTax decimal(18,3)=null             
            ,@FullTrnAmountIncTax decimal(18,3)=null            
   ,@Breakfast varchar(100)=null            
   ,@AgentSignature varchar(100)=null            
   ,@Internet varchar(100)=null            
            ,@RoomNight decimal(18,3)=null            
            ,@ErrorMessage varchar(100)=null            
   ,@RoomType varchar(150)=null            
   ,@AmadeusCfgId int=null      
   ,@DeviationApprover varchar(200)=null      
   ,@ConcurId varchar(100)=null      
   ,@EmployeesBilliableToClient varchar(50)=null      
   ,@TravelCostReimbursableByClient varchar(50)=null    
   ,@PartialInfo bit = 0  
            
AS            
            
BEGIN            
               
   Declare @RoeRate float=0            
   set @RoeRate= ( select top 1 roe from roe where cast(@BookingDate as date)=cast(InserDate as Date) and FromCur='INR' and ToCur=@BookedCurrency)            
            
            
    if exists(select 1 from [Hotel].tblAmedeousPnr where PnrNo=@PNR and PartialInfo=1)            
     begin            
    update [Hotel].tblAmedeousPnr set            
    [PnrNo]=@PNR,            
    [BookingDate]=@BookingDate,            
    [TASNumber]=@TAS_NUMBER,            
    [EntityCode]=@EntityCode,            
    [EmployeeID]=@EmployeeId,            
    [EmployeeName]=@EmployeeName,            
    [EmployeeFirstName]=@EmployeeFirstName,            
    [EmployeeSurname]=@EmployeeSurname,            
    [TravelPlan]=@TravelPlan,            
 --  [EmployeeBand]=@e,            
    [HotelBookedCountry]=@CountryCode,            
    [HotelBookedCity]=@CityCode,            
    [CityName]=@CityName,            
    [CheckIndate]=@CheckIndate,            
    [CheckOutdate]=@CheckoutDate,            
    [RoomNight]=@RoomNight,            
    [HotelName]=@HotelName,            
    [HotelAddress]=@HotelAddress,            
    [HotelConfirmationNumber]=@Hotel_Confirmation_Number,            
    [BookedCurrency]=@BookedCurrency,            
    [BookedRatePerNightIncTax]=@BookedRatePerNightIncTax,            
    [BookedRatePerNightExTax]=@BookedRatePerNightExTax,            
    [FullTrnAmountIncTax]=@FullTrnAmountIncTax,            
    [AgentSignature] = @AgentSignature,            
    [Internet] = @Internet,            
    [Breakfast] = @Breakfast,            
    --[Deviation],            
    [InsertedDate] = GetDate(),            
    RoomType=@RoomType,            
    RateType=@RateType,            
    RoeRateBookingDate=@RoeRate,      
 DeviationApprover=@DeviationApprover,      
 ConcurId=@ConcurId,      
 EmployeesBilliableToClient=@EmployeesBilliableToClient,      
 TravelCostReimbursableByClient=@TravelCostReimbursableByClient      
      ,PartialInfo= @PartialInfo  
    where PnrNo=@PNR and PartialInfo=1 
   ENd             
            
   If not exists(select 1 from [Hotel].tblAmedeousPnr where PnrNo=@PNR)            
   begin            
      insert into [Hotel].tblAmedeousPnr            
      (            
     [PnrNo]            
    ,[BookingDate]            
    ,[TASNumber]            
 ,[EntityCode]            
    ,[EmployeeID]            
    ,[EmployeeName]            
    ,[EmployeeFirstName]            
    ,[EmployeeSurname]            
    ,[TravelPlan]            
    ,[EmployeeBand]            
    ,[HotelBookedCountry]            
    ,[HotelBookedCity]            
    ,[CityName]            
    ,[CheckIndate]            
    ,[CheckOutdate]            
    ,[RoomNight]            
    ,[HotelName]            
    ,[HotelAddress]            
    ,[HotelConfirmationNumber]            
    ,[BookedCurrency]            
    ,[BookedRatePerNightIncTax]            
    ,[BookedRatePerNightExTax]            
    ,[FullTrnAmountIncTax]            
    ,[AgentSignature]            
    ,[Internet]            
    ,[Breakfast]            
    ,[Deviation]            
    ,InsertedDate            
    ,RoomType            
    ,RateType            
    ,RoeRateBookingDate          
    ,AmadeusConfId      
 ,DeviationApprover      
 ,ConcurId      
 ,EmployeesBilliableToClient      
 ,TravelCostReimbursableByClient     
      ,PartialInfo  
   
   )            
  values            
  (            
    @PNR            
   ,@BookingDate            
   ,@TAS_NUMBER            
   ,@EntityCode            
   ,@EmployeeId            
   ,@EmployeeName            
   ,@EmployeeFirstName            
   ,@EmployeeSurname            
   ,@TravelPlan            
   ,''            
   ,@CountryCode            
   ,@CityCode            
   ,@CityName            
   ,@CheckIndate            
   ,@CheckoutDate            
   ,@RoomNight            
   ,@HotelName            
   ,@HotelAddress            
   ,@Hotel_Confirmation_Number,@BookedCurrency            
   ,@BookedRatePerNightIncTax            
   ,@BookedRatePerNightExTax            
   ,@FullTrnAmountIncTax            
   ,@AgentSignature            
   ,@Internet            
   ,@Breakfast            
   ,0            
   ,getDate()            
   ,@RoomType            
   ,@RateType            
   ,@RoeRate          
   ,@AmadeusCfgId      
   ,@DeviationApprover      
   ,@ConcurId      
   ,@EmployeesBilliableToClient      
   ,@TravelCostReimbursableByClient      
   ,@PartialInfo  
   )            
   end            
            
              
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[Hotel].[InsertAmadeusPnr] TO [rt_read]
    AS [DB_TEST];

