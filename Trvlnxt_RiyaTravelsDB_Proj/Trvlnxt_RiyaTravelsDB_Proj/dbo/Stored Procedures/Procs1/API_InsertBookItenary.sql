          
CREATE proc [dbo].[API_InsertBookItenary]          
            @fkBookMaster bigint          
           ,@orderId varchar(30)=null       
     ,@airlinepnr varchar(50) = null             
           ,@frmSector varchar(50)          
           ,@toSector varchar(50)          
           ,@fromAirport varchar(150)          
           ,@toAirport varchar(150)          
           ,@airName varchar(150)=NULL          
           ,@operatingCarrier varchar(50) = null          
           ,@airCode varchar(10)=null          
           ,@equipment varchar(100)=null          
           ,@flightNo varchar(10)=null          
           ,@isReturnJourney bit = 0      
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
           ,@CarbonEmission varchar(50)=NULL         
           ,@CarbonEmissionFullText NVARCHAR(300)=NULL         
           ,@IsCarbonEmissionedRun bit=NULL         
           ,@CrabonInsertedDate varchar(50)=NULL        
           ,@flightLegMileage varchar(20)=NULL         
           ,@flightLegMileageUnit varchar(10)=NULL  
     ,@ViaSector varchar(3)=NULL
	 	 ,@ParentOrderId varchar(max)=null 
	 ,@ReIssueDate datetime=null 
as          
begin          
  INSERT INTO [dbo].[tblBookItenary]          
           (TotalTimeStopOver      
     ,[fkBookMaster]          
           ,[orderId]         
     ,[airlinePNR]          
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
  ,Via
  ,ParentOrderId
  ,ReIssueDate)          
     VALUES          
           (@TotalTimeStopOver      
     ,@fkBookMaster          
           ,@orderId         
     ,@airlinepnr           
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
  ,@ViaSector
  ,@ParentOrderId
  ,@ReIssueDate)          
          
    select SCOPE_IDENTITY();          
end          
          
           