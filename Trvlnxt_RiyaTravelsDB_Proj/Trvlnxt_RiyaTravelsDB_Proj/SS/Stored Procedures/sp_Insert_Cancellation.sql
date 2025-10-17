        
  
 --  [SS].[sp_Insert_Cancellation] 0,'test','Cancellation','2022-06-09 00:00:00.000','2023-06-09 00:00:00.000','Fixed',12,20.8,58,'Sightseeing'  
 CREATE PROCEDURE [SS].[sp_Insert_Cancellation]                      
 @Pkid int=null,                    
 @Policy varchar(20)=Null,                         
 @ServiceType varchar(50)=null,                          
 @Fromdate datetime=Null,                          
 @ToDate datetime=Null,                          
 @ChargesType varchar(50)=Null,                          
 @Cancellation_charges varchar(50)=Null,        
 @Cancellation_Hours decimal(18,2)=Null,        
 @CreatedBy varchar(30)=Null,                    
 @SupplierType nvarchar(50) =Null        
         
 AS                           
 BEGIN                         
 If(@Pkid=0)                    
 Begin                    
  Insert Into [SS].tbl_Cancellation                           
  (                          
         
 [Policy],        
 ChargesType,        
 Cancellation_charges,        
 Cancellation_Hours,        
 CreatedDate,        
 IsActive,        
 SupplierId,        
 Fromdate,        
 ToDate,        
 ServiceType,      
 CreatedBy      
   )                          
   Values(        
   @Policy,        
 @ChargesType,        
 @Cancellation_charges,        
 @Cancellation_Hours,        
   getDate(),        
  1 ,        
 @SupplierType,        
 @Fromdate,        
 @ToDate,        
 @ServiceType,       
 @CreatedBy      
                                   
   )               
                
           
 End                      
 If(@Pkid>0)                    
    Begin                    
       Update [SS].tbl_Cancellation Set                    
   [Policy]=@Policy,        
 ChargesType=@ChargesType,                 
 Cancellation_charges=@Cancellation_charges,        
 Cancellation_Hours=@Cancellation_Hours,        
 SupplierId=@SupplierType,        
 Fromdate=@Fromdate,        
 ToDate=@ToDate,        
 ServiceType=@ServiceType      
   Where Pkid=@Pkid                    
    End                    
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[SS].[sp_Insert_Cancellation] TO [rt_read]
    AS [DB_TEST];

