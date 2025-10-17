
-- =============================================
-- Author:		bhavika kawa
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetFareTypeById]
	@FareTypeId varchar(max)
AS
BEGIN
	if(@FareTypeId!='')
	begin
		select ID,FareName,FareType 
		from mFareTypeByAirline
		where ID in (SELECT Data FROM sample_split((@FareTypeId), ','))
	end
	else
	begin
	select ID,FareName,FareType 
		from mFareTypeByAirline
	end
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetFareTypeById] TO [rt_read]
    AS [dbo];

