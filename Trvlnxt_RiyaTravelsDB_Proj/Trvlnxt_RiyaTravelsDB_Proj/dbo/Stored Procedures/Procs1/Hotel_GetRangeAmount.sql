--================================================
--Created by : Shivkumar Prajapati
--Creation Date :28/11/2019
--
--exec [dbo].[Hotel_GetRangeAmount] '','',''
--================================================
CREATE PROCEDURE [dbo].[Hotel_GetRangeAmount]
@From INT,
--@To int,
@Vendorname varchar(500),
@currency varchar(50)

AS
BEGIN

IF EXISTS(SELECT TOP 1 * FROM tblVendor WHERE VendorName=@Vendorname)

BEGIN 

	select * from HotelDiscountDetails ht inner join tblVendor vv on ht.VendorId = vv.Id
	where @From between FromRange and ToRange  and vv.VendorName= @Vendorname and ht.txtCurrency=@currency and IsActive is null or IsActive=0
--and VendorId=1

END
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Hotel_GetRangeAmount] TO [rt_read]
    AS [dbo];

