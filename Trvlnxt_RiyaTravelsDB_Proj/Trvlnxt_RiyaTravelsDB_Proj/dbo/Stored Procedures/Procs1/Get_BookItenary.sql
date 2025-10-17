  
CREATE proc Get_BookItenary  
@GDSPNR varchar(10)  
As  
begin  
  
select BI.*,BM.VendorName
from tblBookItenary as BI inner join tblBookMaster as BM on BI.orderId = BM.orderId
where BM.GDSPNR = @GDSPNR  
  
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_BookItenary] TO [rt_read]
    AS [dbo];

