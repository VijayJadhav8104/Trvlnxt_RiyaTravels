  
Create PROCEDURE [dbo].[UpdatetblBookItenaryCarbonEmission]   
@TotalTimeStopOver varchar(10) =null  
,@flightLegMileage varchar(10) =null  
,@flightLegMileageUnit varchar(50) =null
,@carbonDioxydeValue decimal(18,2) =null  
,@carbonDioxydeUnit varchar(100) =null
,@FromLocation varchar(10) =null
,@ToLocation varchar(10) =null
,@OrderID varchar(100) =null 

,@TotalflightLegMileage decimal(18,2) = 0
,@TotalcarbonDioxydeValue decimal(18,2) = 0

as 
begin
  
update tblBookItenary set TotalTimeStopOver = @TotalTimeStopOver 
,flightLegMileage = @flightLegMileage
,flightLegMileageUnit = @flightLegMileageUnit
,CarbonEmission = @carbonDioxydeValue
,CarbonEmissionFullText =@carbonDioxydeUnit
,IsCarbonEmissionedRun = 1
,CrabonInsertedDate = GETDATE()
 WHERE orderId = @OrderID AND frmSector = @FromLocation AND toSector = @ToLocation  

 update tblBookMaster set TotalflightLegMileage = @TotalflightLegMileage
 ,TotalCarbonEmission = @TotalcarbonDioxydeValue
 WHERE orderId = @OrderID

end
  
  