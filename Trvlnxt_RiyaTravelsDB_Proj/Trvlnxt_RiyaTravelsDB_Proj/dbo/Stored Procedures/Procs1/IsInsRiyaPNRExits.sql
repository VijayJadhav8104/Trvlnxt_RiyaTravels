CREATE PROC [dbo].[IsInsRiyaPNRExits]
@RiyaPNR varchar(10) = null
As 
Begin 
if exists(select pkid from tblinsBookmaster where RiyaPNR=@RiyaPNR)
begin
select 1 as riyaPNRcount 
end
else
begin
select 0 as riyaPNRcount
END

end