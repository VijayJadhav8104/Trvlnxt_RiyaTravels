CREATE procedure [dbo].[sp_TCSMISReport]  --[sp_TCSMISReport] '2023-11-01','2023-11-11',''                               
@FromDate Datetime,                                  
@Todate Datetime,                                  
@AgentID varchar(50),                        
@AgencyNameList varchar(max)=''                        
as                                  
begin            
        
select           
        
(select FullName From mUser where id = B.IssueBy) as 'ISSUE BY'        
,A.TravelRequestNumber AS 'TRAVEL REQUEST NUMBER'         
,P.paxFName + ' ' + P.paxLName AS 'FULL NAME'          
,A.EmpDimession AS 'EMPLOYEE CODE'            
,A.Projectcode as 'PROJ W/SWON'          
,IssueDate as 'TICKET ISSUANCE DATE'          
,B.travClass as 'CLASS OF TICKET'          
,B.depDate as 'OUTBOUND TRAVEL DATE'          
,STUFF((SELECT '/' + s.airName FROM tblBookItenary s WITH (NOLOCK) WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'AIRLINE NAME'            
,STUFF((SELECT '/' + s.frmSector+ '/' + toSector FROM tblBookItenary s WITH (NOLOCK) WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'ITINENARY'           
,(ROUND(P.basicFare,2) + ROUND(P.totalTax,2)) AS 'TKT AMT'      
,B.TourCode as 'TOUR CODE'         
--,B.riyaPNR as 'TRVLNXT PNR'          
--,STUFF((SELECT '/' + s.airlinePNR FROM tblBookItenary s WITH (NOLOCK) WHERE s.orderId = B.orderId FOR XML PATH('')),1,1,'') AS 'AIRLINE PNR'          
--, P.TicketNumber AS 'TICKET NUMBER'  

,(Case when (LEN(Convert(varchar(3), AN.[AWB Prefix])) = 1) 
	 then '00' + ((Convert(varchar(3), AN.[AWB Prefix]))+'-'+ P.TicketNumber)
	 when (LEN(Convert(varchar(3), AN.[AWB Prefix])) = 2) 
	 then '0' + ((Convert(varchar(3), AN.[AWB Prefix]))+'-'+ P.TicketNumber)
	 else ((Convert(varchar(3), AN.[AWB Prefix]))+'-'+ P.TicketNumber) end) as 'TICKET NUMBER'

--,B.GDSPNR as 'GDS PNR' 
--,B.ValidatingCarrier
,'US' as 'DESK NAME'          
,A.TravelOfficer as 'TRAVEL OFFICER'          
,B.PricingCode as 'DEAL'          
,A.Traveltype as 'TRAVEL TYPE'          
,B.arrivalDate as 'RETURN DATE'          
,'Original' as 'TICKET STATUS 1'          
,'US BTA' as 'DSR Type'          
,'Live' as 'TICKET STATUS 2'          
--,LocationCode as 'LOCATION CODE'    
,'Mumbai' as 'LOCATION CODE'          
,B.frmSector AS 'ORIGIN'          
,B.toSector AS 'DESTINATION'          
--,B.VendorName as 'VENDOR NAME'  
,'Riya' as 'VENDOR NAME'       
,A.Grade as 'GRADE'          
,A.TripType as 'TRIP TYPE'          
           
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