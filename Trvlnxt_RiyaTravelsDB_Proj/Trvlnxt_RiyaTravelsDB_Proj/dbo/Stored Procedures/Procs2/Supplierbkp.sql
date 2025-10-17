        
-- =============================================                                      
-- Author:  <Author,,Name>                                      
-- Create date: <Create Date,,>                                      
-- Description: <Description,,>                                      
-- =============================================                                      
CREATE PROCEDURE [dbo].[Supplierbkp]                                      
 -- Add the parameters for the stored procedure here                                      
 @Id int=0,                                      
 @SupplierName nvarchar(300)='',                                      
 @SupplierType  nvarchar(300)='',                                      
 @Username  nvarchar(300)='',                                      
 @Password  nvarchar(300)='',                                      
 @FirstName    nvarchar(300)='',                                      
 @MiddleName    nvarchar(300)='',                                      
 @LastName    nvarchar(300)='',                                      
 @Address     nvarchar(300)='',                                      
 @Country    int=0,                                      
 @City     int=0,                                      
 @PinCode    nvarchar(300)='',                                      
 @MobileNumber  nvarchar(300)='',                                      
 @Email     nvarchar(300)='',                                      
 @CommissionNet int=0,                                      
 @Action     nvarchar(300)='',                                      
 @CreatedBy  int=0,                                      
 @ModifiedBy  int=0,                                      
 @BookingFromDate datetime=null,                                      
 @BookingToDate datetime=null,                                      
 @TravelFromDate  datetime=null,                                      
 @TravelToDate datetime=null,                                      
 @Amount decimal(18,2)=0.0,                                      
 @Percent decimal(18,2)=0.0,                                   
 @PayAtHotel bit=0,                                                        
 @SupplierCharges float=null,                                                 
 @VccCharges float=null,                               
 @VirtualBalance float=null,                              
 @ModifiedOn datetime=null,                                                   
 @RhSupplierID varchar(200)=null,                                                                
 @SupplierCurrency varchar(500)=null,                                                                
 @BillingCountry varchar(500)=null,                                  
 @FKId int=0,                                      
 @ActionStatus bit=0,                           
 @IsActiveStatus bit=0,                  
 @IsDomesticPanReq bit=0,                  
 @IsInternationalPanReq bit=0                  
                                      
