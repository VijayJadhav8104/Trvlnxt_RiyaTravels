CREATE proc [dbo].[spGetCountry]
as
begin
select  country,A1,A2,1 as roworder from [dbo].[Country] where Country='India'
union 
select  country,A1,A2,2 as roworder from [dbo].[Country] where Country!='India'
order by roworder,Country
end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetCountry] TO [rt_read]
    AS [dbo];

