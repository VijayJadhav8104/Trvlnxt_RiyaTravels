CREATE PROCEDURE Sp_LoginHistory    
    @EmpCode VARCHAR(50),    
    @AgentId VARCHAR(50)  
AS    
BEGIN    
    DECLARE @EmpNo INT;  
    DECLARE @Agent INT;  
    DECLARE @ReturnedID INT;  
    DECLARE @EmpCodemuser INT;
    DECLARE @DateLogin DATE;
  
    -- Get the EmployeeNo from mUser
    SET @EmpCodemuser = (SELECT TOP 1 EmployeeNo FROM mUser WHERE ID = @EmpCode);  
    
    -- Check if the EmpCode or AgentId already exists in InvoicesLoginAudit
    SET @EmpNo = (SELECT TOP 1 EmpCode FROM InvoicesLoginAudit WHERE EmpCode = @EmpCodemuser);  
    SET @Agent = (SELECT TOP 1 AgentId FROM InvoicesLoginAudit WHERE AgentId = @AgentId); 
    SET @DateLogin = (SELECT TOP 1 LoginDate FROM InvoicesLoginAudit WHERE AgentId = @AgentId);

    -- If both AgentId and DateLogin exist, compare the LoginDate with today's date
    IF (@Agent IS NOT NULL AND @DateLogin IS NOT NULL)  
    BEGIN
        -- If the date is the same as today's date, update the record
        IF (CONVERT(DATE, @DateLogin) = CONVERT(DATE, GETDATE()))  
        BEGIN  
            UPDATE InvoicesLoginAudit   
            SET LoginDate = GETDATE()   
            WHERE AgentId = @AgentId;  
  
            -- Return the updated AgentId
            SET @ReturnedID = (SELECT TOP 1 ID FROM InvoicesLoginAudit WHERE AgentId = @AgentId);  
        END  
        ELSE  
        BEGIN  
            -- Insert a new record since the dates don't match
            INSERT INTO InvoicesLoginAudit (EmpCode, AgentId, LoginDate)    
            VALUES (@EmpCodemuser, @AgentId, GETDATE());  
  
            -- Return the newly inserted ID
            SET @ReturnedID = SCOPE_IDENTITY();  
        END  
    END  
    -- If EmpCode exists and DateLogin exists, check the date
    ELSE IF (@EmpNo IS NOT NULL AND @DateLogin IS NOT NULL)  
    BEGIN  
        IF (CONVERT(DATE, @DateLogin) = CONVERT(DATE, GETDATE()))  
        BEGIN  
            UPDATE InvoicesLoginAudit   
            SET LoginDate = GETDATE()   
            WHERE EmpCode = @EmpCodemuser;  
  
            -- Return the updated EmpCode
            SET @ReturnedID = (SELECT TOP 1 ID FROM InvoicesLoginAudit WHERE EmpCode = @EmpCodemuser);  
        END  
        ELSE  
        BEGIN  
            -- Insert a new record since the dates don't match
            INSERT INTO InvoicesLoginAudit (EmpCode, AgentId, LoginDate)    
            VALUES (@EmpCodemuser, @AgentId, GETDATE());  
  
            -- Return the newly inserted ID
            SET @ReturnedID = SCOPE_IDENTITY();  
        END  
    END  
    ELSE  
    BEGIN   
        -- Insert a new record if neither AgentId nor EmpCode exist
        INSERT INTO InvoicesLoginAudit (EmpCode, AgentId, LoginDate)    
        VALUES (@EmpCodemuser, @AgentId, GETDATE());  
  
        -- Return the newly inserted ID
        SET @ReturnedID = SCOPE_IDENTITY();  
    END  
  
    -- Select the returned ID  
    SELECT @ReturnedID AS InsertedOrUpdatedID;  
END;
