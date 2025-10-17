CREATE proc [dbo].[spInsertSSR]          
            @fkBookMaster bigint =null          
           ,@fkPassengerid bigint =null          
           ,@fkItenary bigint =null          
           ,@SSR_Type varchar(25) =null          
           ,@SSR_Name varchar(50) =null          
           ,@SSR_Code varchar(25) =null          
     ,@SSR_Amount money =null          
     ,@SSR_Status tinyint =null          
           ,@createdBy int =null          
     ,@EMDTicketNumber Varchar(100)=null        
  ,@TrackID varchar(MAX)=null      
  ,@ERPTicketNum Varchar(20)=null      
  ,@ParentOrderId Varchar(50)=null      
  ,@SSRType Varchar(50)=null
  ,@ssrBookingType Varchar(50)=null     
AS          
BEGIN          
      
	 DECLARE @EMDAirCode varchar(5); 
 DECLARE @OnlyEMDTicketNum varchar(20); 
 if @EMDTicketNumber is not null and len(@EMDTicketNumber) >= 14
begin 
	set @EMDAirCode= SUBSTRING(@EMDTicketNumber,0,4)
	set @OnlyEMDTicketNum= SUBSTRING(@EMDTicketNumber,5,15)
end
else
begin
	set @OnlyEMDTicketNum= @EMDTicketNumber
end	  

 if(@ERPTicketNum = 'null' OR @ERPTicketNum = '' OR @ERPTicketNum is null)      
 begin      
  INSERT INTO [dbo].[tblSSRDetails]          
       (fkBookMaster          
       ,fkPassengerid          
       ,fkItenary          
    ,SSR_Type          
       ,SSR_Name          
       ,SSR_Code          
       ,SSR_Amount          
       ,SSR_Status          
       ,createdBy          
       ,createdDate          
    ,EMDTicketNumber  
	,EMDAirLineCode
    ,TrackID   
	,ssrBookingType
       )          
    VALUES          
       (          
     @fkBookMaster          
       ,@fkPassengerid          
       ,@fkItenary          
    ,@SSR_Type          
       ,@SSR_Name          
       ,@SSR_Code          
       ,@SSR_Amount          
       ,@SSR_Status          
       ,@createdBy          
       ,getdate()          
    ,@OnlyEMDTicketNum
	,@EMDAirCode       
    ,@TrackID   
	,@ssrBookingType
    )          
    end      
 else      
 begin      
 --apiout used      
 DECLARE @Ticketnum varchar(100);      
      
 --set @Ticketnum = @ERPTicketNum +''+ (select cast(count(distinct( ParentOrderId))+1 as varchar(20))  from tblSSRDetails     
 --    where fkPassengerid= @fkPassengerid       
 --    and ParentOrderId != @ParentOrderId       
 --    and ERPTicketNum !=''    
 --    and SSR_Type= @SSRType)       
    
       
 set @Ticketnum = (select count (distinct (ParentOrderId))+1  from tblSSRDetails where SSR_Type=@SSR_Type and fkPassengerid= @fkPassengerid and ParentOrderId != @ParentOrderId     
 and ERPTicketNum !='')    
 set @ERPTicketNum =@ERPTicketNum +''+ @Ticketnum;     
     --where fkPassengerid= @fkPassengerid       
     --and ParentOrderId != @ParentOrderId       
     --and ERPTicketNum !=''    
     --and SSR_Type= 'melas'    
      
    
  INSERT INTO [dbo].[tblSSRDetails]          
      (fkBookMaster          
      ,fkPassengerid          
      ,fkItenary          
   ,SSR_Type          
      ,SSR_Name          
      ,SSR_Code          
      ,SSR_Amount          
      ,SSR_Status          
      ,createdBy          
      ,createdDate          
   ,EMDTicketNumber   
   ,EMDAirLineCode
   ,TrackID        
   ,ERPTicketNum   
   ,ParentOrderId  
   ,ssrBookingType
      )          
   VALUES          
      (          
    @fkBookMaster          
      ,@fkPassengerid          
      ,@fkItenary          
   ,@SSR_Type          
      ,@SSR_Name          
      ,@SSR_Code          
      ,@SSR_Amount          
      ,@SSR_Status          
      ,@createdBy          
      ,getdate()          
   ,@OnlyEMDTicketNum    
   ,@EMDAirCode       
   ,@TrackID        
   ,@ERPTicketNum         
   ,@ParentOrderId  
   ,@ssrBookingType
   )       
    
    
    
 end      
end          
          
          
    
    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertSSR] TO [rt_read]
    AS [dbo];

