

        
  --exec [Daily_Vendor_Sale_ReportTEST]      
      
CREATE PROC [dbo].[Daily_Vendor_Sale_ReportTEST]            
AS            
BEGIN            
    -- Drop Temp Table if it exists        
    IF OBJECT_ID('tempdb..#Temp2') IS NOT NULL        
    DROP TABLE #Temp2;        
 IF OBJECT_ID('tempdb..#Temp3') IS NOT NULL        
    DROP TABLE #Temp3;        
        
WITH ActiveVendors AS (        
    SELECT            
        CASE            
            WHEN SM.SupplierName = 'Eetglobal' THEN 'Eetglobal (W2M)'            
            WHEN SM.Id = 30 AND HB.SupplierCurrencyCode = 'INR' THEN 'agoda'            
            WHEN SM.Id = 12 AND HB.SupplierCurrencyCode = 'INR' THEN 'Expedia-INR'            
            ELSE SM.SupplierName            
        END AS [Vendor_Name],            
        COALESCE(HB.SupplierCurrencyCode, '-') AS [Vendor_Billing_Currency],            
        CONCAT(COALESCE(SUM(HB.SupplierRate), 0), ' ', HB.SupplierCurrencyCode) AS [Total_Booking_foriegn_Currency],            
        CONCAT(CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.SupplierINRROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18, 2)), ' ', 'INR') AS [Total_Booking_Amount],            
        COALESCE(count(HB.pkId), 0) AS [Booking_count],            
        CONCAT(cast(count(HB.pkId) * 100.0 / NULLIF(SUM(count(HB.pkId)) over (), 0) AS DECIMAL(18, 2)), '%') AS [Percentage_share],            
        CASE SM.IsActive WHEN 1 THEN 'Active' ELSE 'Deactivate' END AS [Vendor_Status],        
        ROW_NUMBER() OVER (ORDER BY         
            CASE            
                WHEN SM.SupplierName = 'Eetglobal' THEN 'Eetglobal (W2M)'            
                WHEN SM.Id = 30 AND HB.SupplierCurrencyCode = 'INR' THEN 'agoda'            
                WHEN SM.Id = 12 AND HB.SupplierCurrencyCode = 'INR' THEN 'Expedia-INR'            
                ELSE SM.SupplierName            
            END) AS SortOrder   
   ,MAx(SM.SupplierType) as SupplierType  
    FROM            
        B2BHotelSupplierMaster SM  WITH (NOLOCK)           
        LEFT OUTER JOIN Hotel_BookMaster HB  WITH (NOLOCK) ON SM.Id = HB.SupplierPkId            
        AND HB.CurrentStatus = 'Vouchered'  
        AND CAST(HB.inserteddate AS DATE) BETWEEN  DATEADD(day, -1, CAST(GETDATE() AS DATE)) AND DATEADD(day, -1, CAST(GETDATE() AS DATE))               
   where sm.IsActive=1  
   GROUP BY            
        CASE            
            WHEN SM.SupplierName = 'Eetglobal' THEN 'Eetglobal (W2M)'            
            WHEN SM.Id = 30 AND HB.SupplierCurrencyCode = 'INR' THEN 'agoda'            
            WHEN SM.Id = 12 AND HB.SupplierCurrencyCode = 'INR' THEN 'Expedia-INR'            
            ELSE SM.SupplierName            
        END,             
        SM.Id,        
        SM.IsActive,            
        HB.SupplierCurrencyCode        
),        
TotalSummary AS (        
    SELECT            
        'Total' AS [Vendor_Name],            
        '-' AS [Vendor_Billing_Currency],            
        '-' AS [Total_Booking_foriegn_Currency],            
        CONCAT(CAST(SUM(CAST(SUBSTRING(total_booking_amount, 1, CHARINDEX(' ', total_booking_amount) - 1) AS DECIMAL(18, 2))) AS DECIMAL(18, 2)), ' INR') AS [Total_Booking_Amount],            
        SUM([Booking_count]) AS [Booking_count],            
        '100%' AS [Percentage_share],            
        '-' AS [Vendor_Status],        
        99999 AS SortOrder ,   
  '' As SupplierType  
    FROM ActiveVendors        
),      
      
Main As(      
      
SELECT * FROM ActiveVendors WHERE Vendor_Status = 'Active'        
UNION         
SELECT * FROM TotalSummary        
      
)      
      
      
      
        
SELECT * INTO #Temp2 FROM (        
    SELECT *,1 + ROW_NUMBER() OVER (ORDER BY vendor_name) AS rowno FROM ActiveVendors WHERE Vendor_Status = 'Active'  and  SupplierType='Hotel'      
    UNION ALL        
    SELECT *,10000 FROM TotalSummary  where  SupplierType=''  
) AS Result;        
        
-- Select from Temp Table with Order By Clause        
--SELECT * FROM #Temp2 ORDER BY SortOrder, Vendor_Name;        
       
      
      
        
        
        
    -- Generate HTML Report            
IF @@ROWCOUNT > 0            
BEGIN            
    DECLARE @s VARCHAR(max)            
    DECLARE @xml NVARCHAR(MAX)            
    DECLARE @body NVARCHAR(MAX)            
            
    SET @xml = CAST((SELECT [vendor_name] AS 'td', '', [Vendor_Billing_Currency] AS 'td', '',            
               [Total_Booking_foriegn_Currency] AS 'td', '', [Total_Booking_Amount] AS 'td', '', [Booking_count] AS 'td', '',            
               [Percentage_share] AS 'td', '', [Vendor_Status] AS 'td'            
    FROM #Temp2   order by rowno       
    FOR XML PATH('tr'), ELEMENTS) AS NVARCHAR(MAX))            
            
    SET @body = '<html>            
    <head>            
        <style type="text/css">            
            .styled-table {            
  border-collapse: collapse;            
                margin: 25px 0;            
                font-size: 0.9em;            
                font-family: sans-serif;            
                min-width: 400px;            
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);            
            }            
            
           .styled-table thead tr {            
                background-color: #0000FF;            
                color: #ffffff;            
                text-align: left;            
            }            
            
            .styled-table th,            
            .styled-table td {            
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
                font-weight: bold;            
            }            
        </style>            
    </head>            
    <body>            
        <H3>TrvlNxt Hotel Daily Vendor Sale Report ' + CONVERT(VARCHAR(12), GETDATE() - 1, 107) + '</H3>            
        <table class="styled-table">            
            <thead>            
                <tr>            
                    <th> Vendor Name </th>            
                    <th> Vendor Billing Country </th>            
                    <th> Total Booking In Foreign Currency </th>            
                    <th> Total Booking Amount </th>            
                    <th> Booking Count </th>            
                    <th> Percentage Share </th>            
                    <th> Vendor Status </th>            
                </tr>            
            </thead>            
            <tbody>' + @xml + '</tbody>            
        </table>            
    </body>            
    </html>'            
 SET @s = 'TrvlNxt Hotel Daily Vendor Sale Report '+' '+CONVERT(VARCHAR(12),GETDATE()-1,107)            
          
            
--EXEC msdb.dbo.sp_send_dbmail            
--@profile_name = 'DBA_Automations',             
--@body = @body,            
--@body_format ='HTML',            
----@recipients ='dba@riya.travel;developers@riya.travel',        
--@recipients ='dba@riya.travel;priti.kadam@riya.travel;developers@riya.travel;fahad.anwar@riya.travel',            
--@subject = @s;            
END            
            
-- Drop Temp Table            
--DROP TABLE #Temp            
--DROP TABLE #Temp2            
--DROP TABLE #Temp3             
            
        
        
end 