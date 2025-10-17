CREATE PROCEDURE [dbo].[GetBookingDetailsData]-- [GetBookingDetailsData] 'ALV851','JYWN6L'  
@RiyaPNR VARCHAR(10),  
@GDSPNR VARCHAR(10)  
  
AS  
BEGIN  
  
IF (@GDSPNR !='')  
BEGIN  
 SELECT orderId,mobileNo,emailId,CounterCloseTime,RiyaPNR,AgentID,totalFare,a.UserName,a.BookingCountry, c.Icast,BookedBy,a.GroupId   
   FROM tblBookMaster b WITH(NOLOCK)   
   left join AgentLogin a WITH(NOLOCK) on convert(varchar(50),a.UserID) =b.AgentID  
   left join B2BRegistration c on convert(varchar(50),c.FKUserID) =b.AgentID  
   where RiyaPNR=@RiyaPNR AND GDSPNR=@GDSPNR  
  
   SELECT pid, title, paxFName,paxLName,paxType,dateOfBirth,passportIssueCountry,C.A1 AS 'PassportIssueCountryCode',nationality,  
    passexp,passportNum, P.basicFare,P.totalTax,P.totalFare,P.YQ,ISNULL(P.FlatDiscount,0) AS FlatDiscount,P.serviceCharge,P.CancellationCharge,isnull(P.GovtTax, 0) GovtTax,  
 isnull(P.YRTax,0) as YRTax,isnull(P.INTax,0) as INTax,isnull(P.JNTax,0) as JNTax, isnull(P.OCTax,0) as OCTax,   
 isnull(P.ExtraTax,0) as ExtraTax,P.DiscriptionTax,P.isReturn,P.totalFare,P.MCOAmount,P.MCOTicketNo,p.FMCommission,p.CommissionType FROM tblPassengerBookDetails P WITH(NOLOCK)   
   INNER JOIN tblBookMaster B WITH(NOLOCK) ON B.pkId=P.fkBookMaster  
   left join Country C on C.country=passportIssueCountry   
    where RiyaPNR=@RiyaPNR AND GDSPNR=@GDSPNR  
  
  
 SELECT I.isReturnJourney,I.frmSector,I.toSector,I.fromAirport,I.toAirport,I.airName,I.operatingCarrier, I.airCode,   
 I.equipment,I.flightNo, I.deptTime,I.arrivalTime,cabin,farebasis,I.fromTerminal,I.toTerminal,i.Commission,  
 B.FareSellKey,B.JourneySellKey,I.farebasis,b.GDSPNR FROM tblBookItenary I WITH(NOLOCK)   
 INNER JOIN tblBookMaster B WITH(NOLOCK) ON B.pkId=I.fkBookMaster  
 where  B.RiyaPNR=@RiyaPNR AND GDSPNR=@GDSPNR  
  
 END  
 ELSE  
 BEGIN  
   
  SELECT orderId,mobileNo,emailId,CounterCloseTime,RiyaPNR,AgentID,totalFare,a.UserName,a.BookingCountry,a.GroupId  
   FROM tblBookMaster b WITH(NOLOCK)   
 left join AgentLogin a  WITH(NOLOCK) on convert(varchar(50),a.UserID) =b.AgentID  
 where RiyaPNR=@RiyaPNR   
  
   SELECT pid, title, paxFName,paxLName,paxType,dateOfBirth,passportIssueCountry,C.A1 AS 'PassportIssueCountryCode',nationality,  
    passexp,passportNum, P.basicFare,P.totalTax,P.totalFare,P.YQ,ISNULL(P.FlatDiscount,0) AS FlatDiscount,P.serviceCharge,P.CancellationCharge,isnull(P.GovtTax, 0) GovtTax,  
 isnull(P.YRTax,0) as YRTax,isnull(P.INTax,0) as INTax,isnull(P.JNTax,0) as JNTax, isnull(P.OCTax,0) as OCTax,   
 isnull(P.ExtraTax,0) as ExtraTax,P.DiscriptionTax,P.isReturn,P.totalFare,P.MCOAmount,P.MCOTicketNo,p.FMCommission,p.CommissionType FROM tblPassengerBookDetails P WITH(NOLOCK)   
   INNER JOIN tblBookMaster B WITH(NOLOCK) ON B.pkId=P.fkBookMaster  
     
   left join Country C on C.country=passportIssueCountry   
    where RiyaPNR=@RiyaPNR   
  
  
  
 SELECT I.isReturnJourney,I.frmSector,I.toSector,I.fromAirport,I.toAirport,I.airName,I.operatingCarrier, I.airCode,   
 I.equipment,I.flightNo, I.deptTime,I.arrivalTime,cabin,farebasis,I.fromTerminal,I.toTerminal,i.Commission,  
 B.FareSellKey,B.JourneySellKey,I.farebasis,b.GDSPNR FROM tblBookItenary I WITH(NOLOCK)   
 INNER JOIN tblBookMaster B WITH(NOLOCK) ON B.pkId=I.fkBookMaster  
 where  B.RiyaPNR=@RiyaPNR   
 END  
END  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetBookingDetailsData] TO [rt_read]
    AS [dbo];

