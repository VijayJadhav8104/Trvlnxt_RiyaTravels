CREATE PROCEDURE  AddRailCommision      
  @FKUserID VARCHAR(50)=NULL        
AS        
  BEGIN        
 DECLARE @Fk_SupplierMasterId VARCHAR(20) = 1        
 DECLARE @MarketPoint VARCHAR(20)=(SELECT bookingcountry  FROM   agentlogin WHERE  UserID = @FKUserID)        
 DECLARE @ServiceType VARCHAR(50) = 'Service'          
 DECLARE @UserType VARCHAR(200)=(select UserTypeID from AgentLogin where UserID = @FKUserID)          
 DECLARE @IssuanceFrom DATETIME = GetDate()          
 DECLARE @IssuanceTo DATETIME = DATEFROMPARTS(YEAR(GETDATE()), 12, 31);    
 --DECLARE @IssuanceTo Datetime = dateadd(year, 1, getdate())        
 DECLARE @BookingType  VARCHAR(50) = NULL        
 DECLARE @CreadtedBy VARCHAR(30)='1' -- 572               
 DECLARE @AgentId VARCHAR(50)=(select UserID from AgentLogin where UserID = @FKUserID)       
 DECLARE @bookingfee  decimal(8, 2) =(SELECT BookingFees FROM [Rail].[AgentCurrencyBookingFees] WHERE AgentCurrency LIKE '%' + @MarketPoint + '%')        
 DECLARE @MarginBookingFees DECIMAL(8, 2)=1.5       
 DECLARE @TaxonMargin       DECIMAL(8, 2)= 18        
 DECLARE @AgencyName VARCHAR(100)= (SELECT agencyname FROM   b2bregistration WHERE  FKUserID = @FKUserID)        
 DECLARE @authId varchar(200)=0          
  -------------------------------------------------------------------------------------Markup---------------------------------------------     
 INSERT INTO [Rail].[tbl_ServiceFee] (MarketPoint      
 ,UserType        
 ,IssuanceFrom       
 ,IssuanceTo         
 ,BookingType         
 ,ServiceType        
 ,createddate         
 ,isactive         
 ,createdby        
 ,fk_suppliermasterid         
 ,bookingfee         
 ,mark_up_on_booking_fees         
 ,tax_on_booking_fees         
 ,agencyname         
 ,agentid )       
 VALUES         
 ( @MarketPoint       
 ,@UserType       
 ,@IssuanceFrom       
 ,@IssuanceTo       
 ,@BookingType       
 ,@ServiceType       
 ,getdate()         
 ,1       
 ,@CreadtedBy       
 ,@Fk_suppliermasterid       
 ,@BookingFee       
 ,@MarginBookingFees       
 ,@TaxonMargin       
 ,@AgencyName       
 ,@AgentId )        
SET @authId = Scope_identity();      
      
      
INSERT INTO [Rail].[Service_AgentMapping]        
            (        
                        agentid ,        
                        serviceid        
            )        
            VALUES        
            (        
                        @AgentId ,        
                        @authId        
            )        
      
      
DECLARE @FK_ServiceFeeId INT = @authId        
DECLARE @AdditionAmount  DECIMAL(8, 2) = 0        
DECLARE @GST_on_base_Commission DECIMAL(8, 2) = 0       
DECLARE @TDS_on_Part_commission DECIMAL(8, 2) = 0      
      
INSERT INTO [Rail].[Agent_ServiceFee_Mapper]        
            (        
                        fk_servicefeeid ,        
                        fk_productlistmasterid ,        
                        currency ,        
                        commission ,        
                        additionamount ,        
                        gst_on_base_commission ,        
                        tds_on_part_commission ,        
                        createddate ,        
                        createdby        
            )        
            VALUES        
            (        
                        @FK_ServiceFeeId ,        
                        1 ,        
                        'EURO' ,        
                        125,        
                        @AdditionAmount ,        
                        @GST_on_base_Commission ,        
                        @TDS_on_Part_commission ,        
                        Getdate() ,        
                        @CreadtedBy        
            )        
      
INSERT INTO [Rail].[Agent_ServiceFee_Mapper]        
            (        
                        fk_servicefeeid ,        
                        fk_productlistmasterid ,        
                        currency ,        
                        commission ,        
                        additionamount ,        
                    gst_on_base_commission ,        
                        tds_on_part_commission ,        
                        createddate ,        
                        createdby        
            )        
            VALUES        
            (        
                        @FK_ServiceFeeId ,        
                        3 ,        
                        'CHF' ,        
                        124 ,        
                        @AdditionAmount ,        
                        @GST_on_base_Commission ,        
                        @TDS_on_Part_commission ,        
                        Getdate() ,        
                        @CreadtedBy        
            )        
      
