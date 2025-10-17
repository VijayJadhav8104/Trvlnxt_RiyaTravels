CREATE PROCEDURE  AddRailCommision_Backup_09_10_2025        
  @FKUserID VARCHAR(50)=NULL          
AS          
  BEGIN          
 DECLARE @Fk_SupplierMasterId VARCHAR(20) = 1          
 DECLARE @MarketPoint VARCHAR(20)=(SELECT bookingcountry  FROM   agentlogin WHERE  UserID = @FKUserID)          
 DECLARE @ServiceType VARCHAR(50) = 'Service'            
 DECLARE @UserType VARCHAR(200)=(select UserTypeID from AgentLogin where UserID = @FKUserID)            
 DECLARE @IssuanceFrom DATETIME = GetDate()            
-- DECLARE @IssuanceTo Datetime = dateadd(year, 1, getdate())      
 DECLARE @IssuanceTo DATETIME = DATEFROMPARTS(YEAR(GETDATE()), 12, 31);      
 --DECLARE @IssuanceTo DATETIME = CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-12-31' AS DATETIME);      
 DECLARE @BookingType  VARCHAR(50) = NULL          
 DECLARE @CreadtedBy VARCHAR(30)='1' -- 572                 
 DECLARE @AgentId VARCHAR(50)=(select UserID from AgentLogin where UserID = @FKUserID)         
 DECLARE @bookingfee  decimal(8, 2) = 1.5          
 DECLARE @AgencyName VARCHAR(100)= (SELECT agencyname FROM   b2bregistration WHERE  FKUserID = @FKUserID)          
 DECLARE @authId varchar(200)=0           
         
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
INSERT INTO [Rail].[Agent_ServiceFee_Mapper]          
            (          
                        fk_servicefeeid ,          
                        fk_productlistmasterid ,          
                        currency ,          
                        commission ,          
                        additionamount ,                                
                        createddate ,          
                        createdby          
            )          
            VALUES          
            (          
                        @FK_ServiceFeeId ,          
                        1 ,          
                        'EURO' ,          
                        125 ,          
                        0.00,                                  
                        Getdate() ,          
                        @CreadtedBy          
            )          
        
INSERT INTO [Rail].[Agent_ServiceFee_Mapper]          
            (          
                        fk_servicefeeid ,          
                        fk_productlistmasterid ,          
                        currency ,          
                        commission ,          
                       additionamount,                               
                        createddate ,          
                        createdby          
            )          
            VALUES          
            (          
                        @FK_ServiceFeeId ,          
                        3 ,          
                        'CHF' ,          
      124 ,          
                        0.00 ,                                  
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
                        createddate ,          
                        createdby          
            )          
            VALUES          
            (          
                        @FK_ServiceFeeId ,          
                       4 ,          
                        '' ,          
                        100 ,          
                        0.00 ,                                 
                        getdate() ,          
                        @CreadtedBy          
            )          
END