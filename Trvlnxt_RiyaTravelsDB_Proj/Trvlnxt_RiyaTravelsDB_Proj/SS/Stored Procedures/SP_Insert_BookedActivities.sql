CREATE PROCEDURE [SS].[SP_Insert_BookedActivities]    
  @BookingId int,     
  @Activitycode varchar(500)= null,     
  @ActivityName varchar(500)= null,     
  @ActivityDesc text= null,     
  @ActivityStatus varchar(50)= null,     
  @PricingPackageType varchar(50)= null,     
  @SessionId varchar(50)= null,    
  @ActivityOptionName varchar(50)= null,    
  @ActivityOptionCode varchar(50)= null,    
  @GuidingLanguage varchar(50)= null,    
  @GuidingLanguageCode varchar(50)= null,    
  @ActivityOptionTime varchar(50)= null,    
  @ActivityDetailJson text= null ,  
  @ProviderInfo varchar(200)=null  
AS    
BEGIN    
 SET NOCOUNT ON;    
 DECLARE @ActivityId INT     
    
 INSERT INTO [SS].[SS_BookedActivities]    
           (BookingId, Activitycode, ActivityName, ActivityDesc, ActivityStatus,     
   PricingPackageType, SessionId, ActivityOptionName, ActivityOptionCode, GuidingLanguage,     
   GuidingLanguageCode, ActivityOptionTime, ActivityDetailJson,providerinfo)    
     VALUES    
           (@BookingId, @Activitycode, @ActivityName, @ActivityDesc, 'In Process',     
   @PricingPackageType, @SessionId, @ActivityOptionName, @ActivityOptionCode, @GuidingLanguage,     
   @GuidingLanguageCode, @ActivityOptionTime, @ActivityDetailJson,@ProviderInfo)    
     
 SET @ActivityId  =(select  SCOPE_IDENTITY())      
 select @ActivityId    
END 