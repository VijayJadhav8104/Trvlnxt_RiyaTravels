CREATE PROCEDURE [Cruise].[sp_Insert_Cruise_ServiceFee_GST_QuatationDetails]                  
 @Id int=null,                
 @MarketPoint varchar(20)=Null,                     
 @ServiceType varchar(50)=null,                    
 @UserType varchar(200)=Null,                       
 @TravelValidityFrom datetime=Null,                      
 @TravelValidityTo datetime=Null,                      
 @SaleValidityFrom datetime=Null,                      
 @SaleValidityTo datetime=Null,                      
 @Origin varchar(50)=Null,                      
 @Destination varchar(50)=Null,                      
 @GST varchar(20)=Null,                      
 @BookingType varchar(50)=Null,                      
 @Cabin varchar(50)=Null,                      
 @Deck varchar(50)=Null,                      
 @Room varchar(50)=Null,                      
 @Currency varchar(10)=Null,                  
 @CreadtedBy varchar(30)=Null,                
 @SupplierType nvarchar(50) =Null,            
 @AgentId nvarchar(50) =Null,        
 @CommissionType varchar(50)=Null,  
 @DiscountType varchar(50)=Null,
 @Discount decimal(8,2)= Null,
 @Commission decimal(8,2) = null,
 @ChargeType varchar(50)=null,
 @AgencyName varchar(100)=null,
 @authId int OUTPUT
 AS                       
 BEGIN                     
 If(@Id=0)                
 Begin                
  Insert Into Cruise.tbl_Cruise_ServiceFee_GST_QuatationDetails                       
  (       
  MarketPoint,                      
  UserType,                      
  TravelValidityFrom,                      
  TravelValidityTo,                      
  SaleValidityFrom,                      
  SaleValidityTo,                      
  Origin,                      
  Destination,                      
  GST,                      
  BookingType,                      
  Cabin,                      
  Deck,                      
  Room,                      
  Currency,                    
  ServiceType,                    
  CreatedDate,                    
  isActive,                  
  CreatedBy,              
  SupplierType,            
  AgentId,        
  CommissionType,
  DiscountType,
  Discount,
  Commission,
  ChargeType,
  AgencyName
  
   )                      
   Values(                      
   @MarketPoint,                      
   @UserType,                      
   @TravelValidityFrom,                      
   @TravelValidityTo,                      
   @SaleValidityFrom,                      
   @SaleValidityTo,                      
   @Origin,                      
   @Destination,                      
   @GST,                      
   @BookingType,                      
   @Cabin,                      
   @Deck,                      
   @Room,                      
   @Currency,                    
   @ServiceType,                    
   getDate(),                    
   1 ,                  
   @CreadtedBy,              
   @SupplierType,            
   @AgentId,        
   @CommissionType,
   @DiscountType,
   @Discount,
   @Commission,
   @ChargeType,
   @AgencyName
   ) 
  
  Set @authId = SCOPE_IDENTITY(); 

  SELECT @authId
  

  Declare @ServiceID int          
  Select top 1 @ServiceID=Id from Cruise.tbl_Cruise_ServiceFee_GST_QuatationDetails order by Id desc          
  DECLARE @Agentstr VARCHAR(300)           
          
 SET @Agentstr =(Select AgentId from Cruise.tbl_Cruise_ServiceFee_GST_QuatationDetails where Id=@ServiceID)           
 If (@Agentstr!='All')          
  BEGIN          
   DECLARE @SEPARATOR CHAR(1)           
   SET @SEPARATOR=','           
             
   INSERT INTO [Cruise].[Cruise_Service_AgentMapping]           
               (agentid,ServiceId)           
   (SELECT Item,@ServiceID as ServiceId FROM   dbo.splitstring(@Agentstr, @SEPARATOR)) 
   
 

 END          
 End                  
 If(@Id>0)                
    Begin                
       Update Cruise.tbl_Cruise_ServiceFee_GST_QuatationDetails Set                
   MarketPoint=@MarketPoint,                      
   UserType=@UserType,                      
   TravelValidityFrom=@TravelValidityFrom,                      
   TravelValidityTo=@TravelValidityTo,                      
   SaleValidityFrom=@SaleValidityFrom,                      
   SaleValidityTo=@SaleValidityTo,                      
   Origin=@Origin,                      
   Destination=@Destination,                      
   GST=@GST,                      
   BookingType=@BookingType,                      
   Cabin=@Cabin,                      
   Deck=@Deck,               
   Room=@Room,                      
   Currency=@Currency,                    
   ServiceType=@ServiceType,                 
   ModifiedDate=GETDATE(),                
   ModifyBy=@CreadtedBy ,              
   SupplierType=@SupplierType,        
   CommissionType=@CommissionType,
   DiscountType=@DiscountType,
   Discount=@Discount, 
   Commission= @Commission,
   ChargeType=@ChargeType,
   AgencyName=@AgencyName
   Where Id=@Id  
   
   Set @authId = @Id; 

  SELECT @authId
  
    End                
END 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[Cruise].[sp_Insert_Cruise_ServiceFee_GST_QuatationDetails] TO [rt_read]
    AS [DB_TEST];

