CREATE PROCEDURE [dbo].[GetAirline_AutoComplete]
@Key varchar(50)

AS BEGIN

SELECT TOP 5 [_NAME], [_CODE] INTO #TMPAR FROM AirlinesName WHERE _CODE LIKE '%'+@Key+'%'

INSERT INTO #TMPAR ([_NAME], [_CODE])
(
SELECT TOP 15 RTRIM([_NAME]) as [_NAME], RTRIM([_CODE]) as [_CODE] FROM AirlinesName WHERE [_NAME] LIKE ''+@Key+'%')
ORDER BY _NAME 

SELECT * FROM #TMPAR
   --			GetAirline_AutoComplete 'AC'
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAirline_AutoComplete] TO [rt_read]
    AS [dbo];