AS                                      
BEGIN                                      
                                       
 if(@Action='Insert')                                      
 begin                                      
  if not exists(select SupplierName from B2BHotelSupplierMaster where IsActive=1 and SupplierName=@SupplierName )                                      
                                      
  begin                                                                                                         
    insert into B2BHotelSupplierMaster(                                      
             SupplierName,                                      
             SupplierType,                                      
             Username,                                      
             Password,                                      
             FirstName,                                      
             MiddleName,                                      
             LastName,                        
             Address,                                      
             Country,                
             City,                                      
             PinCode,                                      
     MobileNumber,                                      
             Email,                                      
             Commission_Net,                                 
             PayAtHotel,                                                        
             SupplierCharges,                                      
             VccCharges,                              
             VirtualBalance,                              
             RhSupplierId,                                                    
             SupplierCurrency,                                            
             ModifiedOn,                                  
             BillingCountry,                                  
             CreatedBy,                                      
             Action,                          
           IsActive,                   
          Is_Req_Domestic_Pan,                  
             Is_Req_International_Pan                  
             )                                       
             values(                                  
             @SupplierName,                                      
             @SupplierType,                                      
             @Username,                                      
             @Password,                                      
             @FirstName,                                      
             @MiddleName,                                      
             @LastName,                                      
             @Address,                                      
          @Country,                                      
             @City,                                      
             @PinCode,                                      
             @MobileNumber,                                      
             @Email,                                      
             @CommissionNet,                                  
        @PayAtHotel,                                                        
 @SupplierCharges,                                                
 @VccCharges,                               
@VirtualBalance,                              
 @RhSupplierID,                                                
 @SupplierCurrency,                                            
 @ModifiedOn,                                            
 @BillingCountry,                                    
             @CreatedBy,                                 
             @ActionStatus,                           
    @ActionStatus,                  
 @IsDomesticPanReq,                  
 @IsInternationalPanReq                  
             )                                      
         --select SCOPE_IDENTITY();                                      
  end                                      
  select 1;                                      
 End                                      
                                      
 if(@Action='InsertDetails')                                     
 begin                                      
   insert into B2BHotelSupplierMasterDetails(                                      
             BookingFromDate,                                      
             BookingToDate,                                      
             TravelFromDate,                                      
             TravelToDate,                                      
             Amount,                                      
             PricePercent,                                      
             FKSupplierId,                                      
             IsActive                                      
             )                                       
             values(                                      
             @BookingFromDate,                     
             @BookingToDate,                                      
             @TravelFromDate,                                      
             @TravelToDate,                                      
             @Amount,                                
             @Percent,                                      
             @FKId,                                      
             1                                      
             )                                      
                     
                                        
 End                                   
                                      
 if(@Action='Update')                                      
 begin                                      
  update B2BHotelSupplierMaster set SupplierName=@SupplierName,                               
            SupplierType=@SupplierType,                                      
            Username=@Username,                                      
            [Password]=@Password,                                      
            FirstName=@FirstName,                                      
          MiddleName=@MiddleName,                                      
            LastName=@LastName,                                      
            Address=@Address,                                      
            PinCode=@PinCode,                                      
            MobileNumber=@MobileNumber,              
            Email=@Email,                                      
            Commission_Net=@CommissionNet,                                   
             PayAtHotel=@PayAtHotel,                                                         
           SupplierCharges=@SupplierCharges,                                                  
           VccCharges=@VccCharges,                              
         VirtualBalance=@VirtualBalance,                              
               RhSupplierId=@RhSupplierID,                                                    
           SupplierCurrency=@SupplierCurrency,                                                    
             BillingCountry=@BillingCountry,                                              
    Action=@ActionStatus,             
 IsActive=@ActionStatus,            
            ModifiedBy=@ModifiedBy,                                      
            ModifiedOn=GETDATE(),                  
   Is_Req_Domestic_Pan=@IsDomesticPanReq,                  
   Is_Req_International_Pan=@IsInternationalPanReq                  
                  
            where Id=@Id                                      
  select 1;                   
 End                                      
                                      
 if(@Action='UpdateDetails')                                      
 begin                                      
  update B2BHotelSupplierMasterDetails set BookingFromDate=@BookingFromDate,                                      
            BookingToDate=@BookingToDate,                                      
            TravelFromDate=@TravelFromDate,                                      
            TravelToDate=@TravelToDate,                                      
            Amount=@Amount,                                      
            PricePercent=@Percent                                      
            where FKSupplierId=@FKId                                      
 End                                      
                                      
 if(@Action='GetData')                                      
 begin                                
  select [HSM].Id                                                  
      --,case when PayAtHotel=1 then (SupplierName +'(PayAtHotel)') else SupplierName end as 'SupplierName'                               
   ,hsm.SupplierName as 'SupplierName'                              
      ,[SupplierType]                                                  
      ,hsm.[Username]                                                  
      ,hsm.[Password]                            
      ,[CreateDate]                                                   
      ,CASE  WHEN hsm.CreatedBy IS NULL OR hsm.CreatedBy = 0 THEN '' ELSE m.FullName END AS CreatedBy                  
     ,hsm.ModifiedOn as ModifiedOn                                                 
      ,case when hsm.ModifiedBy is null  OR hsm.ModifiedBy=0 then '' else mu.FullName end as ModifiedBy                                                  
      ,hsm.[IsActive]                                                  
                                                        
      ,[SupplierCharges]                                                 
      ,[SupplierName]                                                
      ,[SupplierType]                                                 
                                                 
      ,[FirstName]                                                  
      ,[MiddleName]                                                  
      ,[LastName]                                                  
      ,[Address]                                                  
      ,[Country]                                                  
  ,[City]                                                  
      ,[PinCode]                                          
      ,[MobileNumber]                                                  
      ,[Email]                                                  
      ,[Commission_Net]                                                                            
      ,[Action]                                                  
      ,[IsRiyaAPI]                               
      ,[RhSupplierId]                                                  
      ,[IsGSTRequired]                                                  
      ,[IsPanRequired]                                      
      ,[IsCCRequired]                                                  
      ,[SupportMailId]                                              
      ,[SupplierCurrency]                                                  
      ,[BillingCountry]                                           
      ,[VccCharges]                                                  
      ,[PayAtHotel]                                                  
    ,HCM.CountryName                                
    ,HSM.VirtualBalance                  
 ,case when HSM.Is_Req_Domestic_Pan=1 and HSM.Is_Req_International_Pan=1 then 'Both'                  
 when HSM.Is_Req_Domestic_Pan=1 and HSM.Is_Req_International_Pan=0 then 'Domestic'                  
 when HSM.Is_Req_Domestic_Pan=0 and HSM.Is_Req_International_Pan=1 then 'International'                  
 else '' end as PanCardReq                  
                    
                  
    ,case when HSM.SupplierCurrency=-1 then 'MULTI' else MC.Value                                       
    end                                     
   as 'Currency'                                       
                                        
   ,MU.UserName as 'Usernames'                                            
      ,[SupplierCharges] from B2BHotelSupplierMaster HSM left join Hotel_CountryMaster HCM on HSM.BillingCountry=HCM.CountryCode                                                 
   left join mCommon MC on HSM.SupplierCurrency=MC.ID                                               
   left join mUser MU on HSM.ModifiedBy=MU.ID                   
   left join mUser M on HSM.CreatedBy=M.ID                      
  where  (HSM.Id=@Id or @Id='') and HSM.isdelete=0                                                           
  order by    HSM.SupplierName asc                                           
                                            
                                          
                               
    select                                            
 top 1                                          
      [SupplierName]                                                          
      ,hsm.[ModifiedOn]                                   
   ,MU.UserName as 'Usernames'                                          
   ,MC.Value as 'Currency'                                        
     from B2BHotelSupplierMaster HSM left join Hotel_CountryMaster HCM on HSM.BillingCountry=HCM.CountryCode                                                 
   left join mCommon MC on HSM.SupplierCurrency=MC.ID                                               
   left join mUser MU on HSM.ModifiedBy=MU.ID                                     
  where  (HSM.Id=@Id or @Id='')   and hsm.IsDelete=0                                                               
  order by   HSM.SupplierName desc                                           
                                              
                                              
                                      
  --select  * from B2BHotelSupplierMasterDetails                                      
  --where FKSupplierId=@Id        
 End                                      
                                      
 if(@Action='Delete')                                      
 begin                                      
  update B2BHotelSupplierMaster set ModifiedBy=@ModifiedBy,ModifiedOn=GETDATE(),IsDelete=1,RhSupplierId=null  
  --rhsupplirrid set null as becoz of unique key  
  where Id=@Id                
                
 End                                      
                        
 if(@Action='UpdateAction')                                      
 begin                                      
  UPDATE B2BHotelSupplierMaster      
