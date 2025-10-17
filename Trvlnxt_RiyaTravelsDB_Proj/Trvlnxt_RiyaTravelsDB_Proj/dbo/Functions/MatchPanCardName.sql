  
CREATE FUNCTION [dbo].[MatchPanCardName](  
    @passengerName NVARCHAR(255),   
    @panCardName NVARCHAR(255),   
    @minMatchingWords INT  
)  
RETURNS BIT  
AS  
BEGIN  
    DECLARE @matchCount INT = 0;  
 DECLARE @ReturnType BIT;  
      
    -- Split passenger name into words  
    DECLARE @passengerWords TABLE (word NVARCHAR(255));  
    INSERT INTO @passengerWords (word)  
    SELECT item FROM dbo.SplitString(@passengerName, ' ');  
  
    -- Split PAN card name into words  
    DECLARE @panCardWords TABLE (word NVARCHAR(255));  
    INSERT INTO @panCardWords (word)  
    SELECT item FROM dbo.SplitString(@panCardName, ' ');  
  
    -- Compare words and count matches  
    SELECT @matchCount = COUNT(DISTINCT pw.word)  
    FROM @passengerWords pw  
    JOIN @panCardWords pcw ON LOWER(pw.word) = LOWER(pcw.word);  
  
    -- Return true (1) if matches are equal or greater than minMatchingWords  
    IF @matchCount >= @minMatchingWords  
        SET @ReturnType= 1; -- True    
    ELSE  
        SET @ReturnType= 0; -- False   
 RETURN @ReturnType  
END;   
  
--SELECT dbo.MatchPanCardName('RANJIT RAMSUNDER', 'RANJIT RAMSUNDER JAISWAR', 2);  
--MatchPanCardName 'RANJIT RAMSUNDER','RANJIT RAMSUNDER JAISWAR',2  