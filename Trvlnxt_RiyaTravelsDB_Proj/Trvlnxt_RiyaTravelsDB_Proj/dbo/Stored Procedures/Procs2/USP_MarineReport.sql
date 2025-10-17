-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  USP_MarineReport 
	 
AS
BEGIN
	 
	select  REPLACE(CONVERT(VARCHAR(12), b.inserteddate,6),' ','-') as 'Booking Date',
	(case when  b.BookedBy>0 then (select isnull(a.FirstName,'') +' '+isnull(a.LastName,'') from AgentLogin a where a.UserID=b.BookedBy)
	else '' end) AS 'Booked by'
	,(pb.paxFName +' '+pb.paxLName) as 'Name As Per Passport',
	STUFF((SELECT '/' + s.frmSector+ ('-')+s.toSector+' ' FROM tblBookItenary s WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS Sector
	,b.depDate 
	,(SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  'Airlines PNR'
	,b.airCode as 'Airline Code'
	,(CASE WHEN CHARINDEX('/',pb.ticketNum)>0 
	THEN SUBSTRING(SUBSTRING(pb.ticketNum, CHARINDEX('-', pb.ticketNum)+1,LEN(pb.ticketNum)),
	0,CHARINDEX('/',(SUBSTRING(pb.ticketNum, CHARINDEX('-', pb.ticketNum)+1,LEN(pb.ticketNum))),0)) 
	ELSE pb.ticketNum END ) as 'Ticket No'	 
	,m.Bookedby as'BB: BOOKED BY'
	,m.VesselName as 'SHIP Name',
	m.TR_POName  as 'TRN'	
	from tblBookMaster b
	inner join tblPassengerBookDetails pb on pb.fkBookMaster=b.pkId
	INNER JOIN agentLogin AL ON cast(AL.UserID AS VARCHAR(50))=B.AgentID  
	inner join B2BRegistration ICust on ICust.FKUserID=al.UserID	
	inner join  mAttrributesDetails m on m.OrderID=b.orderId
	WHERE b.BookedBy IS NOT NULL AND b.BookedBy!=0 
	AND b.BookingStatus=1 and CONVERT(VARCHAR(15),inserteddate_old,5)=CONVERT(VARCHAR(15),GETDATE()-1,5) and  ICust.Icast='ADHCUST050742A'
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[USP_MarineReport] TO [rt_read]
    AS [dbo];

