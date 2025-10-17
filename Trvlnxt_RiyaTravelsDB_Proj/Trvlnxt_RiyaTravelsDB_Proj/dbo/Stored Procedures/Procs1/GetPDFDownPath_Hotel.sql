--============================================
--Creaated By Shivkumar Prajapati
--Creation Date: 28/4/2020
--Desc Select PDF down Path
-- GetPDFDownPath_Hotel '6S5X5I',''
--============================================
CREATE procedure GetPDFDownPath_Hotel
@PNRNumber nvarchar(50)=null

as
begin


if(@PNRNumber !='')
	begin
		 select DownloadPaths from  DownloadHotelVoucher where PNRNumber=@PNRNumber
	end

end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPDFDownPath_Hotel] TO [rt_read]
    AS [dbo];

