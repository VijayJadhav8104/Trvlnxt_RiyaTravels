CREATE proc [dbo].[isPNRDetailsExist] -- isPNRDetailsExist O86N96
@GDSPNR varchar(20)

As
BEGIN

select top 1 p.OrderID,b.RiyaPNR from PNRRetriveDetails p  join tblBookMaster b on p.GDSPNR=b.GDSPNR  where p.GDSPNR=@GDSPNR order by b.pkid  desc

END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[isPNRDetailsExist] TO [rt_read]
    AS [dbo];

