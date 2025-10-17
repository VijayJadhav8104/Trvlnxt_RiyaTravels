
  
   -- exec SameDay_Hotel_Booking_2 
  
CREATE proc [dbo].[SameDay_Hotel_Booking_2]            
as             
   declare @countno int  
begin  
  
                   -- Create Temporary Table  
                CREATE TABLE #TempBookingData (  
                    BookingId VARCHAR(max),  
                    pkId INT,  
                    CheckInDate DATETIME,  
                    CheckInTime VARCHAR(max),  
                    CheckOutDate DATETIME,  
                    Bookingdate DATETIME,  
                    Status VARCHAR(max),  
					CountryName VARCHAR(max),  
                    RequestTimeZone VARCHAR(max),  
                    SessionId VARCHAR(max),  
                    Booking_IP VARCHAR(max),  
                    AgencyName VARCHAR(max),  
					BookingPortal VARCHAR(max),  
                    UserName VARCHAR(max),
					RiyaAgentID VARCHAR(max),
                    MainAgentID VARCHAR(max)
       
                );  
                  
                -- Insert Data into the Temporary Table  
           INSERT INTO #TempBookingData (BookingId, pkId, CheckInDate, CheckInTime, CheckOutDate, Bookingdate, Status,CountryName, RequestTimeZone, SessionId, Booking_IP, AgencyName,BookingPortal,UserName,RiyaAgentID,MainAgentID)  
                SELECT   distinct 
                    HB.Bookingreference as BookingId,  
                    HB.pkId as pkId,  
                    HB.CheckInDate as CheckInDate,  
                    HB.CheckInTime as CheckInTime,  
                    HB.CheckOutDate as CheckOutDate,  
                    HB.inserteddate as inserteddate,  
                    HSM.Status as Status,
				    concat(isnull(B2BR.country,'-'),' - ',isnull(ms.StateName,B2BR.AddrState),' - ',isnull(B2BR.AddrCity,'')) as CountryName,
                    '-' as RequestTimeZone,  
                    isnull(TLH.SessionId,'-') as SessionId,  
                    concat(HB.ClientIP,' - (',(isnull(TLH.UserLoginCountry,'-')),')') as ClientIP,  
                    isnull(B2BR.AgencyName,'-') as AgencyName,  
                    isnull(HB.BookingPortal,'-') as BookingPortal,  
                    isnull(ISNULL((MU.FullName +'-'+ MU.Username),'-'),'-')  as UserName ,
					isnull(hb.RiyaAgentID,'-') as RiyaAgentID,
					isnull(hb.MainAgentID,'-') as MainAgentID
                FROM   
                    Hotel_BookMaster HB WITH(NOLOCK)  
                LEFT JOIN  
                    Hotel_Status_History HSH WITH(NOLOCK) ON HB.pkId = HSH.FKHotelBookingId  
                LEFT JOIN  
                    Hotel_Status_Master HSM WITH(NOLOCK) ON HSM.Id = HSH.FkStatusId  
                LEFT JOIN  
                    tblLoginHistory TLH WITH(NOLOCK) ON (HB.RiyaAgentID=TLH.AgencyId or HB.MainAgentID=TLH.UserID) AND HB.LoginSessionId = TLH.SessionId  
                LEFT JOIN   
                    B2BRegistration B2BR WITH(NOLOCK) ON B2BR.FKUserID = HB.RiyaAgentID  
                LEFT JOIN   
                    mUser MU WITH(NOLOCK) ON MU.id = HB.MainAgentID  
                LEFT JOIN
				    mState ms with (nolock) on ms.id=b2br.StateID
                WHERE   
				hb.BookingReference in ('TNH00279686','TNH00279655')
                   -- CONVERT(DATE, HB.checkindate) = CONVERT(DATE, GETDATE())  
                   -- AND CONVERT(DATE, HB.inserteddate) = CONVERT(DATE, GETDATE())  
                    AND HSH.FkStatusId = 4   
                    AND HSH.IsActive = 1  
                   AND HB.BookingPortal = 'TNH'
				   --and hb.Bookingreference not in(select bookingid from DBA_Admin.dbo.sameday_bookingid 
				   --                               where convert(date,inserteddate)=convert(date,getdate()));
                  
                -- Optional: Select to verify the inserted data  
         SELECT @countno=count(1) FROM #TempBookingData;  
  
  
  
