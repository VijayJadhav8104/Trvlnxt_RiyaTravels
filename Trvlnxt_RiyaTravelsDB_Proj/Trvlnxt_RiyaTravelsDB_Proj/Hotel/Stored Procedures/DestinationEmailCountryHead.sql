  
  
CREATE Proc Hotel.DestinationEmailCountryHead          
@country varchar(500)=''

as          
begin          
          
        
  select ToEmail  as To_Email,BccEmail  as 'BccEmail' 
  
  from Hotel.tblDestinationEmailCountryHead where Country=@country
 --Local--                                  
--select 'gary.fernandes@riya.travel,tnsupport.hotels@riya.travel,developers@riya.travel' as To_Email, 
         
          
--LIVE --          
--select 'nitin@riya.travel,ashley.paul@riya.travel,fahad.anwar@riya.travel,subhash.a@riya.travel,amit.sarang@riya.travel'as To_Email,           
--'Amol.patil@riya.travel,Ashish.patil@riya.travel,faizan.shaikh@riya.travel,Priti.kadam@riya.travel,gary.fernandes@riya.travel,tnsupport.hotels@riya.travel,aman.wagde@oneriya.com' as 'BccEmail'          
          
end

