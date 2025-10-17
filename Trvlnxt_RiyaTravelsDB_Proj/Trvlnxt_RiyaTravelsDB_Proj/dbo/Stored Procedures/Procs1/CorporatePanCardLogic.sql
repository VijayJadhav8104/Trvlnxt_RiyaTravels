  
--CorporatePanCardLogic'indian','in','0'  
Create Procedure CorporatePanCardLogic    
@Nationalty varchar(100)=null,    
@BookingAgencyCountry varchar(50)=null,    
@CorporatePanReq varchar(50)=null    
AS    
Begin    
 if((@Nationalty ='indian' and @BookingAgencyCountry = 'in') and @CorporatePanReq = '0')    
 BEGIN    
 Select 'true' as PANRequired    
 END    
 else if((@Nationalty ='indian' and @BookingAgencyCountry = 'in') and @CorporatePanReq = '1')    
 BEGIN    
 Select 'false' as PANRequired    
 END    
 else if((@Nationalty !='indian' and @BookingAgencyCountry = 'in') and @CorporatePanReq = '0')    
 BEGIN    
 Select 'false' as PANRequired    
 END    
 else if((@Nationalty !='indian' and @BookingAgencyCountry = 'in') and @CorporatePanReq = '1')    
 BEGIN    
 Select 'false' as PANRequired    
 END    
 else if((@Nationalty ='indian' and @BookingAgencyCountry != 'in') and @CorporatePanReq = '0')    
 BEGIN    
 Select 'true' as PANRequired    
 END    
 else if((@Nationalty ='indian' and @BookingAgencyCountry != 'in') and @CorporatePanReq = '1')    
 BEGIN    
 Select 'true' as PANRequired    
 END    
 else if((@Nationalty !='indian' and @BookingAgencyCountry != 'in') and @CorporatePanReq = '0')    
 BEGIN    
 Select 'true' as PANRequired    
 END    
 else if((@Nationalty !='indian' and @BookingAgencyCountry != 'in') and @CorporatePanReq = '1')    
 BEGIN    
 Select 'true' as PANRequired    
 END    
 else    
 BEGIN    
 Select 'true' as PANRequired    
 END    
END