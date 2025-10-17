-- =============================================          
-- Author:  <Author,,Name>          
-- Create date: <Create Date,,>          
-- Description: <Description,,>          
-- =============================================          
CREATE PROCEDURE [Hotel].[new_sp_AmadeusReport_UAT]           
 @PkId int = null,        
 @fromDate DateTime = null,          
 @ToDate DateTime = null,          
 @Action Varchar(30)=null          
AS          
BEGIN          
          
if(@Action='display')          
begin          
 select           
 * from [Hotel].tblAmedeousPnr           
 where   
 AmadeusConfId=@PkId   
 and BookingDate between @fromDate and DATEADD(day, 1, @ToDate)  
 and PartialInfo=1  
 union   
   
 select           
 * from [Hotel].tblAmedeousPnr           
 where   
 AmadeusConfId=@PkId   
 and BookingDate between @fromDate and DATEADD(day, 1, @ToDate)  
 and PartialInfo=0  
  
order by BookingDate          
end          
          
else if(@Action='Excel')          
begin          
           
 SELECT ROW_NUMBER() OVER (  
  ORDER BY (BookingDate)  
  ) AS 'Sr No'  
 ,'' AS 'RIYA PNR'  
 ,PnrNo  
 ,convert(VARCHAR, BookingDate, 6) AS BookingDate  
 ,'' AS 'Booking Status'  
 ,CASE   
  WHEN ISNUMERIC(EntityCode) < 4000  
   THEN 'IND'  
  WHEN ISNUMERIC(EntityCode) >= 4000  
   THEN 'GEO'  
  ELSE EntityCode  
  END AS 'IND/GEO'  
 ,FORMAT(BookingDate, 'MMM yy') AS 'MIS MONTH'  
 ,'RBT' AS TMCName  
 ,TASNumber  
 ,EntityCode  
 ,CASE   
  WHEN BookedCurrency = 'INR'  
   THEN 'DOM'  
  ELSE 'INT'  
  END AS 'Travel Scope(INT/DOM)'  
 ,EmployeeID  
 ,  
 --UPPER(EmployeeName) as 'EmployeeName',          
 UPPER(EmployeeFirstName) + ' ' + UPPER(EmployeeSurname) AS EmployeeName  
 ,  
 -- UPPER(EmployeeSurname) as LastName,          
 TravelPlan  
 ,EmployeeBand  
 ,R.Region AS REGION  
 ,R.Country AS 'HotelBookedCountry'  
 ,  
 -- case when HotelBookedCountry = 'INDIA' then 'IN' when HotelBookedCountry = 'UNITED STATES OF AMERICA' then 'US' end as 'Country Code',          
 upper(r.[Country code]) AS 'Country Code'  
 ,CityName + ' (' + HotelBookedCity + ')' AS HotelBookedCity  
 ,FORMAT(CheckIndate, 'ddd, dd MMM yyyy hh:mm tt') AS CheckIndate 
 ,FORMAT(CheckOutdate, 'ddd, dd MMM yyyy hh:mm tt') AS CheckOutdate  
 ,A.RoomType AS Roomtype  
 ,ROUND(RoomNight, 0) AS RoomNight  
 ,HotelName  
 ,HotelAddress  
 ,isnull(A.Breakfast, 'No') AS Breakfast  
 ,isnull(A.Internet, 'No') AS Internet  
 ,HotelConfirmationNumber  
 ,A.RateType  
 ,  
 -- A.RoomType,               
 BookedCurrency  
 ,CAST(SUM(CAST(APR.priAmount AS DECIMAL(10, 2)) / A.RoomNight) AS DECIMAL(10, 2)) AS BookedRatePerNightExTax  
 ,  
 --cast(BookedRatePerNightExTax as decimal(10,2)) as BookedRatePerNightExTax,          
 CASE   
  WHEN A.RoomNight = '0.000'  
   OR A.RoomNight IS NULL  
   THEN FullTrnAmountIncTax  
  ELSE FullTrnAmountIncTax / cast(A.RoomNight AS DECIMAL(10, 2))  
  END AS FullTrnAmountIncTax  
 ,FullTrnAmountIncTax AS 'Full Transaction Amount in Hotel local currency (Inclusive of Taxes)'  
 ,(  
  SELECT TOP 1 roe  
  FROM [Hotel].tblAmedeousPnr AA  
  INNER JOIN roe RR ON cast(AA.BookingDate AS DATE) = cast(RR.InserDate AS DATE)  
   AND FromCur = 'INR'  
   AND ToCur = A.BookedCurrency  
  ) AS ROE  
 ,CASE   
  WHEN AgentSignature = '9996WS'  
   THEN 'Online'  
  ELSE 'Offline'  
  END AS 'Booking Online/ Offline'  
 ,Deviation  
 ,'' AS Remark  
 ,convert(VARCHAR, A.InsertedDate, 6) AS InsertedDate  
 ,'' AS updatedby  
 ,isnull(A.DeviationApprover, '') AS DeviationApprover  
 ,isnull(A.ConcurId, '') AS ConcurId  
 ,isnull(A.EmployeesBilliableToClient, '') AS EmployeesBilliableToClient  
 ,isnull(A.TravelCostReimbursableByClient, '') AS TravelCostReimbursableByClient  
