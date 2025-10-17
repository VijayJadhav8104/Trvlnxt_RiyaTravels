-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Hotel].[sp_insertHotelPNR]
	@Request varchar(MAX)=null,
	@Response varchar(MAX)=null,
	@MethodName varchar(100)=null,
	@PNR nvarchar(MAX) = null
	AS
	BEGIN
	if exists(select pnr from [AllAppLogs].[Hotel].[PNRRetriveLogsHotel] where pnr = @PNR)
	begin
	update [AllAppLogs].[Hotel].[PNRRetriveLogsHotel] set 
	request = @Request,
	response = @Response,
	pnr = @PNR,
	MethodName = @MethodName
	where pnr = @PNR
	end
	else
	begin
	insert into [AllAppLogs].[Hotel].[PNRRetriveLogsHotel] (request,response,pnr,MethodName) values(@Request,@Response,@PNR,@MethodName)
	end
END
