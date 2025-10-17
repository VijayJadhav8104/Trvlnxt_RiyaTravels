
      
CREATE PROCEDURE GetROEagainstData      
    @RequiredDate DATETIME='',      
    @OfficeID NVARCHAR(50)='',      
    @apiKey NVARCHAR(100)='',  
 @VendorName NVARCHAR(100)=''    
AS      
BEGIN      
    SET NOCOUNT ON;      
      
    
select  
CASE 
            WHEN CAST(@RequiredDate AS DATE) = CAST(GETDATE() AS DATE) 
                THEN RH.NewROE 
            ELSE RH.OldROE 
			END as ROE
    FROM mROEUpdation r
    INNER JOIN mROEHistoryAir RH ON RH.ROEId = r.ID
    INNER JOIN mVendor v ON v.ID = r.VendorId 
    INNER JOIN mCommon m ON m.ID = r.BaseCurrencyId                            
    INNER JOIN mCommon m1 ON m1.ID = r.ToCurrencyId   
    INNER JOIN mROEAgencyMapping ap ON ap.ROEId = r.ID
    INNER JOIN B2BRegistration B2B ON B2B.PKID = ap.AgencyId
    WHERE v.VendorName = @VendorName  
      AND RH.InsertedDate = @RequiredDate
      AND r.OfficeIdText = @OfficeID 
      AND R.IsActive = 1 
      AND AP.IsActive = 1  
      AND FKUserID = (
            SELECT TOP 1 AgentID 
            FROM APIAuthenticationMaster 
            WHERE APIKey = @apiKey
        );

END;