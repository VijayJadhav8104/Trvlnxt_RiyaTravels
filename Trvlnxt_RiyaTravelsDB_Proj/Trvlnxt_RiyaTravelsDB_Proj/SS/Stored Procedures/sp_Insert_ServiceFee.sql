                          
 CREATE PROCEDURE [SS].[sp_Insert_ServiceFee]                      
 @Id int=null,                    
 @MarketPoint varchar(20)=Null,                         
 @ServiceType varchar(50)=null,                        
 @UserType varchar(200)=Null,                           
 @TravelValidityFrom datetime=Null,                          
 @TravelValidityTo datetime=Null,                          
 @SaleValidityFrom datetime=Null,                          
 @SaleValidityTo datetime=Null,                          
 @GST varchar(20)=Null,                          
 @BookingType varchar(50)=Null,                          
 @Currency varchar(10)=Null,                      
 @CreadtedBy varchar(30)=Null,                    
 @SupplierType nvarchar(50) =Null,                
 @AgentId nvarchar(50) =Null,            
 @CommissionType varchar(50)=Null,             
 @Commission decimal(8,2)=null,        
 @ReservationType varchar(10)=Null,       
 @TimeSlotFrom varchar(10)=null,          
 @TimeSlotTo varchar(10)=null        
         
 AS                           
 BEGIN                         
 If(@Id=0)                    
 Begin                    
  Insert Into [SS].[tbl_SS_ServiceFee]                          
  (                          
  MarketPoint,                          
  UserType,                          
  TravelValidityFrom,                          
  TravelValidityTo,                          
  SaleValidityFrom,                          
  SaleValidityTo,                          
  GST,                          
  BookingType,                          
  Currency,                        
  ServiceType,                        
  CreatedDate,                        
  isActive,                      
  CreatedBy,                  
  SupplierType,                
  AgentId,            
  CommissionType,            
  Commission,        
  ReservationType,        
  TimeSlotFrom,        
  TimeSlotTo        
   )                          
   Values(                          
   @MarketPoint,                          
   @UserType,                          
   @TravelValidityFrom,                          
   @TravelValidityTo,                          
   @SaleValidityFrom,                          
   @SaleValidityTo,                          
                            
   @GST,                          
   @BookingType,                          
                            
   @Currency,                        
   @ServiceType,                        
   getDate(),                        
   1 ,                      
   @CreadtedBy,                  
   @SupplierType,                
   @AgentId,            
   @CommissionType,            
   @Commission ,        
   @ReservationType,        
   @TimeSlotFrom,        
   @TimeSlotTo        
                         
   )               
                
  Declare @ServiceID int              
  Select top 1 @ServiceID=Id from [SS].[tbl_SS_ServiceFee] order by Id desc              
  DECLARE @Agentstr VARCHAR(300)               
              
 SET @Agentstr =(Select AgentId from [SS].[tbl_SS_ServiceFee] where Id=@ServiceID)               
 If ((select len(@Agentstr))>0)              
  BEGIN              
   DECLARE @SEPARATOR CHAR(1)               
   SET @SEPARATOR=','               
                 
   INSERT INTO [SS].[tbl_Service_AgentMapping]              
               (agentid,ServiceId)               
   (SELECT Item,@ServiceID as ServiceId FROM   dbo.splitstring(@Agentstr, @SEPARATOR))              
 END              
 End                      
 If(@Id>0)                    
    Begin                    
       Update [SS].[tbl_SS_ServiceFee] Set                    
   MarketPoint=@MarketPoint,                          
   UserType=@UserType,                          
   TravelValidityFrom=@TravelValidityFrom,                          
   TravelValidityTo=@TravelValidityTo,                          
   SaleValidityFrom=@SaleValidityFrom,                          
   SaleValidityTo=@SaleValidityTo,                          
GST=@GST,                          
   BookingType=@BookingType,                          
   Currency=@Currency,                        
   ServiceType=@ServiceType,                     
   ModifiedDate=GETDATE(),                
   ModifyBy=@CreadtedBy ,                  
   SupplierType=@SupplierType,                 
   AgentId=@AgentId,            
   CommissionType=@CommissionType,            
   Commission= @Commission,          
    ReservationType= @ReservationType,        
   TimeSlotFrom=@TimeSlotFrom,        
  TimeSlotTo= @TimeSlotTo        
   Where Id=@Id                    
    End                    
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[SS].[sp_Insert_ServiceFee] TO [rt_read]
    AS [DB_TEST];

