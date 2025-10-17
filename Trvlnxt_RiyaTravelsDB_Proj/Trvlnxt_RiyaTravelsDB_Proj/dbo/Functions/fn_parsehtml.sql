



CREATE FUNCTION [dbo].[fn_parsehtml]
(
@htmldesc varchar(max)
)
returns varchar(max)
as
begin
declare @first int, @last int,@len int
set @first = CHARINDEX('<',@htmldesc)
set @last = CHARINDEX('>',@htmldesc,CHARINDEX('<',@htmldesc))
set @len = (@last - @first) + 1
while @first > 0 AND @last > 0 AND @len > 0
begin
---Stuff function is used to insert string at given position and delete number of characters specified from original string
set @htmldesc = STUFF(@htmldesc,@first,@len,'')
SET @first = CHARINDEX('<',@htmldesc)
set @last = CHARINDEX('>',@htmldesc,CHARINDEX('<',@htmldesc))
set @len = (@last - @first) + 1
end
return LTRIM(RTRIM(@htmldesc))
end
