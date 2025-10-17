CREATE proc UpdateVendor --'UpdateVendor 'FSC','14368782','','RT20181114123654811''

@AirlineType nvarchar(50)
,@IATA NVarchar(50)
,@AirlineCode nchar(5)
,@Order_Id nvarchar(50)

As
BEGIN
	
	--==Declare Veriable
	Declare @Vendor_No nvarchar(50)
	declare @IATAold nvarchar(50)
	set @IATAold=''

	select top 1 @IATAold=IATA from tblBookMaster where orderId=@Order_Id

	if(@IATAold is null)
	begin
	select @Vendor_No=Vendor_No from VendorMaster where IATA=@IATA and AirlineType=@AirlineType
	
	UPDATE tblBookMaster SET Vendor_No=@Vendor_No,IATA=@IATA where orderId=@Order_Id and (@AirlineCode='' and airCode not in ('SG','G8','6E') or ( airCode=@AirlineCode)) 
	end
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[UpdateVendor] TO [rt_read]
    AS [dbo];

