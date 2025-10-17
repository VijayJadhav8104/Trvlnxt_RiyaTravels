-- =============================================
-- Author:		Bhavika kawa
-- Create date: 19/06/2020
-- Description:	Get data for View PNR
--[Sp_ViewPNR] '12XZ82','',''
-- =============================================
CREATE PROCEDURE [dbo].[Sp_ViewPNR]-- 'G375E0','',''
	@RiyaPNR varchar(max)=null,
	@AirLinePNR varchar(max)=null,
	@CRSPNR  varchar(max)=null
AS
BEGIN
		--Contact Details
		Select TOP 1 (isnull(AL.FirstName,'')+' '+isnull(AL.LastName,'')) as Name, B.AddrMobileNo as ContactNo,B.AgencyName,AL.UserName as EmailID,
		B.Icast as AgencyNo,B.AddrContactNo as BusinessNo,B.AddrLandlineNo as HomeNo,'' as BookedAgent,BM.airCode as OperatorName,
		P.PaymentMode ,BM.inserteddate as BookedDate,(AddrAddressLocation+' , ' + AddrCity+' , ' + AddrState+' , ' + AddrZipOrPostCode) as AgentAddr,
		BM.emailId
		from tblBookMaster BM
		LEFT JOIN B2BRegistration B ON CAST(B.FKUserID AS VARCHAR(50))=BM.AgentID
		INNER JOIN Paymentmaster P ON P.order_id=BM.orderId
		INNER join agentLogin AL ON CAST(AL.UserID AS VARCHAR(50))=BM.AgentID
		INNER JOIN tblBookItenary BI ON BI.orderId=BM.orderId
		where BM.IsBooked=1 AND
		((@RiyaPNR = '') or ( bm.riyaPNR = @RiyaPNR))
		AND ((@AirLinePNR = '') or ( BI.airlinePNR = @AirLinePNR))
		AND ((@CRSPNR = '') or ( bm.GDSPNR = @CRSPNR))

		--Fare details
		select  distinct PD.paxType, BM.basicFare as TotalBasic,(ISNULL(BM.TotalMarkup,0)+ISNULL(BM.totalTax,0))as TotalTax,PR.ServiceFee as ServiceCharge,
		(ISNULL(PD.IATACommission,0)+ISNULL(PD.PLBCommission,0)) as Commission,PR.GSTAMount as GST, 
		(ISNULL(BM.basicFare,0)+ISNULL(BM.TotalMarkup,0)+ISNULL(BM.totalTax,0)+ISNULL(PR.ServiceFee,0)+ISNULL(PD.IATACommission,0)+ISNULL(PD.PLBCommission,0)+ISNULL(PR.GSTAMount,0)) as Total,
		C.Currency,BM.YQTax
		from tblBookMaster BM
		inner join tblPassengerBookDetails PD on PD.fkBookMaster=BM.pkId
		left join PNRRetriveDetails PR on PR.OrderID=BM.orderId
		INNER JOIN tblBookItenary BI ON BI.orderId=BM.orderId
		Inner join mCountry C ON C.CountryCode=BM.Country
		where BM.IsBooked=1 AND
		((@RiyaPNR = '') or ( bm.riyaPNR = @RiyaPNR))
		AND ((@AirLinePNR = '') or ( BI.airlinePNR = @AirLinePNR))
		AND ((@CRSPNR = '') or ( bm.GDSPNR = @CRSPNR))

		--Passanger Details
		select (PD.Title+' ' + PD.paxFName +' '+ PD.paxLName+' ( '+PD.paxType+' )') as 'Passanger Name',
		PD.ticketNum as 'Ticket No.',BM.flightNo as 'Flight No.',BM.frmSector as Origin,BM.toSector as Destination,
		BM.Depttime as DepartTure,BM.arrivalTime as Arrival,left(BI.Cabin,1) as Class,'Confirmed' as Status,
		PD.basicFare as 'Basic Fare',PD.YQ as YQTax,
		(ISNULL(BM.totalTax,0) + ISNULL(BM.TotalMarkup,0) + ISNULL(PR.ServiceFee,0) + ISNULL(PD.IataCommission,0) + 
		ISNULL(PD.PLBCommission,0) + ISNULL(PR.GSTAmount,0) +ISNULL(BM.YQTax,0)) as 'Tax Others',
		(ISNULL(PD.BasicFare,0)+CAST(PD.YQ AS DECIMAL(18, 4))+ISNULL(BM.totalTax,0) + ISNULL(BM.TotalMarkup,0) + ISNULL(PR.ServiceFee,0) + ISNULL(PD.IataCommission,0) + 
		ISNULL(PD.PLBCommission,0) + ISNULL(PR.GSTAmount,0) +ISNULL(BM.YQTax,0)) as 'Gross Fare',
		BM.mobileNo
		from tblBookMaster BM
		INNER JOIN tblPassengerBookDetails PD on PD.fkBookMaster=BM.pkId
		INNER JOIN tblBookItenary BI ON BI.orderId=BM.orderId
		left join PNRRetriveDetails PR on PR.OrderID=BM.orderId
		where BM.IsBooked=1 AND
		((@RiyaPNR = '') or ( bm.riyaPNR = @RiyaPNR))
		AND ((@AirLinePNR = '') or ( BI.airlinePNR = @AirLinePNR))
		AND ((@CRSPNR = '') or ( bm.GDSPNR = @CRSPNR))

		--Other
		Select BM.riyaPNR,BI.airlinePNR,BM.GDSPNR as 'CRSPnr',BM.airName,bm.airCode,BI.flightNo,AC.SEARCHNAME AS frmSectorName,AC1.SEARCHNAME AS ToSectorName,
		 BM.frmSector as Depature,convert(char(5), BM.deptTime, 108) as DeptTime, right(BM.fromTerminal,1) as fromTerminal,
		left(Cabin,1) as Class,SUBSTRING(Cabin, CHARINDEX(' ', Cabin) +3, DATALENGTH(Cabin)) as ClassName,
		convert(char(3),datename(weekday,BM.depDate))+', '+CONVERT(CHAR(11),BM. depDate, 106) as DeptDay,
		BM.toSector as arrival ,convert(char(5), BM.arrivalTime, 108) as arrivalTime,right(BM.toTerminal,1) as toTerminal,
		convert(char(3),datename(weekday,BM.arrivalDate))+', '+CONVERT(CHAR(11), BM.arrivalDate, 106) as DeptDay,BI.farebasis,
		DATEDIFF(hh,BM.deptTime, BM.arrivalTime) as Hours,   
		DATEDIFF(mi,DATEADD(hh,DATEDIFF(hh, BM.deptTime, BM.arrivalTime),BM.deptTime),BM.arrivalTime) as Minutes
		from tblBookMaster BM
		LEFT JOIN B2BRegistration B ON CAST(B.FKUserID AS VARCHAR(50))=BM.AgentID
		INNER JOIN Paymentmaster P ON P.order_id=BM.orderId
		INNER join agentLogin AL ON CAST(AL.UserID AS VARCHAR(50))=BM.AgentID
		INNER JOIN tblBookItenary BI ON BI.orderId=BM.orderId
		left JOIN tblAirportCity AC on AC.CODE=BM.frmSector
		left JOIN tblAirportCity AC1 on AC1.CODE=BM.toSector
		where BM.IsBooked=1 AND
		((@RiyaPNR = '') or ( bm.riyaPNR = @RiyaPNR))
		AND ((@AirLinePNR = '') or ( BI.airlinePNR = @AirLinePNR))
		AND ((@CRSPNR = '') or ( bm.GDSPNR = @CRSPNR))

		--new Passanger Details
		select distinct pid, (PD.Title+' ' + PD.paxFName +' '+ PD.paxLName+' ( '+PD.paxType+' )') as 'Passanger Name',
		PD.ticketNum as 'Ticket No.','Confirmed' as Status,
		PD.basicFare as 'Basic Fare',PD.YQ as YQTax,
		(ISNULL(BM.totalTax,0) + ISNULL(BM.TotalMarkup,0) + ISNULL(PR.ServiceFee,0) + ISNULL(PD.IataCommission,0) + 
		ISNULL(PD.PLBCommission,0) + ISNULL(PR.GSTAmount,0) +ISNULL(BM.YQTax,0)) as 'Tax Others',
		(ISNULL(PD.BasicFare,0)+CAST(PD.YQ AS DECIMAL(18, 4))+ISNULL(BM.totalTax,0) + ISNULL(BM.TotalMarkup,0) + ISNULL(PR.ServiceFee,0) + ISNULL(PD.IataCommission,0) + 
		ISNULL(PD.PLBCommission,0) + ISNULL(PR.GSTAmount,0) +ISNULL(BM.YQTax,0)) as 'Gross Fare',
		BM.mobileNo
		from tblBookMaster BM
		INNER JOIN tblPassengerBookDetails PD on PD.fkBookMaster=BM.pkId
		INNER JOIN tblBookItenary BI ON BI.orderId=BM.orderId
		left join PNRRetriveDetails PR on PR.OrderID=BM.orderId
		where BM.IsBooked=1 AND
		((@RiyaPNR = '') or ( bm.riyaPNR = @RiyaPNR))
		AND ((@AirLinePNR = '') or ( BI.airlinePNR = @AirLinePNR))
		AND ((@CRSPNR = '') or ( bm.GDSPNR = @CRSPNR))

		--new flight Details
		select BI.flightNo as 'Flight No.',BI.frmSector as Origin,BI.toSector as Destination,
		BI.Depttime as DepartTure,BI.arrivalTime as Arrival,left(BI.Cabin,1) as Class
		from tblBookMaster BM
		INNER JOIN tblBookItenary BI ON BI.orderId=BM.orderId
		where BM.IsBooked=1 AND
		((@RiyaPNR = '') or ( bm.riyaPNR = @RiyaPNR))
		AND ((@AirLinePNR = '') or ( BI.airlinePNR = @AirLinePNR))
		AND ((@CRSPNR = '') or ( bm.GDSPNR = @CRSPNR))


END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_ViewPNR] TO [rt_read]
    AS [dbo];

