            
--Hotel.GetRBTReportConsole 'test'            
            
CREATE Proc [Hotel].[GetRBTReportConsole_new]            
as            
begin            
          
DECLARE @qry VARCHAR(8000)        
DECLARE @column1name VARCHAR(50)        
  
-- Create the column name with the instruction in a variable        
SET @Column1Name = '[sep=,' + CHAR(13) + CHAR(10) + 'Booking Id]'        
  
-- Construct the SQL query with HTML formatting for header styling        
SET @qry = '  
SET NOCOUNT ON;  
  
SELECT             
    ''<th style="background-color: yellow; border: 1px solid black;">Booking Id</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Agency User</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Agent ID</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">User Name</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Lead Guest Name</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Booking Date</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">CheckIn Date</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Checkout Date</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Cancellation Deadline</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Booking Status</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Mode Of Payment</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Booking Currency</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Booking Amount</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Supplier Ref. No</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Supplier</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">City</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Country</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Hotel Name</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">No. of Passengers</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">No. of Nights</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">No. of Rooms</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Total Room Nights</th>'' +         
    '',         
    ''<th style="background-color: yellow; border: 1px solid black;">Hotel Confirmation</th>''            
    AS HeaderRow  
INTO #HeaderRowHTML;  
  
SELECT   
    HeaderRow  
FROM #HeaderRowHTML;  
  
DROP TABLE #HeaderRowHTML;  
  
SELECT             
    HB.BookingReference '+ @Column1Name +',                    
    BR.AgencyName AS [Agency User],         
    BR.Icast AS [Agent ID],          
    ISNULL(mu.FullName, '' '') AS [User Name],          
    HB.LeaderTitle + '' '' + HB.LeaderFirstName + '' '' + HB.LeaderLastName AS [Lead Guest Name],          
    CONVERT(VARCHAR, HB.inserteddate, 0) AS [Booking Date],       
    FORMAT(HB.CheckInDate, ''MMM dd yyyy'') + '' '' + HB.CheckInTime AS [CheckIn Date],        
    FORMAT(HB.CheckOutDate, ''MMM dd yyyy'') + '' '' + HB.CheckOutTime AS [Checkout Date],      
    CONVERT(VARCHAR, HB.CancellationDeadLine, 0) AS [Cancellation Deadline],          
    HB.CurrentStatus AS [Booking Status],          
CASE                                                                                                                                                 
        WHEN HB.B2BPaymentMode = 1 THEN ''Hold''                                                                                          
        WHEN HB.B2BPaymentMode = 2 THEN ''Credit Limit''                    
        WHEN HB.B2BPaymentMode = 3 THEN ''Make Payment''                                          
        WHEN HB.B2BPaymentMode = 4 THEN ''Self Balalnce''      
        WHEN HB.B2BPaymentMode = 5 THEN ''Pay@Hotel''      
        ELSE ''NA''      
    END AS [Mode Of Payment],         
    HB.CurrencyCode AS [Booking Currency],          
    HB.DisplayDiscountRate AS [Booking Amount],           
    HB.SupplierReferenceNo AS [Supplier Ref. No],        
    HB.SupplierName AS [Supplier],         
    REPLACE(HB.cityName, '','', ''_'') AS [City],         
    REPLACE(HB.CountryName, '','', ''_'') AS Country,        
    REPLACE(HB.HotelName, '','', ''_'') AS [Hotel Name],         
    TotalAdults + ''|'' + TotalChildren  AS [No. of Passengers],         
    SelectedNights AS [No. of Nights],          
    TotalRooms AS [No. of Rooms],            
    SelectedNights AS [Total Room Nights],            
    HotelConfNumber AS [Hotel Confirmation]           
FROM   
    Hotel_BookMaster HB            
LEFT JOIN    
    agentLogin AL ON Hb.RiyaAgentID = al.UserID            
LEFT JOIN   
    B2BRegistration BR ON br.FKUserID = AL.UserID            
LEFT JOIN   
    mCommon Mc ON Mc.ID = Al.UsertypeId            
LEFT JOIN   
    mUser MU ON HB.MainAgentID = MU.ID                                                                 
WHERE             
    MC.ID = 5            
    AND CAST(HB.inserteddate AS DATE) BETWEEN DATEADD(DAY, -1, CAST(GETDATE() AS DATE)) AND DATEADD(DAY, -1, CAST(GETDATE() AS DATE));  
'         
          
        
        
        
        
-- Send the e-mail with the query results in attach        
exec msdb.dbo.sp_send_dbmail         
 @profile_name = 'dba_Automations'  ,        
@recipients='dba@riya.travel;developers@riya.travel',        
--@recipients='dba@riya.travel;',        
@query=@qry,        
@execute_query_database = 'riyatravels',        
@subject='TrvlNxt Hotel Daily RBT Booking Report',        
@attach_query_result_as_file = 1,        
@query_attachment_filename = 'RBT_Report.xls',        
@query_result_separator=',',        
@query_result_width =32767,        
@query_result_no_padding=1         
         
 --  ;gary.fernandes@riya.travel;tnsupport.hotels@riya.travel           
 end