CREATE PROCEDURE [dbo].[AddSearchCacheLogsToDb]  
  
@IPAddress varchar(50)=NULL,
@fromSec varchar(50)=NULL,
@toSec varchar(50)=NULL,
@DeviceInfoWithLocation varchar(max)=NULL,
@TripType varchar(50)=NULL,
@DepartureDate date=NULL,  
@ReturnDate varchar(30)=NULL,  
@NoOfPassanger varchar(50)=NULL,
@Airline varchar(50)=NULL,
@Stop varchar(50)=NULL,
@LogDate datetime=NULL,  
@UserId varchar(10)=NULL,
@IsVPNEnabled bit=NULL
AS   
  
begin  
   insert into [dbo].[B2CSearchCacheLogs] (IPAddress, FromSector, ToSector, DeviceInfoWithLocation, TripType, DepartureDate, ReturnDate, NoOfPassanger, Airline, Stop, UserId, LogDate, IsVPNEnabled)  
   values (@IPAddress, @fromSec,@toSec,@DeviceInfoWithLocation,@TripType,@DepartureDate,@ReturnDate,@NoOfPassanger,@Airline,@Stop,@UserId,@LogDate,@IsVPNEnabled)  
end