Create proc [dbo].[API_Departure_Code_Records] -- exec [API_Departure_Code_Records] 'YYZ','DXB'  
@DepartureCode varchar(3)=''  
       
As        
BEGIN        
      
 if(@DepartureCode != '')        
 Begin        
  select NAME from tblAirportCity where CODE = @DepartureCode      
 END  
END 