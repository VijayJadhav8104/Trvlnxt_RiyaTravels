CREATE proc [dbo].[OBTC_Job]    
as    
begin    
CREATE TABLE #Temp    
(    
 Date_of_Booking datetime,Booking_ID varchar(50),Agency_Name varchar(100),Username varchar(200)    
 ,BranchName nvarchar(100),OBTC_NO varchar(25),CheckInDate datetime    
)    
    
INSERT INTO #Temp    
       
 SELECT distinct     
 HB.inserteddate AS 'Date of Booking',    
 BookingReference AS 'Booking ID',       
 BR.AgencyName + '-' + BR.Icast AS 'Agency Name',    
 MU.FullName + '-' + MU.UserName AS 'Username',       
 mybranch.BranchCode + '-' + mybranch.Name AS 'BranchName',     
  isnull(OBTCNo,'NULL') AS 'OBTC NO',    
  HB.CheckInDate     --,mcn.Value as 'Usertype  --mu.EmailID   
  FROM      Hotel_BookMaster HB  WITH (NOLOCK) 
  LEFT JOIN      mUser MU  WITH (NOLOCK) ON HB.MainAgentID = MU.ID  
  LEFT JOIN      B2BRegistration BR WITH (NOLOCK) ON HB.RiyaAgentID = BR.FKUserID   
 -- LEFT JOIN   mBranch MB ON MB.BranchCode = BR.BranchCode   
  join AgentLogin AGL WITH (NOLOCK) on HB.RiyaAgentID=AGL.UserID   
  left join mCommon  mcn WITH (NOLOCK) on mcn.ID=AGL.userTypeID    
  left join(                                                                                    
  select mbr.BranchCode,MAx(name) as 'Name',Max(Division) as 'Division',max(id) as maxid from mBranch as mbr  group by BranchCode                                                                                                                              
  
                                                                        
   )  as mybranch                                                                                                                                        
 on br.BranchCode=mybranch.BranchCode      
  WHERE      CurrentStatus = 'Vouchered'      AND BookingPortal = 'TNH'    
  AND AGL.userTypeID = 2  
  AND CONVERT(date, HB.inserteddate) = CONVERT(date, GETDATE() - 1)   
  AND ( (LEN(OBTCNo) < 8 OR LEN(OBTCNo) > 8)  OR OBTCNo IS NULL  ) AND ( OBTCNo NOT LIKE '%[^a-zA-Z0-9]%' OR OBTCNo IS NULL )  
  AND HB.MainAgentID != 0      order by HB.BookingReference desc    
    
    
    
if @@ROWCOUNT>0    
begin    
    
DECLARE @s VARCHAR(max)    
DECLARE @xml NVARCHAR(MAX)    
DECLARE @body NVARCHAR(MAX)    
    
SET @xml = CAST(( SELECT [Date_of_Booking] AS 'td','',[Booking_ID] AS 'td','',[Agency_Name] AS 'td','',    
           [Username] AS 'td','', BranchName AS 'td','', OBTC_NO AS 'td','',    
           CheckInDate AS 'td'    
FROM #Temp order by [Date_of_Booking]  desc    
    
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))    
    
SET @body ='<html>    
<head> <style type="text/css">.styled-table { border-collapse: collapse; margin: 25px 0; font-size: 0.9em; font-family: sans-serif; min-width: 400px; box-shadow: 0 0 20px rgba(0, 0, 0, 0.15); }    
.styled-table thead tr { background-color: #0000FF; color: #ffffff; text-align: left; }     
.styled-table th, .styled-table td { padding: 12px 15px; } .styled-table tbody tr { border-bottom: 1px solid #dddddd; }     
.styled-table tbody tr:nth-of-type(even) { background-color: #f3f3f3; } .styled-table tbody tr:last-of-type { border-bottom: 2px solid #009879; }    
.styled-table tbody tr.active-row { font-weight: bold; color: #009879; } table tr:last-child {font-weight: bold;} </style> </head>    
<body><H3>Please update the correct OBTC numbers against the below vouchered bookings on Trvlnxt portal - Manage Booking page. In case of OBTC pending to be created from accounts.    
Please share an Inquiry number connect with Accounts Team at email tn.accounts@riya.travel.</H3>    
<table class="styled-table"> <thead>    
<tr>    
<th> Date_of_Booking</th> <th> Booking_ID </th> <th> Agency_Name </th> <th> Username </th>     
<th> BranchName </th><th> OBTC_NO </th>    
<th> CheckInDate </th>     
</tr>    
</thead> <tbody>'    
     
    
   SET @body = @body + @xml +'</table></body>    
    
<b>Regards,</b>    
<br>    
Riya Travels    
    
</html>'    
SET @s = 'No OBTC Hotel List- Update proper OBTC'+' '+CONVERT(VARCHAR(12),GETDATE()-1,107)    
    
DECLARE @RecipientEmail NVARCHAR(MAX) = '';    
    
-- Add 'tn.hotels@riya.travel' and 'tn.accounts@riya.travel' directly    
SET @RecipientEmail = ''    
    
-- Add distinct email addresses from the query    
SELECT  @RecipientEmail = @RecipientEmail + email + ';'    
FROM (    
    SELECT DISTINCT MU.EmailID as email    
    FROM      Hotel_BookMaster HB WITH (NOLOCK)
	LEFT JOIN      mUser MU  WITH (NOLOCK) ON HB.MainAgentID = MU.ID 
	LEFT JOIN      B2BRegistration BR WITH (NOLOCK) ON HB.RiyaAgentID = BR.FKUserID 
	LEFT JOIN   mBranch MB WITH (NOLOCK) ON MB.BranchCode = BR.BranchCode 
	join AgentLogin AGL WITH (NOLOCK) on HB.RiyaAgentID=AGL.UserID 
  
left join mCommon  mcn WITH (NOLOCK) on mcn.ID=AGL.userTypeID   
WHERE      CurrentStatus = 'Vouchered'      AND BookingPortal = 'TNH'      AND AGL.userTypeID = 2    
AND CONVERT(date, HB.inserteddate) = CONVERT(date, GETDATE() - 1)     AND (         (LEN(OBTCNo) < 8 OR LEN(OBTCNo) > 8)  
OR OBTCNo IS NULL     )     AND (         OBTCNo NOT LIKE '%[^a-zA-Z0-9]%' OR OBTCNo IS NULL     )     
AND HB.MainAgentID != 0    
) AS DistinctEmails;    
    
-- Remove the trailing semicolon, if any    
SET @RecipientEmail = LEFT(@RecipientEmail, LEN(@RecipientEmail) - 1);    
    
-- Print the concatenated email addresses    
--PRINT @RecipientEmail;    
    
    
EXEC msdb.dbo.sp_send_dbmail    
@profile_name = 'DBA_Automations', -- replace with your SQL Database Mail Profile    
@body = @body,    
@body_format ='HTML',    
@recipients =  @RecipientEmail,    
@copy_recipients= 'jagruti.patel@riya.travel;rubina.Dalvi@riya.travel;tn.hotels@riya.travel;tn.accounts@riya.travel;kapil.sharma@riya.travel;mahesh.mahadik@riya.travel', -- replace with your email address    
--@copy_recipients='tnsupport.hotels@riya.travel',  
@blind_copy_recipients ='dba@riya.travel;developers@riya.travel;priti.kadam@riya.travel;tnsupport.hotels@riya.travel',    
@subject = @s;    
    
end    
    
DROP TABLE #Temp    
    
end