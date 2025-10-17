
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FetchItineraryInfo]
	-- Add the parameters for the stored procedure here\
	@passengerid varchar(50)= null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT b.pid,a.frmsector,a.tosector,a.fromairport,a.toairport,a.depDate,cast(a.deptTime as time(0))[deptTime],a.arrivalDate,cast(a.arrivalTime as time(0))[arrivalTime],a.riyaPNR,b.airPNR,bi.farebasis
	--(select top 1 farebasis from tblBookItenary where fkBookMaster=a.pkid) as farebasis
	,left (REPLACE(TicketNum,'pax','' ),15) TicketNum
	from tblBookMaster a
	inner join tblPassengerBookDetails b
	on a.pkid=b.fkBookMaster
	join tblBookItenary bi on a.pkId=bi.fkBookMaster 
	where b.pid=@passengerid
	
END









GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchItineraryInfo] TO [rt_read]
    AS [dbo];