SET       
    ModifiedBy = @ModifiedBy,      
    ModifiedOn = GETDATE(),      
    Action = CASE       
                WHEN Action = 1 THEN 0      
                WHEN Action = 0 THEN 1      
            END,      
    IsActive = CASE       
                    WHEN Action = 1 THEN 0      
                    WHEN Action = 0 THEN 1      
                END      
WHERE       
    Id = @Id      
       
 end      
                               
      begin                  
                                
 select                   
    [HSM].Id                                                  
   ,hsm.SupplierName as 'SupplierName'                              
      ,[SupplierType]                                                  
      ,hsm.[Username]                                          
      ,hsm.[Password]                                          
      ,[CreateDate]                                                   
      ,CASE  WHEN hsm.CreatedBy IS NULL OR hsm.CreatedBy = 0 THEN '' ELSE MCC.FullName END AS CreatedBy                  
     ,Isnull(hsm.ModifiedOn,'') as ModifiedOn                                                 
      ,case when hsm.ModifiedBy is null  OR hsm.ModifiedBy=0 then '' else MUU.FullName end as ModifiedBy                                                  
      ,hsm.[IsActive]                                                  
                                               
      ,[SupplierCharges]                                                 
      ,[SupplierName]                                                
      ,[SupplierType]                                                  
                                                 
      ,[FirstName]                                                  
      ,[MiddleName]                                                  
      ,[LastName]                                                  
      ,[Address]                                                  
      ,[Country]                                                  
      ,[City]                                                  
      ,[PinCode]                                          
      ,[MobileNumber]                                                  
      ,[Email]                                                  
      ,[Commission_Net]                                                                            
      ,[Action]                                                  
      ,[IsRiyaAPI]                                                 
      ,[RhSupplierId]                                                  
      ,[IsGSTRequired]                                                  
      ,[IsPanRequired]                                      
      ,[IsCCRequired]                                                  
      ,[SupportMailId]                                              
      ,[SupplierCurrency]                                                  
      ,[BillingCountry]                                                  
      ,[VccCharges]                                                  
      ,[PayAtHotel]           
    ,HSM.VirtualBalance                  
                   
  ,case when HSM.Is_Req_Domestic_Pan=1 and HSM.Is_Req_International_Pan=1 then 'Both'                  
 when HSM.Is_Req_Domestic_Pan=1 and HSM.Is_Req_International_Pan=0 then 'Domestic'                  
 when HSM.Is_Req_Domestic_Pan=0 and HSM.Is_Req_International_Pan=1 then 'International'                  
 else '' end as PanCardReq                  
                   
 ,MC.Value as 'Currency'                  
 ,HCM.CountryName                   
 from B2BHotelSupplierMaster HSM                   
 left join Hotel_CountryMaster HCM on HSM.BillingCountry=HCM.CountryCode                                                  
 left join mCommon MC on HSM.SupplierCurrency=MC.ID                    
  left join mUser MCC on HSM.CreatedBy=MCC.ID                                               
   left join mUser MUU on HSM.ModifiedBy=MUU.ID               
   where  hsm.IsDelete=0               
     order by Id desc                            
End                                  
                                  
if(@Action='UpdateAPIRoute')                                                                
 begin                                                                
  update B2BHotelSupplierMaster set IsRiyaAPI = case                                                                 
             when IsRiyaAPI=1 then 0                                                 
             when IsRiyaAPI=0 then 1                                                                
               end                                                                
    where Id=@Id                                                                
                                   
                                      
    select * from B2BHotelSupplierMaster                                       
     where IsActive=1 and IsDelete=0                                  
     order by Id desc                                      
                                      
 End                                      
                                     
end