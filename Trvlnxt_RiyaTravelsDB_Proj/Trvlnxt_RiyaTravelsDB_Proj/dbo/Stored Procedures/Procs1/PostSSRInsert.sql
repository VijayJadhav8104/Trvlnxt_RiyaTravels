              
-- =============================================                  
-- Author:  <Author,,Name>                  
-- Create date: <Create Date,,>                  
-- Description: <Description,,>                  
-- =============================================                  
CREATE PROCEDURE [dbo].[PostSSRInsert]                  
 @SSRType varchar(30) ,                  
 @SSRName varchar(max)=null,                  
 @SSRCode varchar(50)=null,                  
 @Amount decimal(18,2)=0.0,                  
 @Departure varchar(10)=null,                  
 @Arrival varchar(10)=null,                  
 @PaxPosition int=0,                  
 @PaxType varchar(10)=null,                  
 @journey int=0,                  
 @RiyaPnr varchar(20)  ,                
@paxfullName varchar(max)=null,            
@erpkey varchar(20)=null,            
@ParentOrderId varchar(50)=null,    
@EMDTicketNumber varchar(50)=null,
@ROE decimal(18,8)=0 ,
@SSRBookingType varchar(20) = null
AS                  
BEGIN                  
	set @RiyaPNR=(SELECT top 1 BM.riyaPNR FROM tblBookMaster BM                       
  INNER JOIN tblBookItenary BI ON BI.fkBookMaster=BM.pkId                       
  WHERE BM.riyaPNR=@RiyaPnr or BI.airlinePNR=@RiyaPnr or BM.GDSPNR=@RiyaPnr) 

  DECLARE @ItinaryId int =0,@fkBookMaster int,@PassengerId int=0   ,@ticketnum varchar(100) ,@ERPTicket varchar(100)             
  if @SSRType='Seat'                
  begin                 
   select @ItinaryId=i.pkId,@PassengerId=p.pid,@fkBookMaster=i.fkBookMaster from tblPassengerBookDetails p                 
   inner join tblBookMaster b on b.pkId =p.fkBookMaster                 
   inner join tblBookItenary i on i.fkBookMaster=b.pkId                 
   where b.riyaPNR=@RiyaPnr and i.frmSector=@Departure and i.toSector=@Arrival and Ltrim(rtrim(p.paxFName)) +' '+ Ltrim(rtrim(paxLName))=Ltrim(rtrim(@paxfullName))              
   --and trim(p.paxFName) +' '+ trim(paxLName)=trim(@paxfullName)                
  end                
  else                
  begin                
 if @journey=1                  
 BEGIN                  
  SET @fkBookMaster= (SELECT TOP 1 pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPnr and returnFlag=1 ORDER BY pkId DESC)                   
 END                  
 ELSE                  
 BEGIN                  
  SET @fkBookMaster= (SELECT TOP 1 pkId FROM tblBookMaster WHERE riyaPNR=@RiyaPnr and returnFlag=0 order by pkId asc)                   
 END                 
 if @SSRType='Baggage'                
 begin                
 set @ItinaryId=(SELECT top 1 pkId FROM tblBookItenary WHERE fkBookMaster=@fkBookMaster and frmSector=@Departure and toSector=@Arrival)                
 end                
 else                
 begin                
 set @ItinaryId=(SELECT pkId FROM tblBookItenary WHERE fkBookMaster=@fkBookMaster and frmSector=@Departure and toSector=@Arrival)                  
  end                
 SET @PassengerId=(SELECT pid FROM (SELECT ROW_NUMBER() over (order by paxType ASC) row_num,pid,paxType  FROM tblPassengerBookDetails where fkBookMaster=@fkBookMaster and paxType=@PaxType ) t WHERE row_num =@PaxPosition)                  
  end                
              
  set @ticketnum=(select ticketnumber from tblPassengerBookDetails where pid=@PassengerId)            
  set @ERPTicket=@ticketnum+''+@erpkey+''+(select CAST(count(distinct( ParentOrderId))+1 as varchar(10)) from tblSSRDetails        
  where fkPassengerid= @PassengerId and ParentOrderId!=@ParentOrderId and ERPTicketNum is not null and SSR_Type= @SSRType)            
 INSERT INTO tblSSRDetails                   
 (fkBookMaster,                  
 fkPassengerid,                  
 fkItenary,                  
 SSR_Type,                  
 SSR_Name,                  
 SSR_Code,                  
 SSR_Amount,                  
 SSR_Status,                  
 createdDate            
 ,ERPTicketNum            
 ,ParentOrderId
 ,EMDTicketNumber
 ,ROE
 ,ssrBookingType)                  
 VALUES(                  
 @fkBookMaster,                  
 @PassengerId,                  
 @ItinaryId,                  
 @SSRType,                  
 @SSRName,                  
 @SSRCode,                  
 @Amount,                  
 1,                  
 GETDATE()            
 ,@ERPTicket                  
 ,@ParentOrderId
 ,@EMDTicketNumber
 ,@ROE
 ,@SSRBookingType)            
END 