CREATE Procedure SS.SS_Proc_InsertActivitySearchData              
@AgentId int=0,              
@CityId varchar(100)='',              
@CityName varchar(200)='',              
@TravelFrom varchar(200)='',              
@Nationality varchar(200)='',              
@State varchar(100)='',               
@BookingCountryCode varchar(50)='',               
@Lat varchar(500)='',               
@Long varchar(500)='',                    
@CheckIn datetime = '',          
@CheckOut datetime = '',                  
@SearchType varchar(50) = '',        
@Residence varchar(50) = ''     
As              
Begin              
    insert into SS.SS_ActivitySearchAvailablityData(AgentId,CityId,CityName,TravelFrom,Nationality,State,BookingCountryCode,Lat,Long,InsertedDate,CheckIn,CheckOut,SearchType,Residence) values              
 (@AgentId,@CityId,@CityName,@TravelFrom,@Nationality,@State,@BookingCountryCode,@Lat,@Long,GETDATE(),@CheckIn,@CheckOut,@SearchType,@Residence)              
END