INSERT INTO [Rail].[Agent_ServiceFee_Mapper]        
            (        
                        fk_servicefeeid ,        
                        fk_productlistmasterid ,        
                        currency ,        
                        commission ,        
                        additionamount ,        
                        gst_on_base_commission ,        
                        tds_on_part_commission ,        
                        createddate ,        
                        createdby        
            )        
            VALUES        
            (        
                        @FK_ServiceFeeId ,        
                        4 ,        
                        '' ,        
                        100 ,        
                        @AdditionAmount ,        
                        @GST_on_base_Commission ,        
                        @TDS_on_Part_commission ,        
                        getdate() ,        
                        @CreadtedBy        
            )    
     
  
----------------------------------------------------------------------------------servicefees-------------------------------------------------------------------------------------------  
-- DECLARE @BookingType  VARCHAR(50) = NULL      
-- DECLARE @BookingFee    VARCHAR(50) = NULL        
DECLARE @ServiceTypes VARCHAR(50) = 'ServiceFees'          
DECLARE @GSTServiceFees  DECIMAL(8, 2) = 0        
DECLARE @authIds varchar(200)=0    
INSERT INTO [Rail].[tbl_ServiceFeeNew] (                
   MarketPoint                
   ,UserType                
   ,IssuanceFrom                
   ,IssuanceTo                     
   ,ServiceType                
   ,CreatedDate                
   ,isActive                
   ,CreatedBy                
   ,Fk_SupplierMasterId          
   ,ServiceFeesType        
   ,FixedServiceFeesAmt    
   ,GSTServiceFees    
   ,AgencyName                
   ,AgentId                
   )                
  VALUES (                
   @MarketPoint                
   ,@UserType                
   ,@IssuanceFrom                
   ,@IssuanceTo                      
   ,@ServiceTypes                
   ,getDate()                
   ,1                
   ,@CreadtedBy                
   ,@Fk_SupplierMasterId        
   ,'PerBooking'        
   ,0.00  
   ,@GSTServiceFees    
   ,@AgencyName                
   ,@AgentId                
   )                
  
  SET @authIds = SCOPE_IDENTITY();  
----------------------------------------------------------------  
  INSERT INTO [Rail].[Service_AgentMappingNew]        
            (        
                        agentid ,        
                        serviceid        
            )        
            VALUES        
            (        
                        @AgentId ,        
                        @authIds        
            )    
----------------------------------------------------------------  
DECLARE @FK_ServiceFeeIds INT = @authIds        
DECLARE @ServiceFees   DECIMAL(8, 2) = 0.00        
DECLARE @ServiceFeesParcent    DECIMAL(8, 2) = 0.00        
DECLARE @Gst_on_Service_Fees   DECIMAL(8, 2) = 0.00        
  
 INSERT INTO [Rail].[Agent_ServiceFee_MapperNew] (            
   FK_ServiceFeeId            
   ,Fk_ProductListMasterId            
   ,ServiceFees    
   ,ServiceFeesParcent    
   ,Gst_on_Service_Fees    
   ,CreatedDate      
   ,CreatedBy            
   )            
  VALUES (            
   @FK_ServiceFeeIds            
   ,1          
   ,@ServiceFees    
   ,@ServiceFeesParcent    
  , @Gst_on_Service_Fees    
   ,getDate()            
   ,@CreadtedBy            
   )         
   -------  
    INSERT INTO [Rail].[Agent_ServiceFee_MapperNew] (            
   FK_ServiceFeeId            
   ,Fk_ProductListMasterId            
   ,ServiceFees    
   ,ServiceFeesParcent    
   ,Gst_on_Service_Fees    
   ,CreatedDate            
   ,CreatedBy            
   )            
  VALUES (            
   @FK_ServiceFeeIds            
   ,3            
   ,@ServiceFees    
   ,@ServiceFeesParcent    
  , @Gst_on_Service_Fees    
   ,getDate()            
   ,@CreadtedBy            
   )   
   -----  
    INSERT INTO [Rail].[Agent_ServiceFee_MapperNew] (            
   FK_ServiceFeeId            
   ,Fk_ProductListMasterId            
   ,ServiceFees    
   ,ServiceFeesParcent    
   ,Gst_on_Service_Fees    
   ,CreatedDate            
   ,CreatedBy            
   )            
  VALUES (            
   @FK_ServiceFeeIds            
   ,4            
   ,@ServiceFees    
   ,@ServiceFeesParcent    
  , @Gst_on_Service_Fees    
   ,getDate()            
   ,@CreadtedBy            
   )   
END