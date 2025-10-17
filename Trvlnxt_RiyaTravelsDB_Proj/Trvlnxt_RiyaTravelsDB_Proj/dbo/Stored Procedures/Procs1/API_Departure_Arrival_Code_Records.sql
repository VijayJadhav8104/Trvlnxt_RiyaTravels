CREATE proc [dbo].[API_Departure_Arrival_Code_Records] -- exec [API_Departure_Arrival_Code_Records] 'YYZ','DXB'  
@DepartureCode varchar(3)=''   
,@ArrivalCode varchar(3)=''   
       
As        
BEGIN        
      
 if(@DepartureCode != '' and @ArrivalCode != '')        
 Begin        
  select NAME from tblAirportCity where CODE = @DepartureCode OR CODE = @ArrivalCode      
 END  
END 