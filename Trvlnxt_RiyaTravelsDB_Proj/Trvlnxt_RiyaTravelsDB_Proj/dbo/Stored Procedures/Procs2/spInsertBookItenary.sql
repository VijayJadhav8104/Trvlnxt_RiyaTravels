CREATE proc [dbo].[spInsertBookItenary]      
            @fkBookMaster bigint        
           ,@orderId varchar(30)=null        
           ,@frmSector varchar(50)        
           ,@toSector varchar(50)        
           ,@fromAirport varchar(150)        
           ,@toAirport varchar(150)        
           ,@airName varchar(150)=NULL        
           ,@operatingCarrier varchar(50) = null        
           ,@airCode varchar(10)=null        
           ,@equipment varchar(100)=null        
           ,@flightNo varchar(10)=null        
           ,@isReturnJourney bit        
           ,@deptDateTime datetime=null       
           ,@arrivalDateTime datetime=null        
           ,@cabin varchar(30)=null        
           ,@farebasis varchar(30)=null        
     ,@fromTerminal varchar(20)=null        
     ,@toTerminal varchar(20)=null        
     ,@Commission decimal(18,0)=null        
      ,@TotalTimeStopOver varchar(30)=null        
   ,@FareName varchar(50)=null        
   ,@ClassCode nvarchar(50)=null        
   ,@FlightID NVARCHAR(50)=NULL    
    ,@CarbonEmission varchar(100)=NULL     
   ,@CarbonEmissionFullText NVARCHAR(300)=NULL     
   ,@IsCarbonEmissionedRun bit=NULL     
   ,@CrabonInsertedDate varchar(50)=NULL     
   ,@flightLegMileage varchar(100)=NULL     
   ,@flightLegMileageUnit varchar(50)=NULL  
     ,@ViaSector varchar(10)=NULL
as        
begin        
  INSERT INTO [dbo].[tblBookItenary]        
           (TotalTimeStopOver,[fkBookMaster]        
           ,[orderId]        
           ,[frmSector]        
           ,[toSector]        
           ,[fromAirport]        
           ,[toAirport]        
           ,[airName]        
           ,[operatingCarrier]        
           ,[airCode]        
           ,[equipment]        
           ,[flightNo]        
           ,[isReturnJourney]        
           ,[depDate]        
           ,[arrivalDate]        
        
           ,[deptTime]        
           ,[arrivalTime]        
        
           ,[cabin]        
           ,[farebasis]        
     ,fromTerminal        
     ,toTerminal        
     ,Commission        
     ,FareName    
  ,ClassCode    
  ,FlightID    
  ,CarbonEmission    
  ,CarbonEmissionFullText    
  ,IsCarbonEmissionedRun    
  ,CrabonInsertedDate    
  ,flightLegMileage    
  ,flightLegMileageUnit    
  ,Via)       
     VALUES        
           (@TotalTimeStopOver,@fkBookMaster        
           ,@orderId        
           ,@frmSector        
           ,@toSector        
           ,@fromAirport        
           ,@toAirport        
           ,@airName        
           ,@operatingCarrier        
           ,@airCode        
           ,@equipment        
           ,@flightNo        
           ,@isReturnJourney        
           ,@deptDateTime        
           ,@arrivalDateTime        
        
           ,@deptDateTime        
           ,@arrivalDateTime        
           ,@cabin        
           ,@farebasis        
     ,@fromTerminal        
     ,@toTerminal        
      ,@Commission        
   ,@FareName    
   ,@ClassCode    
   ,@FlightID    
   ,@CarbonEmission    
  ,@CarbonEmissionFullText    
  ,@IsCarbonEmissionedRun    
  ,@CrabonInsertedDate    
  ,@flightLegMileage    
  ,@flightLegMileageUnit    
  ,@ViaSector)         
        
    select SCOPE_IDENTITY();        
end        
        
         
        
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertBookItenary] TO [rt_read]
    AS [dbo];