if (@countno>0)  
      begin  
  -------------------------------------------------
  --insert into DBA_Admin.dbo.sameday_bookingid (bookingid)
  --select BookingId from #TempBookingData
  --      -------------------------------------------
        	
        		
        	CREATE TABLE #Top5_IP_Results (
            UserID varchar(100),
            AgencyId varchar(100),
            IPAddress varchar(max)
            --LoginDate datetime,  -- You may want to use DATETIME type here if LoginDate is a date-time column
            --RowNum INT
        );
        
        -- Insert the top 5 latest results for each value in the IN clause
        WITH RankedData AS (
            SELECT distinct
                UserID,
                AgencyId,
                IPAddress,
                MAX(LoginDate) AS LoginDate,
				UserLoginCountry,
				 ROW_NUMBER() OVER (PARTITION BY UserID, AgencyId ORDER BY  MAX(LoginDate) DESC) AS RowNum
            FROM 
                tblLoginHistory WITH(NOLOCK)
             WHERE 
		         AgencyId IN(46711,46712,51474) or
		         UserID IN (46711,46712,51474)

				   GROUP BY 
            UserID,
            AgencyId,
            IPAddress,
			UserLoginCountry
        )
        INSERT INTO #Top5_IP_Results (UserID, AgencyId, IPAddress)
        SELECT 
            UserID,
            AgencyId,
            concat(IPAddress,' - (',isnull(UserLoginCountry,'-'),')','   ( ',REPLACE(REPLACE(CONVERT(varchar(100),LoginDate, 100), 'PM', ' PM'), 'AM', ' AM'),')') as IPAddress
         
        FROM 
            RankedData
        WHERE 
            RowNum <= 10;
        	
        	
        	
        	--select * from #Top5_IP_Results
        	
        	
        	CREATE TABLE #Top5_IP_Results2 (
            UserID varchar(100),
            AgencyId varchar(100),
            last_five_login_IP varchar(max),
            LoginDate varchar(100),  -- You may want to use DATETIME type here if LoginDate is a date-time column
            RowNum INT
        );
        	
        	insert into #Top5_IP_Results2 (userid,AgencyId,last_five_login_IP)
        	select userid,AgencyId,STRING_AGG(IPAddress,'\') AS all_IPs from #Top5_IP_Results
        	group by userid,agencyid
        	
      
        	 --select * from #TempBookingData t
        	 --join #Top5_IP_Results2 tt on (t.RiyaAgentID = tt.AgencyId OR t.MainAgentID = tt.UserID)
    
	------------------------------------------------

	 select 
				  CASE
                       WHEN CHARINDEX(t.Booking_IP,tt.last_five_login_IP) > 0 THEN 'match'  -- IP in Booking_IP found in last_five_login_IP
                       ELSE 'not match'                            -- IP in Booking_IP not found in last_five_login_IP
                       END AS IP_Match
					  ,concat(convert(date,CheckInDate),'  ',CheckInTime) as Checkindatetime
				      ,* 
				 into  #temptable_match
				 from #TempBookingData t
        	     join #Top5_IP_Results2 tt on (t.RiyaAgentID = tt.AgencyId OR t.MainAgentID = tt.UserID)



	----------------------------------------------------

   ----SELECT * FROM #TempBookingData;    

   ----SELECT * FROM #TempBookingData;    
 
  
DECLARE @xml1 NVARCHAR(MAX)   
DECLARE @xml2 NVARCHAR(MAX) 
DECLARE @xml4 NVARCHAR(MAX)            
DECLARE @body NVARCHAR(MAX)            
DECLARE @body1 NVARCHAR(MAX)            
         
SET @xml1 = CAST((            
Select   
  --   CASE 
  --          WHEN CHARINDEX([Booking_IP], [last_five_login_IP]) = 0 
  --          THEN '<tr style="background-color: red;">'
  --          ELSE '<tr>'
  --      END   
		--+
       [BookingId] AS 'td',''  
      -- ,[pkId] AS 'td',''  
       ,[Checkindatetime] AS 'td',''  
       --,[CheckInTime] AS 'td',''  
       ,[CheckOutDate] AS 'td',''  
       ,[Bookingdate] AS 'td',''  
       ,[Status] AS 'td',''  
      -- ,[RequestTimeZone] AS 'td',''  
       --,[SessionId] AS 'td',''   
       ,[Booking_IP] AS 'td','' 
	   , REPLACE([last_five_login_IP], '\', '<br>') AS 'td',''
	   ,[CountryName] AS 'td',''
       ,[AgencyName] AS 'td',''  
       ,[BookingPortal] as 'td',''  
       ,[UserName] AS 'td' 
	   --,[last_five_login_IP] AS 'td',''
	 
 from   #temptable_match where IP_Match ='not match'
 
        --#TempBookingData t
        --join #Top5_IP_Results2 tt on (t.RiyaAgentID = tt.AgencyId OR t.MainAgentID = tt.UserID)
   FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))    


   -- Replace the encoded <br> tag with actual <br>
SET @xml1 = REPLACE(@xml1, '&lt;br&gt;', ',<br/>')
SET @xml1 = REPLACE(@xml1, '<tr>', '<tr style="background-color: #ffb3b3;">')
    
-----------------------------------------------------------------------------------

	SET @xml2 = CAST((            
Select   
  --   CASE 
  --          WHEN CHARINDEX([Booking_IP], [last_five_login_IP]) = 0 
  --          THEN '<tr style="background-color: red;">'
  --          ELSE '<tr>'
  --      END   
		--+
       [BookingId] AS 'td',''  
      -- ,[pkId] AS 'td',''  
       ,[Checkindatetime] AS 'td',''  
       --,[CheckInTime] AS 'td',''  
       ,[CheckOutDate] AS 'td',''  
       ,[Bookingdate] AS 'td',''  
       ,[Status] AS 'td',''  
      -- ,[RequestTimeZone] AS 'td',''  
      -- ,[SessionId] AS 'td',''   
       ,[Booking_IP] AS 'td',''  
	   ,REPLACE([last_five_login_IP], '\', '<br>') AS 'td',''
	   ,[CountryName] AS 'td',''
       ,[AgencyName] AS 'td',''  
       ,[BookingPortal] as 'td',''  
       ,[UserName] AS 'td'
	   --,[last_five_login_IP] AS 'td',''
	  
 from   #temptable_match 
        where IP_Match ='match'
 
        --#TempBookingData t
        --join #Top5_IP_Results2 tt on (t.RiyaAgentID = tt.AgencyId OR t.MainAgentID = tt.UserID)
   FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))    

   SET @xml2 = REPLACE(@xml2, '&lt;br&gt;', ',<br/>')
  
----------------------------------------------------------------------------------

	set @xml4=isnull(@xml1,'')+isnull(@xml2,'')

	--print @xml4
----Drop table #TempBookingData            
        
DECLARE @s VARCHAR(max)            
              

SET @body =
'<html>
<head>
    <style type="text/css">
        .styled-table {
            border-collapse: collapse;
            border-style: solid;
            margin: 25px 0;
            font-size: 0.9em;
            font-family: sans-serif;
            min-width: 2200px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
        }
        .styled-table thead tr {
            background-color: #009879;
            color: #ffffff;
            text-align: left;
        }
        .styled-table th, .styled-table td {
            padding: 12px 15px;
        }
        .styled-table tbody tr {
            border-bottom: 1px solid #dddddd;
        }
        .styled-table tbody tr:nth-of-type(even) {
            background-color: #f3f3f3;
        }
        .styled-table tbody tr:last-of-type {
            border-bottom: 2px solid #009879;
        }
        .styled-table tbody tr.active-row {
            font-weight: bold;
            color: #009879;
        }
        table tr:last-child {
            font-weight: solid;
        }
        .styled-table td:nth-child(7) {
            width: 3000px; /* Set a fixed width for the last column */
            word-wrap: break-word; /* Allow text to wrap */
            white-space: normal; /* Allow wrapping of content */
            overflow: visible; /* Make sure the overflow is visible and wrapped properly */
        }
		
    </style>
</head>
<body>
    <h3>Today Same Day Hotel Booking: ' + CONVERT(VARCHAR(12), GETDATE(), 107) + '</h3>
    <table class="styled-table">
        <thead>
            <tr style="border-style: solid;">
                <th>BookingId</th>
              
                <th>Checkindatetime</th>
               
                <th>CheckOutDate</th>
                <th>Bookingdate</th>
                <th>Status</th>
              
                <th>Booking_IP</th>
				<th>login IPs (login country) (last login time)</th>
				<th>CountryName</th>
                <th>Agency Name</th>
                <th>Booking Portal</th>
                <th>User Name</th>
                
            </tr>
        </thead>
        <tbody>';
       
       
-----------------


           -- Add dynamic XML data into the email body
SET @body = @body + @xml4;

-- Close the HTML structure
SET @body = @body + '</tbody></table></body></html>';

-- Subject for the email
SET @s = 'Same day bookings of Hotels :' + CONVERT(VARCHAR(12), GETDATE(), 107);

------------------
            
--SET @body1 = 'Bookings of hotels ' +CONVERT(VARCHAR(12),GETDATE(),107)        
            
--SET @body = @body + @xml +'</tbody></table></body></html>'            
--SET @s = 'Same day bookings of Hotels';            
            
            
EXEC msdb.dbo.sp_send_dbmail            
@profile_name = 'dba_automations',             
         
@from_address = 'noreply@riya.travel',              
--@recipients = 'dba@riya.travel;faizan.shaikh@riya.travel;priti.kadam@riya.travel;TrvlNxt@riya.travel;tnsupport.hotels@riya.travel',  
@recipients = 'dba@riya.travel',
--@blind_copy_recipients='',            
            
@subject=@s,            
@body = @body,            
@body_format ='HTML',            
            
@execute_query_database = 'Riyatravels';            
           

  
end  
end  

