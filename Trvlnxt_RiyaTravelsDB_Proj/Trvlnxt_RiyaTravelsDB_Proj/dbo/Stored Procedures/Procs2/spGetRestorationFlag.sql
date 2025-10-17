
CREATE proc [dbo].[spGetRestorationFlag]
as
begin
  select 0
end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetRestorationFlag] TO [rt_read]
    AS [dbo];

