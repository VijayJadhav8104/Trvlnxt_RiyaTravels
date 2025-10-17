CREATE FUNCTION [dbo].[fn_split](  
@delimited NVARCHAR(MAX),  
@delimiter NVARCHAR(MAX)  
) RETURNS @table TABLE (id INT IDENTITY(1,1), [value] NVARCHAR(MAX))  
AS  
BEGIN  
DECLARE @xml XML  
SET @xml = N'<t>' + REPLACE(@delimited,@delimiter,'</t><t>') + '</t>'  
INSERT INTO @table([value])  
SELECT r.value('.','Nvarchar(MAX)') as item  
FROM @xml.nodes('/t') as records(r)  
RETURN  
END  
