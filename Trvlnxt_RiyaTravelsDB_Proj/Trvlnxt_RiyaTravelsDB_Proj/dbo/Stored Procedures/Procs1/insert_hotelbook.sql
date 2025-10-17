CREATE PROCEDURE [dbo].[insert_hotelbook]          
 @expected_prize VARCHAR(20)                                                          
 ,@searchApiId VARCHAR(50)= NULL                                                          
 ,@hotelId VARCHAR(50)= NULL                                                          
 ,@section_unique_id VARCHAR(100)= NULL                                                          
 ,@riyaPNR VARCHAR(10)= NULL                                                                        
 ,@CityName VARCHAR(100)= NULL                                                          
 ,@CheckInDate VARCHAR(50)= NULL                                                          
 ,@CheckOutDate VARCHAR(50)= NULL                                                          
 ,@ISDCOde VARCHAR(50) = NULL                                                          
 ,@PassengerPhone VARCHAR(50) = NULL                                                         
 ,@PassengerEmail VARCHAR(150)= NULL                                                          
 ,@totalTax INT = 0                                                          
 ,@IsBooked INT = NULL                                                          
 ,@CancelHours NUMERIC(18, 2) = NULL                                                          
 ,@promoCode VARCHAR(50) = NULL                                                          
 ,@request VARCHAR(1500) = NULL                                                          
 ,@comment VARCHAR(max) = NULL                                                          
 ,@agent_charge DECIMAL(10, 2) = NULL                                                          
 ,@hotelname VARCHAR(150) = NULL                                                          
 ,@TotalAdults VARCHAR(10) = NULL                                                          
 ,@TotalChildren VARCHAR(10) = NULL                                                          
 ,@TotalRooms VARCHAR(10) = NULL                                                          
 ,@LoginID VARCHAR(500) = NULL                                                          
 ,@CancelCharges NUMERIC(18, 2) = NULL                                                          
 ,@QtechCancelCharges NUMERIC(18, 2) = NULL                                         
 ,@CurrencyCode varchar(10)=null                                        
 ,@CancelDate VARCHAR(50) = NULL                         
 --@QtechTotalCharges numeric(18,2),                                                                  
 --@QtechAppliedAgentcharge numeric(18,2),                                                                  
 --@QtechAppliedAgentRate numeric(18,2)                                                                                                                 
 ,@beforecancelcharge INT = NULL                                                          
 ,@B2BPaymentMode INT = NULL                                                          
 ,--Added bye rakesh to Indentify Hold = 1,Wallet=2,CCA = 3                                                                  
  @RiyaAgentID BIGINT = NULL                                              
 ,@MainAgentId BIGINT = NULL         
         
 ,@AgentRemark NVARCHAR(500) = NULL                                                          
 ,@SpecialRemark NVARCHAR(max) = NULL                                                          
 ,@MarkupAmount NUMERIC(18, 2) = NULL                                                          
 ,@MarkupCurrency VARCHAR(50) = NULL                                                          
 ,@BranchCode NVARCHAR(200) = NULL                                                          
 ,@BookingCountry VARCHAR(50) = NULL                                                          
 ,@QutechHotelId NVARCHAR(500) = NULL                                                          
 ,@QutechSearchUniqueId NVARCHAR(500) = NULL                                                          
 ,@QutechSectionUniqueId NVARCHAR(500) = NULL                                                          
 ,@SupplierUsername NVARCHAR(200) = NULL                                                          
 ,@SupplierPassword NVARCHAR(200) = NULL                                                         
 ,@Meal NVARCHAR(500) = NULL                                                      
 ,@orderId NVARCHAR(500) = NULL                                                          
 ,@SupplierName NVARCHAR(200) = NULL                                                
 ,@LocalHotelId NVARCHAR(500) = NULL                                  
 ,@CanDeadLineDate NVARCHAR(200) = NULL                                  
 ,@TotalRoomAmount Varchar (50) = NULL                                  
 ,@TotalSummaryAmount Varchar (50) = NULL                     
 ,@AmountBeforePgCommission Varchar (50) = NULL                                  
 ,@AmountAfterPgComission Varchar (50) = NULL                               
 ,@PriceChangeOrderId Varchar (50) = NULL                                
 ,@DisplayDiscountRate Varchar (50) = NULL                         
 ,@ispricechange Varchar (5) = NULL                       
 ,@VendorBasicAmount Varchar (20) = NULL                        
 ,@ROEVAlue varchar(50) =null                       
 ,@VendorBasicAmountBaseCur Varchar (20) = NULL                        
 ,@ExpectedPriceBaseCur Varchar (20) = NULL                 
 ,@AlertEmail Varchar (150) = NULL             
 ,@LeaderTitle varchar(6) = NULL                         
 ,@LeaderFirstName varchar(150) = NULL                          
 ,@LeaderLastName varchar(150) = NULL           
 , @CountryName varchar(250)=null                       
 , @CityId varchar(150)=null          
 , @HotelAddress1 varchar(650)=null          
 , @ExpirationDate datetime=null                            
 , @HotelPhone varchar(50)=null                          
 , @HotelRating varchar(20)=null          
 , @CommentContract varchar(max)=null          
 , @SupplierCurrencyCode varchar(10)=null          
 ,@SubMainAgentId BIGINT = NULL                                              
 ,@AgentTotalNetAmount Varchar (20) = NULL 
 ,@SubAgentId INT = null
 ,@UserIpAddress Varchar(50)=NULL
         
