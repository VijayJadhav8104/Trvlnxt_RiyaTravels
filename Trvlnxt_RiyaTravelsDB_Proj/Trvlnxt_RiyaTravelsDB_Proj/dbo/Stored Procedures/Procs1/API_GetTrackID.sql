  
CREATE proc [dbo].[API_GetTrackID] --[API_GetTrackID] 'DPS','GOI' ,'2024-07-13','' ,'2024-06-21'      
        
@Departure varchar(20),      
@Arrival varchar(20),      
@DepartureDate varchar(100) = '',      
@ArrivalDate varchar(100) = '',      
@InsertedDate varchar(100) = ''      
        
As      
Begin        
           
declare @test AS VARCHAR(MAX);

set @test = 'select top 10 * from APIBookingAuthentication '      
set @test += ' where Departure = ''' +@Departure + ''''      
set @test += ' and Arrival = ''' +@Arrival + ''''      
      
if(@ArrivalDate != '' and @ArrivalDate != 'null' and @ArrivalDate is not null)      
begin      
 set @test += ' and Convert(date,ArrivalDate) = Convert(date,'''+@ArrivalDate+''')'      
end      
      
if(@InsertedDate != '' and @InsertedDate != 'null' and @InsertedDate is not null)      
begin      
 set @test += ' and Convert(date,InsertedDate) = Convert(date,'''+@InsertedDate+''')'      
end      
      
if(@DepartureDate != '' and @DepartureDate != 'null' and @DepartureDate is not null)      
begin      
 set @test += ' and Convert(date,DepartureDate) = Convert(date,'''+@DepartureDate+''')'      
end      
      
set @test += ' order by 1 desc'     
      
EXEC (@test)    
        
End 