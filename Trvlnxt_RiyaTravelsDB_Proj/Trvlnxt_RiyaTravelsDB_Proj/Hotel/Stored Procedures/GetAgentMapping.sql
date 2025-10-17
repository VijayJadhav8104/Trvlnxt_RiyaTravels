CREATE PROCEDURE hotel.GetAgentMapping      
    -- @AgentId NVARCHAR(MAX),       
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
    IF (@RhAgent = 0)    
    BEGIN    
        SELECT    
            BR.PKID,     
            BR.AgencyName,    
            sm.SupplierName AS SupplierId,    
            PP.ProfileName AS ProfileId,    
            GETDATE() AS CreateDate,    
            1 AS IsActive,    
            @servicecharge AS Servicecharge,    
            @GstOnServiceCharge AS GSTOnServiceCharge,    
            @LeadHrs AS CancellationHours,
			@Pcc as 'OfficeId',
            mu.FullName AS Createdby    
        FROM B2BRegistration BR    
        LEFT JOIN agentLogin AL ON BR.FKUserID = AL.UserID     
        LEFT JOIN mCommon Mc ON AL.userTypeID = Mc.ID   
        LEFT JOIN mUser mu ON mu.id = @Insertedby
        LEFT JOIN B2BHotelSupplierMaster SM ON sm.Id = @supplier
        LEFT JOIN PricingProfile PP ON PP.Id = @pricingProfile
        WHERE BR.PKID NOT IN (SELECT DISTINCT AgentId FROM AgentSupplierProfileMapper WHERE SupplierId = @supplier)     
        AND Mc.ID = @Usertype     
        AND  BR.country IN (SELECT Value FROM STRING_SPLIT(@country, ','))
    END    
    ELSE IF (@RhAgent = 1)    
    BEGIN       
        SELECT    
            BR.PKID,     
            BR.AgencyName,    
            sm.SupplierName AS SupplierId,    
            PP.ProfileName AS ProfileId,
			@LeadHrs AS CancellationHours,
            @servicecharge AS Servicecharge,    
            @GstOnServiceCharge AS GSTOnServiceCharge,    
			GETDATE() AS CreateDate,    
             1 AS IsActive,  
			 @Pcc as 'OfficeId',
            mu.FullName AS Createdby    
        FROM B2BRegistration BR    
        LEFT JOIN agentLogin AL ON BR.FKUserID = AL.UserID     
        LEFT JOIN mCommon Mc ON AL.userTypeID = Mc.ID   
        LEFT JOIN mUser mu ON mu.id = @Insertedby
        LEFT JOIN B2BHotelSupplierMaster SM ON sm.Id = @supplier
        LEFT JOIN PricingProfile PP ON PP.Id = @pricingProfile
        WHERE BR.PKID NOT IN (SELECT DISTINCT AgentId FROM AgentSupplierProfileMapper WHERE SupplierId = @supplier)     
        AND Mc.ID = 2 
        AND BR.AgencyName LIKE '%RH %'     
        AND BR.PKID IN (23265, 23262, 23272, 23271, 23263, 3809, 23269, 23273, 23268, 23270, 23264, 23267, 48053, 23266)    
        AND BR.country = 'India'    
    END    
END;
