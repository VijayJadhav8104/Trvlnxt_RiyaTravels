


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getPlan] 
    -- Add the parameters for the stored procedure here
    @ID INT = 0,
    @planID INT = 1,
    @planName VARCHAR(100) = NULL,
    @updatedDate DATETIME = NULL,
    @InsurerName VARCHAR(15) = NULL,
    @Errortext VARCHAR(MAX) = NULL,
    @flag VARCHAR(20)
AS
BEGIN
    DECLARE @plantype VARCHAR(20); -- Define the data type for @plantype
    
    -- Handle different flags
    IF (@flag = 'DELETE')
    BEGIN    
        TRUNCATE TABLE Ins_planName; 
    END
    ELSE IF (@flag = 'INSERT')
    BEGIN
        -- Determine the plan type based on @planName
        IF (@planName LIKE '%per trip limit of%' OR @planName IN ('Corporate Elite Lite', 'Corporate Elite Plus'))
        BEGIN
            SET @plantype = 'Annual';
        END
        ELSE IF (@planName LIKE '%family%')
        BEGIN
            SET @plantype = 'Family';
        END
        ELSE IF (@planName LIKE '%student%')
        BEGIN
            SET @plantype = 'Student';
        END
        ELSE 
        BEGIN
            SET @plantype = 'Individual';
        END

        -- Insert a new plan name record
        INSERT INTO Ins_planName (planID, planName, updatedDate, InsurerName, planType)      
        VALUES (@planID, @planName, GETDATE(), @InsurerName, @plantype);   
    END
    ELSE IF (@flag = 'GET')
    BEGIN
        -- Return all plan IDs and names
        SELECT planID, planName FROM Ins_planName;
    END
END
