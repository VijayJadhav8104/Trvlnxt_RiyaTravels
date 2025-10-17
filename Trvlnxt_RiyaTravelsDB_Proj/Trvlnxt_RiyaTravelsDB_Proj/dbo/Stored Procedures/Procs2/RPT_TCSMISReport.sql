CREATE procedure [dbo].[RPT_TCSMISReport]                                 
@FromDate Datetime,                                  
@Todate Datetime,                                  
@AgentID varchar(50),                        
@AgencyNameList varchar(max)=''                        
as                                  
begin            
        
select           
        
'US BTA' as 'DSR Type'  
,UPPER(FORMAT(B.IssueDate, 'dd-MMM-yyyy HH:mm:ss')) as 'DSR Date'   
,A.TravelRequestNumber AS 'Request no.'         
,P.paxFName + ' ' + P.paxLName AS 'TRAVELLER NAME'          
,A.EmpDimession AS 'EMP NUMBER'     
,A.Traveltype as 'TRAVEL TYPE' 
,A.Projectcode as 'PROJ W/SWON'
,UPPER(FORMAT(CONVERT(DATETIME, A.GESSRECEIVEDDATE, 120), 'dd-MMM-yyyy')) AS 'GESS-RECEIVED-DATE'
,UPPER(FORMAT(IssueDate, 'dd-MMM-yyyy HH:mm:ss')) as 'TICKET ISSUANCE DATE'          
,B.travClass as 'CLASS OF TICKET'          
,UPPER(FORMAT(B.depDate, 'dd-MMM-yyyy HH:mm:ss')) as 'OUTBOUND TRAVEL DATE'          
,UPPER(FORMAT(B.arrivalDate, 'dd-MMM-yyyy HH:mm:ss')) as 'RETURN TRAVEL DATE'  
,B.frmSector AS 'ORIGIN'          
,B.toSector AS 'DESTINATION'   
,STUFF((SELECT '/' + s.airName FROM tblBookItenary s WITH (NOLOCK) WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'AIRLINE NAME'     
,STUFF((SELECT '/' + s.airCode FROM tblBookItenary s WITH (NOLOCK) WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'Airline Code' 
,A.TicketType AS 'Ticket Type'
,(Case when (LEN(Convert(varchar(3), AN.[AWB Prefix])) = 1) 
	 then '00' + ((Convert(varchar(3), AN.[AWB Prefix]))+'-'+ P.TicketNumber)
	 when (LEN(Convert(varchar(3), AN.[AWB Prefix])) = 2) 
	 then '0' + ((Convert(varchar(3), AN.[AWB Prefix]))+'-'+ P.TicketNumber)
	 else ((Convert(varchar(3), AN.[AWB Prefix]))+'-'+ P.TicketNumber) end) as 'TICKET NUMBER'
,STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WITH (NOLOCK) WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'AIRLINE PNR' 
,STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WITH (NOLOCK) WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'ROUTE'           
,(ROUND(P.basicFare,2) + ROUND(P.totalTax,2)) AS 'TKT VALUE (INCL TAX)'    
,C.CurrencyCode AS 'Curr'
,'' AS 'INVOICE NO'
,'' AS 'INVOICE DATE'
,'' AS 'INVOICE AMOUNT'
,'' AS 'CREDIT NOTE NO'
,'' AS 'CREDIT NOTE DATE'
,'' AS 'CREDIT NOTE AMOUNT'
,'' AS 'AMOUNT PAYABLE'
,'' AS 'DESK NAME' 
,A.EmpIDTRAVELOFFICER AS 'EmpID-TRAVEL OFFICER' 
,'' AS 'GST Applicable' 
,r.GST_No  AS 'Vendor GST Number' 
,'' AS 'TCS GST Number' 
,'' AS 'TCS GST Address' 
,'Riya' AS 'Vendor Name' 
,'Mumbai' as 'LOCATION' 
,'' AS 'Vendor Staff Name' 
,'' AS 'CO2 Value' 
,P.MCOTicketNo AS 'MCO Number' 
,'' AS 'Mangement Fees' 
from tblBookMaster B  WITH (NOLOCK)                                
INNER JOIN B2BRegistration R WITH (NOLOCK) ON R.FKUserID=B.AgentID                                  
INNER JOIN tblPassengerBookDetails P WITH (NOLOCK) ON P.fkBookMaster=B.pkId                                  
INNER JOIN mcountrycurrency C WITH (NOLOCK) ON C.CountryCode=B.Country                                  
left join mAttrributesDetails A WITH (NOLOCK) ON A.fkPassengerid = P.pid        
left join AgentLogin as al WITH (NOLOCK) on al.UserID = B.AgentID 
left join AirlinesName as AN with (NOLOCK) on _CODE = B.ValidatingCarrier
WHERE B.AgentID!='B2C' AND IsBooked=1 AND B.BookingStatus IN (1,4,11)                                  
and b.inserteddate >= @FromDate and b.inserteddate <= @Todate                         
--and  b.AgentID =@AgentID                                  
and ((@AgencyNameList = '') or (b.AgentID IN ( select Data from sample_split(@AgencyNameList,','))))           
and al.GroupId in ('9') --TCS Group        
and B.totalFare > 0        
ORDER BY B.inserteddate DESC                                  
                                  
end 