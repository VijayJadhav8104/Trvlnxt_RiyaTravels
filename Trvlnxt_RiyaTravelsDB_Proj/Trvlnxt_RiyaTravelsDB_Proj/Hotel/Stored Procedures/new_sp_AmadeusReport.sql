--sp_helptext '[hotel].new_sp_AmadeusReport'
--select REPLACE	('Employee id1234','Employee id','')
-- =============================================        
-- Author:  <Author,,Name>        
-- Create date: <Create Date,,>     '10100027'   
--exec [Hotel].[new_sp_AmadeusReport] 1,'2025-08-10','2025-08-10','display'
-- Description: <Description,,>        
-- =============================================        
CREATE PROCEDURE [Hotel].[new_sp_AmadeusReport]         
 @PkId int = null,      
 @fromDate DateTime = null,        
 @ToDate DateTime = null,        
 @Action Varchar(30)=null        
AS        
BEGIN        
        
if(@Action='display')        
begin        
 select         
 Id,PnrNo,BookingDate,TASNumber,EntityCode,
 REPLACE(EmployeeID,'Employee id','') as  EmployeeID,EmployeeFirstName,EmployeeSurname,EmployeeName,TravelPlan,EmployeeBand,CityName,HotelBookedCountry,HotelBookedCity,CheckIndate,CheckOutdate,RoomNight,HotelName,HotelAddress,HotelConfirmationNumber,BookedCurrency,BookedRatePerNightIncTax,BookedRatePerNightExTax,FullTrnAmountIncTax,AgentSignature,Internet,Breakfast,Deviation,ErrorMessage,InsertedDate,RoomType,RateType,RoeRateBookingDate,AmadeusConfId,DeviationApprover,ConcurId,EmployeesBilliableToClient,TravelCostReimbursableByClient,PartialInfo

 from [Hotel].tblAmedeousPnr         
 where AmadeusConfId=@PkId and BookingDate between @fromDate and DATEADD(day, 1, @ToDate)  
 and isnull(PartialInfo,0)=0  
 order by BookingDate        
end        
        
else if(@Action='Excel')        
begin        
         
  select         
  ROW_NUMBER() Over(Order by (BookingDate)) as 'Sr No',        
   '' as 'RIYA PNR',        
   PnrNo,        
   convert(varchar, BookingDate, 6) as BookingDate,        
   '' as 'Booking Status',           
   case         
            
          
        
         
    when ISNUMERIC(EntityCode) < 4000 then 'IND'         
          
         
    when ISNUMERIC(EntityCode) >= 4000 then 'GEO'        
         
   else EntityCode         
   end as 'IND/GEO',        
   FORMAT(BookingDate, 'MMM yy') as 'MIS MONTH',        
   'RBT' as TMCName,        
   TASNumber,        
   EntityCode,        
   case when BookedCurrency = 'INR' then 'DOM' else 'INT' end as 'Travel Scope(INT/DOM)',        
   

    REPLACE	(EmployeeID,'Employee id','') as EmployeeID
   ,        
  --UPPER(EmployeeName) as 'EmployeeName',        
  UPPER(EmployeeFirstName) +' '+UPPER(EmployeeSurname)  as EmployeeName,        
 -- UPPER(EmployeeSurname) as LastName,        
   TravelPlan,        
   EmployeeBand,        
   R.Region as REGION,        
   R.Country as 'HotelBookedCountry',        
  -- case when HotelBookedCountry = 'INDIA' then 'IN' when HotelBookedCountry = 'UNITED STATES OF AMERICA' then 'US' end as 'Country Code',        
   upper(r.[Country code]) as 'Country Code',        
   CityName+' ('+HotelBookedCity+')' as HotelBookedCity,        
        
   convert(varchar, CheckIndate, 106) as CheckIndate,        
   convert(varchar, CheckOutdate, 106) as CheckOutdate,        
   A.RoomType as Roomtype,        
   ROUND(RoomNight,0) as RoomNight,        
   HotelName,        
   HotelAddress,        
   isnull(A.Breakfast,'No') as Breakfast,        
   isnull(A.Internet,'No') as Internet,        
   HotelConfirmationNumber,        
    A.RateType,             
   -- A.RoomType,             
   BookedCurrency,        
   CAST(SUM(CAST(APR.priAmount as decimal(10,2)) / A.RoomNight) as decimal(10,2)) as BookedRatePerNightExTax,        
   --cast(BookedRatePerNightExTax as decimal(10,2)) as BookedRatePerNightExTax,        
   case when A.RoomNight = '0.000' or A.RoomNight is null then FullTrnAmountIncTax else        
   FullTrnAmountIncTax / cast(A.RoomNight as decimal(10,2)) end as FullTrnAmountIncTax,        
        
   FullTrnAmountIncTax as 'Full Transaction Amount in Hotel local currency (Inclusive of Taxes)',        
   (select top 1 roe from  [Hotel].tblAmedeousPnr AA inner join roe RR on  cast(AA.BookingDate as date)=cast(RR.InserDate as Date) and FromCur='INR' and ToCur=A.BookedCurrency ) as ROE,        
   case when AgentSignature = '9996WS' then 'Online' else 'Offline' end as 'Booking Online/ Offline',        
   Deviation,        
   '' as Remark,        
   convert(varchar, A.InsertedDate, 6) as InsertedDate,        
   '' as updatedby,     
     
   isnull(A.DeviationApprover,'') as DeviationApprover,    
   isnull(A.ConcurId,'') as ConcurId,    
   isnull(A.EmployeesBilliableToClient,'') as EmployeesBilliableToClient,    
   isnull(A.TravelCostReimbursableByClient,'') as TravelCostReimbursableByClient  
  
   from [Hotel].tblAmedeousPnr A        
   left join [hotel].tblRegionList R on A.HotelBookedCountry=R.[Country code]        
   left join [Hotel].AmsdeusPnrPerNightRate APR on A.PnrNo = APR.PNR        
 where AmadeusConfId=@PkId and BookingDate between @fromDate and  DATEADD(day, 1, @ToDate)  
 and isnull(PartialInfo,0)=0  
   
 Group by A.PnrNo,BookingDate,EntityCode,TASNumber,BookedCurrency,EmployeeID,EmployeeFirstName,EmployeeSurname,        
   TravelPlan,EmployeeBand,R.Region,R.Country,r.[Country code],HotelBookedCity,CityName,CheckIndate,CheckOutdate,        
   A.RoomType,RoomNight,HotelName,HotelAddress,A.Breakfast,A.Internet,HotelConfirmationNumber,A.RateType,BookedRatePerNightIncTax,        
   FullTrnAmountIncTax,AgentSignature,Deviation,A.InsertedDate,A.DeviationApprover,A.ConcurId,A.EmployeesBilliableToClient,A.TravelCostReimbursableByClient        
 order by ROW_NUMBER() Over(Order by (BookingDate))        
        
        
End         
END        
        
        
   