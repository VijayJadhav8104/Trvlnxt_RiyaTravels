
--select [dbo].[udf_GetNumericPNRaccounting] ('18 Kilograms 19D')
CREATE FUNCTION [dbo].[udf_GetNumericPNRaccounting]
(@strAlphaNumeric VARCHAR(256))
RETURNS VARCHAR(256)
AS
BEGIN

Declare @s varchar(100),@result varchar(100)
    set @s=@strAlphaNumeric 
	set @s=lEFT(@s,LEN(@s) -2 ) 

    set @result=''

    select
        @result=@result+
                case when number like '[0-9]' then number else '+' end from 
        (
             select substring(@s,number,1) as number from 
            (
                select number from master..spt_values 
                where type='p' and number between 1 and len(@s)
            ) as t
        ) as t 
	declare @b nvarchar(max)='select sum('+@result+')'

	--DECLARE @nReturn int = 0
--exec @nReturn=sp_executesql  @b
	RETURN  @result 
END
