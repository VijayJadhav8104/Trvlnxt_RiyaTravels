
   --exec   '[Hotel].[Proc_RetriveHotelReconInfo_new]'  
CREATE proc [Hotel].[Proc_RetriveHotelReconInfo_new] -- 'TNHAPI00009776'          
@BookingId varchar(50)=''           
As                   
begin           
if(@BookingId='')        
Begin        
 Declare @SchedularCount Int=0;        
 set @SchedularCount=(select COUNT(id) as Scount from RetriveHotelReconSchedularInfo where Status='Success' and MethodName='RetriveHotelReconInfo' and  datediff(HOUR,inserteddate,GETDATE())>8 and cast(inserteddate as date)=cast(GETDATE() as date))        
        
        
 if(@SchedularCount<=2)        
 Begin        
  select   BookingReference,searchApiId as cid,RiyaAgentID as agentID,a.userTypeID as usertype,pkId,h.inserteddate             
  --,pkId,CheckInDate,h.inserteddate , CurrentStatus              
  from Hotel_BookMaster h              
  left join agentlogin a on a.UserID=RiyaAgentID           
  where cast(CheckInDate as Date)> cast(getdate() as date)   
   
  --and CurrentStatus!='Not Found'         -- Removed as discussed with Faizan    
 --and BookingReference='TNH00020704'        
  order by h.inserteddate DEsc          
 End        
END        
ELse        
Begin        
        
select BookingReference,searchApiId as cid,RiyaAgentID as agentID,a.userTypeID as usertype,pkId,h.inserteddate             
  --,pkId,CheckInDate,h.inserteddate , CurrentStatus              
  from Hotel_BookMaster h              
  left join agentlogin a on a.UserID=RiyaAgentID           
  where         
  --cast(CheckInDate as Date)> cast(getdate() as date) and CurrentStatus!='Not Found'         
   h.BookingReference=@BookingId    
    
 --and BookingReference='TNH00020704'        
  order by 1 DEsc          
        
END        
        
END 
