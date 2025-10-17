CREATE Procedure Proc_InsertHotelSearchData              
@AgentId int=0,              
@CityId varchar(100)='',              
@CityName varchar(200)='',              
@TravelFrom varchar(200)='',              
@Nationality varchar(200)='',              
@State varchar(100)='',               
@BookingCountryCode varchar(50)='',               
@Lat varchar(500)='',               
@Long varchar(500)='',               
@AdultCount int=0,              
@ChildCount int=0,           
@CheckIn datetime = '',          
@CheckOut datetime = '',          
@RoomCount int,          
@SearchType varchar(50) = '',        
@Residence varchar(50) = '',        
@OccupancyAsJson varchar(Max) = null,
@ReferenceID int=0
As              
Begin              
    insert into HotelSearchAvailablityData(AgentId,CityId,CityName,TravelFrom,Nationality,State,BookingCountryCode,Lat,Long,AdultCount,ChildCount,InsertedDate,CheckIn,CheckOut,RoomCount,SearchType,Residence,OccupancyAsJson,ReferenceID) values              
 (@AgentId,@CityId,@CityName,@TravelFrom,@Nationality,@State,@BookingCountryCode,@Lat,@Long,@AdultCount,@ChildCount,GETDATE(),@CheckIn,@CheckOut,@RoomCount,@SearchType,@Residence,@OccupancyAsJson,@ReferenceID)              
END