AS                          
BEGIN                                             
                                          
declare @book_pk_id BIGINT=0;                                          
                                          
 INSERT INTO [dbo].[Hotel_BookMaster] (                                                          
  [expected_prize]                                                          
  ,[searchApiId]                                                      
  ,[hotelId]                                                          
  ,[section_unique_id]                                                          
  ,[riyaPNR]                                                          
  ,cityname                                                      
  ,[CheckInDate]                                                          
  ,[CheckOutDate]                                                          
  ,[ISDCode]                                         
  ,[PassengerPhone]                                                          
  ,[PassengerEmail]                                                          
  ,[inserteddate]                                                          
  ,[promoCode]                                                          
  ,request                                                          
  ,[CancelHours]                                                          
  ,[AppliedAgentCharges]                                                          
  ,[ContractComment]                                                          
  ,[hotelname]           
  ,[TotalAdults]                                                          
  ,[TotalChildren]                                                          
  ,[TotalRooms]                           
  ,[LoginID]                                                          
  ,[CancellationCharge]                                                          
  ,[QtechCancelCharge]                          
  --,[QtechTotalCharges]                                               
  --,[QtechAppliedAgentCharges]                                                                  
  -- ,[QtechAppliedAgentRate]                                                                  
  --,[IsBooked]                                                                  
  ,[CancelDate]                                                          
  ,[beforecancelcharge]            
  ,B2BPaymentMode                                                          
  ,RiyaAgentID                                                          
  ,AgentRemark                                                          
  ,SpecialRemark             
  ,MarkupAmount                                                          
  ,MarkupCurrency                                                          
  ,BranchCode                                                          
  ,BookingCountry                                                          
  ,QutechHotelId                                                           
  ,QutechSearchUniqueId                                                           
  ,QutechSectionUniqueId                                                           
  ,SupplierUsername                                                           
  ,SupplierPassword                                                           
  ,Meal                                                   
  ,orderId                                                  
  ,SupplierName                                                 
  ,LocalHotelId                                               
  ,MainAgentID                        
  ,CurrencyCode                                      
  ,CancellationDeadLine                                  
  ,TotalRoomAmount                                  
  ,TotalSummaryAmount                                  
  ,AmountBeforePgCommission                                  
  ,AmountAfterPgCommision                           
  ,PriceChangeOrderId                            
  ,DisplayDiscountRate                          
  ,ispricechange                         
  ,CurrentStatus                      
  ,VendorBasicAmount                     
  ,ROEValue                    
  ,VendorBasicAmountBaseCur                  
  ,ExpectedPriceBaseCur                
  ,AlertEmail           
  ,LeaderTitle          
  ,LeaderFirstName          
  ,LeaderLastName          
  ,CountryName          
  ,CityId          
  ,HotelAddress1          
  ,ExpirationDate          
  ,HotelPhone          
  ,HotelRating          
  ,CancellationPolicy          
  ,SupplierCurrencyCode         
  ,SuBMainAgentID        
  ,AgentTotalNetAmoun 
  ,SubAgentId
  ,UserIpAddrress
  )                                               
 VALUES (                                                          
  @expected_prize                                                  
  ,@searchApiId                                                          
  ,@hotelId                                                          
  ,@section_unique_id                                                          
  ,@riyaPNR                                                          
  ,@CityName                                                          
  ,cast(@CheckInDate AS DATETIME)                                                          
  ,cast(@CheckOutDate AS DATETIME)                                                          
  ,@ISDCOde                                    
  ,@PassengerPhone                                                          
  ,@PassengerEmail                                                          
  ,getdate()                                                          
  ,@promoCode     
  ,@request                                                          
  ,@CancelHours                                                          
  ,@agent_charge                                                          
  ,@comment                                                          
  ,@hotelname                          
,@TotalAdults                                                      
  ,@TotalChildren                                                          
  ,@TotalRooms                                                          
  ,@LoginID                                                          
  ,@CancelCharges                                                          
  ,@QtechCancelCharges                                                          
  --@QtechTotalCharges ,                                                                  
  --@QtechAppliedAgentcharge ,                                                                  
  --@QtechAppliedAgentRate                                                                  
  ,@CancelDate                                                          
  ,@beforecancelcharge                                                      
  ,@B2BPaymentMode                                                          
  ,@RiyaAgentID                                                          
  ,@AgentRemark                                                          
  ,@SpecialRemark                                                          
  ,@MarkupAmount                                                          
  ,@MarkupCurrency                                                          
  ,@BranchCode                                                          
  ,@BookingCountry                                                          
  ,@QutechHotelId                                                           
  ,@QutechSearchUniqueId                                                           
  ,@QutechSectionUniqueId                                                         
  ,@SupplierUsername                                                          
  ,@SupplierPassword                                                           
  ,@Meal                                                        
  ,@orderId                                  
  ,@SupplierName                                                  
  ,@LocalHotelId                                               
  ,@MainAgentId                                           
  ,@CurrencyCode                                        
  ,@CanDeadLineDate                                   
  ,@TotalRoomAmount                                   
  ,@TotalSummaryAmount                                   
  ,@AmountBeforePgCommission                                 
  ,@AmountAfterPgComission                                 
  ,@PriceChangeOrderId                             
  ,@DisplayDiscountRate                           
  ,@ispricechange                         
  ,'pending'                       
  ,@VendorBasicAmount                     
  ,@ROEVAlue                   
   ,@VendorBasicAmountBaseCur                  
  ,@ExpectedPriceBaseCur                 
  ,@AlertEmail           
  ,@LeaderTitle          
  ,@LeaderFirstName          
  ,@LeaderLastName          
  ,@CountryName          
  ,@CityId          
  ,@HotelAddress1          
  ,@ExpirationDate          
  ,@HotelPhone          
  ,@HotelRating          
  ,@CommentContract          
  ,@SupplierCurrencyCode         
  ,@SubMainAgentId        
  ,@AgentTotalNetAmount  
  ,@SubAgentId
  ,@UserIpAddress
  )             
                                                          
set @book_pk_id = (SELECT SCOPE_IDENTITY())                                          
                                           
     insert into Hotel_Status_History                                            
    (                                            
     FKHotelBookingId                                            
    ,FkStatusId            
    ,CreateDate                                            
    ,CreatedBy                                            
    ,ModifiedDate                                            
    ,IsActive                   
  --,RiyaAgentId              
    ,MainAgentId    
 ,MethodName    
                        
    )                                            
    values                                            
    (                                            
     @book_pk_id                              
    ,'10'         -- For default is pending Status.                                   
    ,SYSDATETIME()                                            
    ,@RiyaAgentID                                            
    ,null                                            
    ,1                
 --,@RiyaAgentID              
   ,@MainAgentId    
   ,'HotelBookConfirmation'    
    )                                            
      select @book_pk_id;                                           
END 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insert_hotelbook] TO [rt_read]
    AS [dbo];