FROM [Hotel].tblAmedeousPnr A  
LEFT JOIN [hotel].tblRegionList R ON A.HotelBookedCountry = R.[Country code]  
LEFT JOIN [Hotel].AmsdeusPnrPerNightRate APR ON A.PnrNo = APR.PNR  
WHERE AmadeusConfId = @PkId  
 AND BookingDate BETWEEN @fromDate  
  AND DATEADD(day, 1, @ToDate)  
 AND PartialInfo = 0  
  Group by A.PnrNo,BookingDate,EntityCode,TASNumber,BookedCurrency,EmployeeID,EmployeeFirstName,EmployeeSurname,          
   TravelPlan,EmployeeBand,R.Region,R.Country,r.[Country code],HotelBookedCity,CityName,CheckIndate,CheckOutdate,          
   A.RoomType,RoomNight,HotelName,HotelAddress,A.Breakfast,A.Internet,HotelConfirmationNumber,A.RateType,BookedRatePerNightIncTax,          
   FullTrnAmountIncTax,AgentSignature,Deviation,A.InsertedDate,A.DeviationApprover,A.ConcurId,A.EmployeesBilliableToClient,A.TravelCostReimbursableByClient          
  
 union  
 SELECT ROW_NUMBER() OVER (  
  ORDER BY (BookingDate)  
  ) AS 'Sr No'  
 ,'' AS 'RIYA PNR'  
 ,PnrNo  
 ,convert(VARCHAR, BookingDate, 6) AS BookingDate  
 ,'' AS 'Booking Status'  
 ,CASE   
  WHEN ISNUMERIC(EntityCode) < 4000  
   THEN 'IND'  
  WHEN ISNUMERIC(EntityCode) >= 4000  
   THEN 'GEO'  
  ELSE EntityCode  
  END AS 'IND/GEO'  
 ,FORMAT(BookingDate, 'MMM yy') AS 'MIS MONTH'  
 ,'RBT' AS TMCName  
 ,TASNumber  
 ,EntityCode  
 ,CASE   
  WHEN BookedCurrency = 'INR'  
   THEN 'DOM'  
  ELSE 'INT'  
  END AS 'Travel Scope(INT/DOM)'  
 ,EmployeeID  
 ,  
 --UPPER(EmployeeName) as 'EmployeeName',          
 UPPER(EmployeeFirstName) + ' ' + UPPER(EmployeeSurname) AS EmployeeName  
 ,  
 -- UPPER(EmployeeSurname) as LastName,          
 TravelPlan  
 ,EmployeeBand  
 ,R.Region AS REGION  
 ,R.Country AS 'HotelBookedCountry'  
 ,  
 -- case when HotelBookedCountry = 'INDIA' then 'IN' when HotelBookedCountry = 'UNITED STATES OF AMERICA' then 'US' end as 'Country Code',          
 upper(r.[Country code]) AS 'Country Code'  
 ,CityName + ' (' + HotelBookedCity + ')' AS HotelBookedCity  
 ,'' AS CheckIndate  
 ,'' AS CheckOutdate  
 ,A.RoomType AS Roomtype  
 ,ROUND(RoomNight, 0) AS RoomNight  
 ,HotelName  
 ,HotelAddress  
 ,isnull(A.Breakfast, 'No') AS Breakfast  
 ,isnull(A.Internet, 'No') AS Internet  
 ,HotelConfirmationNumber  
 ,A.RateType  
 ,  
 -- A.RoomType,               
 BookedCurrency  
 ,CAST(SUM(CAST(APR.priAmount AS DECIMAL(10, 2)) / A.RoomNight) AS DECIMAL(10, 2)) AS BookedRatePerNightExTax  
 ,  
 --cast(BookedRatePerNightExTax as decimal(10,2)) as BookedRatePerNightExTax,          
 CASE   
  WHEN A.RoomNight = '0.000'  
   OR A.RoomNight IS NULL  
   THEN FullTrnAmountIncTax  
  ELSE FullTrnAmountIncTax / cast(A.RoomNight AS DECIMAL(10, 2))  
  END AS FullTrnAmountIncTax  
 ,FullTrnAmountIncTax AS 'Full Transaction Amount in Hotel local currency (Inclusive of Taxes)'  
 ,(  
  SELECT TOP 1 roe  
  FROM [Hotel].tblAmedeousPnr AA  
  INNER JOIN roe RR ON cast(AA.BookingDate AS DATE) = cast(RR.InserDate AS DATE)  
   AND FromCur = 'INR'  
   AND ToCur = A.BookedCurrency  
  ) AS ROE  
 ,CASE   
  WHEN AgentSignature = '9996WS'  
   THEN 'Online'  
  ELSE 'Offline'  
  END AS 'Booking Online/ Offline'  
 ,Deviation  
 ,'' AS Remark  
 ,convert(VARCHAR, A.InsertedDate, 6) AS InsertedDate  
 ,'' AS updatedby  
 ,isnull(A.DeviationApprover, '') AS DeviationApprover  
 ,isnull(A.ConcurId, '') AS ConcurId  
 ,isnull(A.EmployeesBilliableToClient, '') AS EmployeesBilliableToClient  
 ,isnull(A.TravelCostReimbursableByClient, '') AS TravelCostReimbursableByClient  
FROM [Hotel].tblAmedeousPnr A  
LEFT JOIN [hotel].tblRegionList R ON A.HotelBookedCountry = R.[Country code]  
LEFT JOIN [Hotel].AmsdeusPnrPerNightRate APR ON A.PnrNo = APR.PNR  
WHERE AmadeusConfId = @PkId  
 AND BookingDate BETWEEN @fromDate  
  AND DATEADD(day, 1, @ToDate)  
 AND PartialInfo = 1  
   
 Group by A.PnrNo,BookingDate,EntityCode,TASNumber,BookedCurrency,EmployeeID,EmployeeFirstName,EmployeeSurname,          
   TravelPlan,EmployeeBand,R.Region,R.Country,r.[Country code],HotelBookedCity,CityName,CheckIndate,CheckOutdate,          
   A.RoomType,RoomNight,HotelName,HotelAddress,A.Breakfast,A.Internet,HotelConfirmationNumber,A.RateType,BookedRatePerNightIncTax,          
   FullTrnAmountIncTax,AgentSignature,Deviation,A.InsertedDate,A.DeviationApprover,A.ConcurId,A.EmployeesBilliableToClient,A.TravelCostReimbursableByClient          
 order by [Sr No]          
          
          
End           
END 