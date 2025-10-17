CREATE PROCEDURE [SS].[PanCardApproved]    
    @Pkid INT,    
    @PanCardName VARCHAR(500),    
    @PancardStatus VARCHAR(100),    
    @PanCardNo  VARCHAR(500),    
    @ModifiedBy INT    
AS    
BEGIN    
    -- Update CorporatePANVerificatioStatus for both Approved and Rejected statuses
    UPDATE Ss.SS_BookingMaster  
    SET CorporatePANVerificatioStatus = @PancardStatus  
    WHERE BookingId = @Pkid;

    -- If status is 'Approved', update Pancard details for LeadPax
    IF @PancardStatus = 'Approved'  
    BEGIN    
        UPDATE SS.SS_PaxDetails  
        SET PanCardNo = @PanCardNo, PanCardName = @PanCardName  
        WHERE BookingId = @Pkid AND LeadPax = 1;
    END    

    -- Insert into BookingUpdate_History for both Approved and Rejected statuses
    INSERT INTO [SS].[BookingUpdate_History] (fkbookid, FieldName, FieldValue, InsertedDate, InsertedBy, UpdatedType)    
    VALUES (@Pkid, 'Corporate Pan Verification', @PanCardName + ',' + @PanCardNo, GETDATE(), @ModifiedBy, 'PanVerification');    
END    
