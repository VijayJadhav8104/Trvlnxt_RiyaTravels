        
CREATE PROCEDURE [Hotel].[InsertSupplierErrorMapping]   
  @ProviderMessage VARCHAR(1700) = NULL        
 ,@ErrorCode VARCHAR(500) = NULL        
 ,@ErrorMessage VARCHAR(1700) = NULL        
 ,@Provider VARCHAR(500) = NULL        
 ,@MethodName VARCHAR(200) = NULL      
 ,@CorrelationId VARCHAR(150)=NULL  
 ,@BookingReference VARCHAR(150)=NULL  
 ,@HotelId VARCHAR(50)=NULL  
AS        
BEGIN        
 IF NOT EXISTS (        
   SELECT Id        
   FROM [Hotel].[SupplierErrorMapping]        
   WHERE ISNULL(ProviderMessage, '') = ISNULL(@ProviderMessage, '')        
    AND ISNULL(ErrorCode, '') = ISNULL(@ErrorCode, '')        
    AND ISNULL(ErrorMessage, '') = ISNULL(@ErrorMessage, '')        
    AND ISNULL(Provider, '') = ISNULL(@Provider, '')       
 AND ISNULL(MethodName, '') = ISNULL(@MethodName, '')    
    AND IsActive = 1        
   )        
 BEGIN        
  INSERT INTO [Hotel].[SupplierErrorMapping] (        
   ProviderMessage        
   ,ErrorCode        
   ,ErrorMessage        
   ,Provider        
   ,MethodName      
   ,CorrelationId  
   ,HotelId  
   ,BookingReference  
   )        
  VALUES (        
   @ProviderMessage        
   ,@ErrorCode        
   ,@ErrorMessage        
   ,@Provider        
   ,@MethodName      
   ,@CorrelationId  
   ,@HotelId  
   ,@BookingReference  
   )        
 END        
END        
        
--SELECT COUNT(Id) FROM [Hotel].[SupplierErrorMapping] WHERE ProviderMessage='PNR not found' AND ISNULL(ErrorCode,'')=ISNULL(NULL,'')       
--AND ErrorMessage='Your request failed due to an unknown system error. Please contact support team with the correlationId.' AND Provider='SabreAPI' AND ISNULL(MethodName,'')=ISNULL(NULL,'') AND IsActive=1        
      
--SELECT COUNT(Id) FROM [Hotel].[SupplierErrorMapping] WHERE ProviderMessage='PNR not found' AND ISNULL(ErrorCode,'')=ISNULL(NULL,'')       
--AND ErrorMessage='Your request failed due to an unknown system error. Please contact support team with the correlationId. AND Provider='SabreAPI' AND ISNULL(MethodName,'')=ISNULL(NULL,'') AND IsActive=0        
      
--select * from sys.objects where type='p' and name='InsertSupplierErrorMapping'        
--select * from sys.objects where type='u' and name='SupplierErrorMapping'