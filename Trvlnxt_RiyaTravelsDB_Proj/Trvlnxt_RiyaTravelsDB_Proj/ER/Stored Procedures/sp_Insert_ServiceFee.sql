                    
 CREATE PROCEDURE [ER].[sp_Insert_ServiceFee]                
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
 @Commission decimal(8,2)      
 AS                     
 BEGIN                   
 If(@Id=0)              
 Begin              
  Insert Into [ER].[tbl_ServiceFee]                     
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
  Commission      
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
   @Commission      
                   
   )         
          
  Declare @ServiceID int        
  Select top 1 @ServiceID=Id from [ER].[tbl_ServiceFee]  order by Id desc        
  DECLARE @Agentstr VARCHAR(300)         
        
 SET @Agentstr =(Select AgentId from [ER].[tbl_ServiceFee]  where Id=@ServiceID)         
 If (@Agentstr!='All')        
  BEGIN        
   DECLARE @SEPARATOR CHAR(1)         
   SET @SEPARATOR=','         
           
   INSERT INTO [ER].[Service_AgentMapping]         
               (agentid,ServiceId)         
   (SELECT Item,@ServiceID as ServiceId FROM   dbo.splitstring(@Agentstr, @SEPARATOR))        
 END        
 End                
 If(@Id>0)              
    Begin              
       Update [ER].[tbl_ServiceFee] Set              
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
   AgentId=@AgentId,      
   CommissionType=@CommissionType,      
   Commission= @Commission      
   Where Id=@Id              
    End              
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[ER].[sp_Insert_ServiceFee] TO [rt_read]
    AS [RiyaTravels];

