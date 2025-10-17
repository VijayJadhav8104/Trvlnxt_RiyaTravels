




create proc [dbo].[Get_CountBlockIP]

@IP varchar(50)

as
begin

select  Count(IP) from mastBlockIP where IP = @IP


end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_CountBlockIP] TO [rt_read]
    AS [dbo];

