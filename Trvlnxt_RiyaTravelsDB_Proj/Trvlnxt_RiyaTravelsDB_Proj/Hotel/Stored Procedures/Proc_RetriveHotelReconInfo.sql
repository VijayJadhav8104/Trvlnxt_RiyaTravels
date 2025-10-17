                         
                              
CREATE proc [Hotel].[Proc_RetriveHotelReconInfo] -- 'TNHAPI00009776'                                
@BookingId varchar(50)=''                                 
As                                         
begin    
                                     
if(@BookingId='')                                    
Begin                                    
                                     
                         
select BookingReference,searchApiId as cid,RiyaAgentID as agentID,          
a.userTypeID as usertype,          
h.pkId,h.inserteddate ,                
sh.CreateDate 'StatusLastUpdate',h.CheckInDate,h.CheckInTime,h.CheckOutDate,h.CheckOutTime, h.ChannelId as channel                   
, case when isnull(PCC,'')='' then  null else PCC end  as officeId          
      ,case when isnull(abd.Value,'')='' then null else abd.Value end as 'HGToken'        
                   ,h.SupplierUsername,h.SupplierName          
  from Hotel_BookMaster (nolock)  h               
  left join  Hotel_Status_History (nolock) sh on sh.FKHotelBookingId=h.pkId                  
  left join Hotel_Status_Master (nolock) sm on sm.Id=sh.FkStatusId             
  left join agentlogin (nolock) a on a.UserID=RiyaAgentID            
  left  join b2bregistration (nolock) b on b.FKUserID=RiyaAgentID          
  left join AgentSupplierProfileMapper (nolock) m on m.AgentId=b.PKID    and m.SupplierId=h.SupplierPkId            
  left join hotel.ApiBookData (nolock) abd on h.BookingReference= abd.BookingId and [Key]='HGToken'        
          
  where                           
                                   
                    
             cast(CheckOutDate as Date)>= cast(getdate()-2 as date)  ANd cast(sh.CreateDate as date)>=cast(GETDATE()-1 as date)       
         and sh.IsActive=1                       
                  
                  
  --and CurrentStatus!='Not Found'         -- Removed as discussed with Faizan                                
 --and BookingReference='TNH00020704'                                    
  order by h.inserteddate DEsc                                      
                                    
END                                    
ELse                                    
Begin                                    
                                    
                        
                                    
select BookingReference,searchApiId as cid,RiyaAgentID as agentID,          
a.userTypeID as usertype,          
h.pkId,h.inserteddate ,                
sh.CreateDate 'StatusLastUpdate',h.CheckInDate,h.CheckInTime,h.CheckOutDate,h.CheckOutTime, h.ChannelId as channel                   
,PCC as officeId          
            ,case when isnull(abd.Value,'')='' then null else abd.Value end as 'HGToken'        
        
                   ,h.SupplierUsername,h.SupplierName          
                             
  from Hotel_BookMaster (nolock) h               
  left join  Hotel_Status_History (nolock) sh on sh.FKHotelBookingId=h.pkId                  
  left join Hotel_Status_Master (nolock) sm on sm.Id=sh.FkStatusId             
  left join agentlogin (nolock) a on a.UserID=RiyaAgentID            
  left  join b2bregistration (nolock) b on b.FKUserID=RiyaAgentID          
  left join AgentSupplierProfileMapper (nolock) m on m.AgentId=b.PKID    and m.SupplierId=h.SupplierPkId           
  left join hotel.ApiBookData (nolock) abd on h.BookingReference= abd.BookingId and [Key]='HGToken'        
          
  where                           
                                              
  --cast(CheckInDate as Date)> cast(getdate() as date) and CurrentStatus!='Not Found'                                     
   h.BookingReference in (select ltrim (rtrim(value)) from dbo.fn_split( @BookingId ,',' ))          
                       and sh.IsActive=1                       
                  
 --and BookingReference='TNH00020704'                                    
  order by 1 DEsc                                      
                                    
END                                    
      
END 