---------- -----------------------------------------------------------                  
                  
-- [Created By : Aman W]                  
-- [Created Date:04 sep 2024]                  
-- [Created for : Multiple agent supplier pricing profile mapping ]                  
                  
----------------------------------------------------                  
              
-- EXEC [Hotel].[MapAgentSupplier_new]  @Usertype=2, @country='UAE,Canada,USA',@supplier=61,@pricingProfile=34,@servicecharge=1,@GstOnServiceCharge=18,@LeadHrs=48,@Pcc='',@Insertedby=1195,@RhAgent=0            
--------------------------------------------------r------                  
CREATE PROCEDURE [Hotel].[MapAgentSupplier_new]          
    @Usertype INT = 0,                  
    @country VARCHAR(100) = '',                  
    @supplier INT = 0,                  
    @pricingProfile INT = 0,                  
    @servicecharge INT = 0,                  
    @GstOnServiceCharge INT = 0,                  
    @LeadHrs INT = 0,                  
    @Pcc NVARCHAR(500) = '',                  
    @Insertedby INT = 0,                
    @RhAgent BIT = 0                
AS          
BEGIN          
    -- Handle case when RhAgent is 0          
    IF (@RhAgent = 0)          
    BEGIN          
        -- Case for country 'India'        
        IF (@country like '%India%')          
        BEGIN          
            INSERT INTO AgentSupplierProfileMapper           
            --(AgentId, SupplierId, ProfileId, CreateDate, IsActive, Servicecharge, GSTOnServiceCharge, CancellationHours, Createdby)  //changes as per gary suggest service charge to amt   
   (AgentId, SupplierId, ProfileId, CreateDate, IsActive, ServiceChargeAmt, GSTOnServiceCharge, CancellationHours, Createdby)    
                      
            SELECT           
                BR.PKID,          
                @supplier AS SupplierId,          
                @pricingProfile AS ProfileId,          
                GETDATE() AS CreateDate,          
                1 AS IsActive,          
                @servicecharge AS ServiceChargeAmt,          
                @GstOnServiceCharge AS GSTOnServiceCharge,          
                @LeadHrs AS CancellationHours,          
                @Insertedby AS Createdby          
            FROM B2BRegistration BR          
            LEFT JOIN agentLogin AL ON BR.FKUserID = AL.UserID          
            LEFT JOIN mCommon MC ON AL.userTypeID = MC.ID          
            WHERE BR.PKID NOT IN (          
                SELECT DISTINCT AgentId           
                FROM AgentSupplierProfileMapper           
                WHERE SupplierId = @supplier          
            )          
            AND MC.ID = @Usertype          
            AND BR.country = 'India';          
        END          
        -- Case for comma-separated countries (excluding 'India')        
        ELSE          
        BEGIN          
            INSERT INTO AgentSupplierProfileMapper           
            --(AgentId, SupplierId, ProfileId, CreateDate, IsActive, Servicecharge, GSTOnServiceCharge, CancellationHours, Createdby)  //changes as per gary suggest service charge to amt   
    (AgentId, SupplierId, ProfileId, CreateDate, IsActive, ServiceChargeAmt, GSTOnServiceCharge, CancellationHours, Createdby)    
    
                      
            SELECT           
                BR.PKID,          
                @supplier AS SupplierId,          
                @pricingProfile AS ProfileId,          
                GETDATE() AS CreateDate,          
                1 AS IsActive,          
                @servicecharge AS ServiceChargeAmt,          
                @GstOnServiceCharge AS GSTOnServiceCharge,          
                @LeadHrs AS CancellationHours,          
                @Insertedby AS Createdby          
            FROM B2BRegistration BR          
            LEFT JOIN agentLogin AL ON BR.FKUserID = AL.UserID          
            LEFT JOIN mCommon MC ON AL.userTypeID = MC.ID    
            WHERE BR.PKID NOT IN (          
                SELECT DISTINCT AgentId           
                FROM AgentSupplierProfileMapper           
                WHERE SupplierId = @supplier          
            )          
            AND MC.ID = @Usertype          
            
   and( (@country ='') or (BR.country IN  (select Data from sample_split(@country,','))))         
            --AND EXISTS (SELECT 1 FROM dbo.SplitString(@country, ',') WHERE RTRIM(LTRIM(Value)) = RTRIM(LTRIM(BR.country)));          
        END          
    END          
    -- Handle case when RhAgent is 1          
    ELSE IF (@RhAgent = 1)          
    BEGIN          
        INSERT INTO AgentSupplierProfileMapper           
        --(AgentId, SupplierId, ProfileId, CreateDate, IsActive, Servicecharge, GSTOnServiceCharge, CancellationHours, Createdby) //changes as per gary suggest service charge to amt   
  (AgentId, SupplierId, ProfileId, CreateDate, IsActive, ServiceChargeAmt, GSTOnServiceCharge, CancellationHours, Createdby)    
      
                  
        SELECT           
    BR.PKID,          
            @supplier AS SupplierId,          
            @pricingProfile AS ProfileId,          
            GETDATE() AS CreateDate,          
            1 AS IsActive,          
            @servicecharge AS ServiceChargeAmt,          
            @GstOnServiceCharge AS GSTOnServiceCharge,          
            @LeadHrs AS CancellationHours,          
            @Insertedby AS Createdby          
        FROM B2BRegistration BR          
        LEFT JOIN agentLogin AL ON BR.FKUserID = AL.UserID          
        LEFT JOIN mCommon MC ON AL.userTypeID = MC.ID          
        WHERE BR.PKID NOT IN (          
            SELECT DISTINCT AgentId           
            FROM AgentSupplierProfileMapper           
            WHERE SupplierId = @supplier          
        )          
        AND MC.ID = 2           
        AND BR.AgencyName LIKE '%RH %'          
        AND BR.PKID IN (23265, 23262, 23272, 23271, 23263, 3809, 23269, 23273, 23268, 23270, 23264, 23267, 48053, 23266)          
        AND BR.country = 'India';          
    END          
END;        