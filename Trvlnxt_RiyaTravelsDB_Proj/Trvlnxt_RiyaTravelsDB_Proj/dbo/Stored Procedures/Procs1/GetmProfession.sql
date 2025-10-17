CREATE PROCEDURE GetmProfession
as
begin 
select ProfessionName,ProfessionCode from mProfession
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetmProfession] TO [rt_read]
    AS [dbo];

