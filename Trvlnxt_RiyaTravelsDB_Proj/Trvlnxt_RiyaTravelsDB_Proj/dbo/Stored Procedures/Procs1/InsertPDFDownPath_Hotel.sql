
--============================================
--Creaated By Shivkumar Prajapati
--Creation Date: 28/4/2020
--Desc Insert PDF down Path
--
--============================================
CREATE procedure InsertPDFDownPath_Hotel
@PNRNumber nvarchar(50),
@Path nvarchar(max)
as
begin

insert into DownloadHotelVoucher(PNRNumber,DownloadPaths) values(@PNRNumber,@Path)

end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertPDFDownPath_Hotel] TO [rt_read]
    AS [dbo];

