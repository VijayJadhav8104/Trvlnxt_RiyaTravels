CREATE PROCEDURE [dbo].[GetBookingDetailsData_Ticketing]-- [GetBookingDetailsData] 'ALV851','JYWN6L'
@GDSPNR VARCHAR(10)
,@RiyaPNR varchar(10) = null
AS
BEGIN

 SELECT orderId,mobileNo,emailId,CounterCloseTime,RiyaPNR,AgentID,totalFare,a.UserName,a.BookingCountry
   FROM tblBookMaster b
   left join AgentLogin a on convert(varchar(50),a.UserID) =b.AgentID
   where GDSPNR=@GDSPNR and b.riyaPNR = @RiyaPNR

   SELECT pid, title, paxFName,paxLName,paxType,dateOfBirth,passportIssueCountry,C.A1 AS 'PassportIssueCountryCode',nationality,
    passexp,passportNum, P.basicFare,P.totalTax,P.totalFare,P.YQ,ISNULL(P.FlatDiscount,0) AS FlatDiscount,P.serviceCharge,P.CancellationCharge,isnull(P.GovtTax, 0) GovtTax,
	isnull(P.YRTax,0) as YRTax,isnull(P.INTax,0) as INTax,isnull(P.JNTax,0) as JNTax, isnull(P.OCTax,0) as OCTax, 
	isnull(P.ExtraTax,0) as ExtraTax,P.DiscriptionTax,P.isReturn,P.totalFare FROM tblPassengerBookDetails P
   INNER JOIN tblBookMaster B ON B.pkId=P.fkBookMaster
   left join Country C on C.country=passportIssueCountry 
    where GDSPNR=@GDSPNR and B.riyaPNR = @RiyaPNR


	SELECT I.isReturnJourney,I.frmSector,I.toSector,I.fromAirport,I.toAirport,I.airName,I.operatingCarrier, I.airCode, 
	I.equipment,I.flightNo,	I.deptTime,I.arrivalTime,cabin,farebasis,I.fromTerminal,I.toTerminal,i.Commission,
	B.FareSellKey,B.JourneySellKey,I.farebasis,b.GDSPNR FROM tblBookItenary I
	INNER JOIN tblBookMaster B ON B.pkId=I.fkBookMaster
	where GDSPNR=@GDSPNR and B.riyaPNR = @RiyaPNR
END

