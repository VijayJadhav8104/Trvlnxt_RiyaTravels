CREATE PROCEDURE [dbo].[SelectAirlines]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
--	SELECT  * 
--FROM 
--        (SELECT _name as AirlineName,_code as AirlineCode FROM AirlinesName 
--union all
--select case  AirlineCode
--when 'SG' then 'Spicejet' 
--when '6E' then 'Indigo'
--when 'G8' then 'Go Air' 
--when 'OV' then 'Salam Air'
--end as AirlineName,AirlineCode as AirlineCode
--from AirlineCode_Console where type='LCC') P 
--order by AirlineName

select _name as AirlineName,_code as AirlineCode 
from AirlineCode_Console a 
inner join AirlinesName b on a.AirlineCode=b._CODE
where type='LCC' 
order by b._NAME

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SelectAirlines] TO [rt_read]
    AS [dbo];

