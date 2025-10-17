CREATE Proc [Hotel].[DestinationEmailList]        
as        
begin        
        
--Local--        
--select 'gary.fernandes@riya.travel,tnsupport.hotels@riya.travel,developers@riya.travel' as To_Email, 'aman.wagde@oneriya.com' as 'BccEmail'        
        
--LIVE --        
select 'nitin@riya.travel,ashley.paul@riya.travel,fahad.anwar@riya.travel,subhash.a@riya.travel,amit.sarang@riya.travel,laxmikant.patil@riya.travel,rajat.panwar@riya.travel'as To_Email,         
'Amol.patil@riya.travel,Ashish.patil@riya.travel,faizan.shaikh@riya.travel,Priti.kadam@riya.travel,gary.fernandes@riya.travel,tnsupport.hotels@riya.travel,aman.wagde@oneriya.com' as 'BccEmail'        
        
end