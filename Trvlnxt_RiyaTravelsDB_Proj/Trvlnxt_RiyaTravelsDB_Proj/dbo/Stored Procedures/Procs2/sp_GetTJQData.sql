CREATE proc [dbo].[sp_GetTJQData]                        
                      
-- [sp_GetTJQData] '1','1','Retrive PNR,Retrive PNR Accounting,Retrieve PNR accounting - MultiTST,Web,ManualTicketing,Desktop,Mobile,offlineDesktop,Retrive PNR Accounting-TicketNumber','2022-07-15','2022-07-15' ,'-1' ,''                        
--exec [sp_GetTJQData] '1','1','GDS','2022-08-03','2022-08-03' ,'-1' ,'BOMVS34AD',''                             
                                
@IsBooked varchar(10)                                                                                
,@BookingStatus varchar(10)                                                                                
,@BookingSource varchar(MAX) = ''                                                                               
,@fromDate varchar(50) = '' --'2022-06-03'                                                                                
,@todate varchar(50) ='' --'2022-06-04'                                                                                
,@Status varchar(5)                                                            
,@OfficeIDList varchar(max)=''                      
as                                                                                              
BEGIN                                                     
                                                    
  --Create temp table                                                  
Declare @temp TABLE (pid bigint,Icust varchar(255),GDSPNR varchar(250),TicketNumber varchar(255),OfficeID varchar(250), PaxName varchar(MAX), sector varchar(100), toSector varchar(100), airName varchar(255),                                                
  
   flightNo varchar(250),travClass varchar(250),airlinePNR varchar(250), baggage varchar(250), farebasis varchar(250), depDate varchar(250), arrivalDate varchar(250), basicFare decimal(18,2),                                                  
   totalTax decimal(18,2),totalFare decimal(18,2),riyaPNR varchar(250),orderId varchar(250),Status varchar(250),IATACommission decimal(18,2),                                                  
   PLBCommission decimal(18,2),DropnetCommission decimal(18,2),FMCommission decimal(18,2),Markup decimal(18,2),B2BMarkup decimal(18,2),ServiceFee decimal(18,2),                                                  
   GST decimal(18,2),BFC int,YQ varchar(250),AgentROE decimal(18,2),UserType int,PaymentMode varchar(250),AgentID varchar(250), ROE decimal(18,2),TicketIssuanceError varchar(MAX),ERPResponseID varchar(MAX),IsBooked int,BookingStatus int,                  
              
   VesselName varchar(50),Bookedby varchar(15),CostCenter varchar(50),Traveltype varchar(20),EmpDimession varchar(50),Changedcostno varchar(50),Travelduration varchar(50),                                    
   TASreqno varchar(50),RequestID varchar(50),Companycodecc varchar(50),Projectcode varchar(50),DEVIATION_APPROVER_NAME_AND_EMPCODE varchar(255),LOWEST_LOGICAL_FARE varchar(255),LOWEST_LOGICAL_FARE_2 varchar(255),LOWEST_LOGICAL_FARE_3 varchar(255),          
   
   TotalCommission decimal (18,2),IssueDate varchar(100),Groupid VARCHAR(5),EmpID varchar(50),PushedBy varchar(50),
   DEVIATIONAPPROVER varchar(255),ConcurID varchar(50),EMPLOYEESPOSITION varchar(255),TRAVELCOSTREIMBURSABLE varchar(255))                                               
---------                                                  
                                                  
                                                  
IF (@Status = '1' OR @Status = '-1') --Pending,All                                                                               
BEGIN                                                    
insert into @temp                                                      
   Select                                                                                 
   pass.pid                                                                                
  ,(select top 1 Icast from B2BRegistration WITH (NOLOCK) where FKUserID = book.AgentID) as Icust                                                    
  ,book.GDSPNR                                     
  ,pass.ticketNum                                                          
  ,book.OfficeID                                                                                
  ,pass.title + ' ' + pass.paxFName +' '+pass.paxLName as PaxName                                   
  ,book.frmSector as sector                        
  ,(Select top 1 toSector from tblBookMaster as tblbooktosector WITH (NOLOCK) where book.riyaPNR =tblbooktosector.riyaPNR and tblbooktosector.GDSPNR = book.GDSPNR and tblbooktosector.orderId = book.orderId  order by tblbooktosector.pkId desc) as tosector
                                            
  ,ISNULL(book.airName,'') as airName                                             
  ,ISNULL(book.flightNo,'') as flightNo                                     
  ,(select top 1 cabin from tblBookItenary WITH (NOLOCK) where orderId = book.orderId) as travClass                                      
  ,(select top 1 airlinePNR from tblBookItenary WITH (NOLOCK) where orderId = book.orderId) as airlinePNR                                      
  ,ISNULL(pass.baggage,'') as baggage                                    
  ,(select top 1 farebasis from tblBookItenary WITH (NOLOCK) where orderId = book.orderId) as farebasis                                      
  ,ISNULL(UPPER(FORMAT(book.depDate, 'dd-MMM-yyyy')),'') as depDate                                                                                
  ,ISNULL(UPPER(FORMAT(book.arrivalDate ,'dd-MMM-yyyy')),'') as arrivalDate                                                                                
  ,pass.basicFare as basicFare                                                                                
  ,pass.totalTax as totalTax                                                                                
  ,book.totalFare as totalFare                                              
  ,book.riyaPNR                                                                                
  ,book.orderId                                                                                
  ,'' as Status                                                  
  ,CONVERT(decimal(10,2),pass.IATACommission) as  IATACommission                                                       
  ,CONVERT(decimal(10,2),pass.PLBCommission) as  PLBCommission                                                                            
  ,CONVERT(decimal(10,2),pass.DropnetCommission) as DropnetCommission                                                                            
  ,CONVERT(decimal(10,2),pass.FMCommission) as FMCommission                                                                            
  ,CONVERT(decimal(10,2),pass.Markup) as Markup                                                                            
  ,CONVERT(decimal(10,2),pass.B2BMarkup) as B2BMarkup                                                  
  ,CONVERT(decimal(10,2),book.ServiceFee) as ServiceFee                                                                            
  ,CONVERT(decimal(10,2),book.GST) as GST                                                                           
  ,pass.BFC                                                                         
  ,pass.YQ                                                                          
  ,book.AgentROE                                                    
  ,al.UserTypeID as UserType                                                                        
  ,pm.payment_mode as PaymentMode                                                    
  ,book.AgentID                                                                        
  ,book.ROE                                                                      
  ,book.TicketIssuanceError                                                  
  ,pass.ERPResponseID                                             
  ,book.IsBooked                                          
  ,book.BookingStatus               
  ,att.VesselName                                    
  ,att.Bookedby                                    
  ,att.CostCenter                                   
  ,att.Traveltype                                    
  ,att.EmpDimession                                    
  ,att.Changedcostno                                    
  ,att.Travelduration                                    
  ,att.TASreqno    
  ,att.RequestID    
  ,att.Companycodecc                                    
  ,att.Projectcode                                    
  ,att.DEVIATION_APPROVER_NAME_AND_EMPCODE                                    
  ,att.LOWEST_LOGICAL_FARE_1 as LOWEST_LOGICAL_FARE                                  
  ,att.LOWEST_LOGICAL_FARE_2              
  ,att.LOWEST_LOGICAL_FARE_3
  ,(select ([ConvenienFeeInPercent] + [TotalCommission]) From B2BMakepaymentCommission WITH (NOLOCK) where FkBookId = book.pkId) as TotalCommission          
  ,UPPER(FORMAT(CONVERT(date, book.IssueDate), 'dd-MMM-yyyy')) as IssueDate,GroupId        
    ,(select EmployeeNo from mUser WITH (NOLOCK) where id = book.MainAgentId) as EmpID      
 ,(select EmployeeNo from mUser WITH (NOLOCK) where id = pra.MainAgentId) as PushedBy  
   ,att.DEVIATIONAPPROVER
  ,att.ConcurID
  ,att.EMPLOYEESPOSITION
  ,att.TRAVELCOSTREIMBURSABLE
 --  ,(Select Riyapnr From tblBookMaster as b where b.BookingStatus = '1' and b.IsBooked = '1'             
 --and pkid in (select fkBookMaster From tblPassengerBookDetails where TicketNumber like '%'+pass.TicketNumber+'%' OR ticketNum like '%'+pass.TicketNumber+'%')            
 --and b.GDSPNR = book.GDSPNR) as alreadyexistrecord            
                    
  From tblPassengerBookDetails as pass WITH (NOLOCK)                                                     
  inner join tblBookMaster as book WITH (NOLOCK) on pass.fkBookMaster = book.pkId                                                    
  --left join tblBookItenary as ite on ite.orderId = book.orderId and ite.frmSector = book.frmSector and ite.toSector = book.toSector                                                    
  left join Paymentmaster as pm WITH (NOLOCK) on pm.order_id = book.orderId                                                    
  left join AgentLogin as al WITH (NOLOCK) on al.userid = book.AgentID                                      
  left join mAttrributesDetails as att WITH (NOLOCK) on book.GDSPNR = att.GDSPNR and book.orderId = att.OrderID and att.fkPassengerid = pass.pid    
  left join PNRRetrivalFromAudit as pra WITH (NOLOCK) on book.GDSPNR = pra.GDSPNR and pass.TicketNumber = pra.TicketNumber                                                                                     
                                                      
where book.IsBooked = '0'                                                     
  and book.BookingStatus = '13'                                                     
  and book.BookingSource IN (select Data from sample_split(@BookingSource,','))                                                    
  and book.AgentID != 'B2C'                                                    
  and CONVERT(date,book.IssueDate) between @fromDate and @todate                                                 
  and ((@OfficeIDList = '') or (book.OfficeID IN ( select Data from sample_split(@OfficeIDList,','))))                    
  and pass.totalFare > 0                                        
  order by pass.pid desc                            
END                                                  
                                                  
IF (@Status = '0' OR @Status = '2' OR @Status = '3' OR @Status = '-1') --0,2,3 --in process,failed,success,All                                                  
BEGIN                                                   
    insert into @temp                                                   
 Select                                                                                
 pass.pid                                                                                
 ,(select top 1 Icast from B2BRegistration WITH (NOLOCK) where FKUserID = book.AgentID) as Icust                                                                                
 ,book.GDSPNR                                                                                
 ,pass.ticketNum               
 ,book.OfficeID                                                                                
 ,pass.title + ' ' + pass.paxFName +' '+pass.paxLName as PaxName                  
 ,book.frmSector as sector                        
 ,(Select top 1 toSector from tblBookMaster as tblbooktosector WITH (NOLOCK) where book.riyaPNR =tblbooktosector.riyaPNR and tblbooktosector.GDSPNR = book.GDSPNR and tblbooktosector.orderId = book.orderId  order by tblbooktosector.pkId desc) as tosector  
 
    
                    
         
                                         
 ,ISNULL(book.airName,'') as airName                                                                                
 ,ISNULL(book.flightNo,'') as flightNo                                    
 ,(select top 1 cabin from tblBookItenary WITH (NOLOCK) where orderId = book.orderId) as travClass                                      
 ,(select top 1 airlinePNR from tblBookItenary WITH (NOLOCK) where orderId = book.orderId) as airlinePNR                                      
 ,ISNULL(pass.baggage,'') as baggage                                     
 ,(select top 1 farebasis from tblBookItenary WITH (NOLOCK) where orderId = book.orderId) as farebasis                                      
 ,ISNULL(UPPER(FORMAT(book.depDate, 'dd-MMM-yyyy')),'') as depDate                                                                                
 ,ISNULL(UPPER(FORMAT(book.arrivalDate ,'dd-MMM-yyyy')),'') as arrivalDate                                                           
,pass.basicFare as basicFare                                                                                
 ,pass.totalTax as totalTax             
 ,book.totalFare as totalFare                                                  
 ,book.riyaPNR                                                                                
 ,book.orderId                                                                                
 ,'' as Status                                                  
 ,CONVERT(decimal(10,2),pass.IATACommission) as  IATACommission                                                                        
 ,CONVERT(decimal(10,2),pass.PLBCommission) as  PLBCommission                                                                            
 ,CONVERT(decimal(10,2),pass.DropnetCommission) as DropnetCommission                                                                            
 ,CONVERT(decimal(10,2),pass.FMCommission) as FMCommission                                                                            
 ,CONVERT(decimal(10,2),pass.Markup) as Markup                                          
 ,CONVERT(decimal(10,2),pass.B2BMarkup) as B2BMarkup                                                                              
 ,CONVERT(decimal(10,2),book.ServiceFee) as ServiceFee                                                                            
 ,CONVERT(decimal(10,2),book.GST) as GST                                                                           
 ,pass.BFC                                                    
 ,pass.YQ                                                                          
 ,book.AgentROE                                                                        
 ,al.UserTypeID as UserType                                                            
 ,pm.payment_mode as PaymentMode                                
 ,book.AgentID                                                                     
 ,book.ROE                                                                       
 ,book.TicketIssuanceError                                                  
 ,pass.ERPResponseID                                              
 ,book.IsBooked                                          
 ,book.BookingStatus                
  ,att.VesselName      
  ,att.Bookedby                                    
  ,att.CostCenter                                    
  ,att.Traveltype                                    
  ,att.EmpDimession                                    
  ,att.Changedcostno                                    
  ,att.Travelduration                            
  ,att.TASreqno        
  ,att.RequestID      
  ,att.Companycodecc                                    
  ,att.Projectcode                                    
  ,att.DEVIATION_APPROVER_NAME_AND_EMPCODE                                    
  ,att.LOWEST_LOGICAL_FARE_1 as LOWEST_LOGICAL_FARE                           
  ,att.LOWEST_LOGICAL_FARE_2                                  
  ,att.LOWEST_LOGICAL_FARE_3  
  ,(select ([ConvenienFeeInPercent] + [TotalCommission]) From B2BMakepaymentCommission WITH (NOLOCK) where FkBookId = book.pkId) as TotalCommission          
  ,UPPER(FORMAT(CONVERT(date, book.IssueDate), 'dd-MMM-yyyy')) as IssueDate,GroupId             
    ,(select EmployeeNo from mUser WITH (NOLOCK) where id = book.MainAgentId) as EmpID      
 ,(select EmployeeNo from mUser WITH (NOLOCK) where id = pra.MainAgentId) as PushedBy      
     ,att.DEVIATIONAPPROVER
  ,att.ConcurID
  ,att.EMPLOYEESPOSITION
  ,att.TRAVELCOSTREIMBURSABLE
  From tblPassengerBookDetails as pass WITH (NOLOCK)                                                    
  inner join tblBookMaster as book WITH (NOLOCK) on pass.fkBookMaster = book.pkId                                                    
  --left join tblBookItenary as ite on ite.orderId = book.orderId and ite.frmSector = book.frmSector and ite.toSector = book.toSector                                                    
  left join Paymentmaster as pm WITH (NOLOCK) on pm.order_id = book.orderId                                                    
  left join AgentLogin as al WITH (NOLOCK) on al.userid = book.AgentID                                
  left join mAttrributesDetails as att WITH (NOLOCK) on book.GDSPNR = att.GDSPNR and book.orderId = att.OrderID and att.fkPassengerid = pass.pid                                   
  --left join PNRRetrivalFromAudit as pra WITH (NOLOCK) on book.GDSPNR = pra.GDSPNR and pass.TicketNumber = pra.TicketNumber    
    
  left join PNRRetrivalFromAudit as pra WITH (NOLOCK) on pra.GDSPNR = book.GDSPNR and pra.TicketNumber in (  
                       Select Case when (@OfficeIDList = 'DCA1S21EN')   
                       then pra.GDSPNR  
                       Else pass.TicketNumber  
                       End)  
  
  where book.IsBooked IN  ( select Data from sample_split(@IsBooked,','))                                                  
  and book.BookingStatus IN  ( select Data from sample_split(@BookingStatus,','))                                        
  and book.BookingSource IN  (select Data from sample_split(@BookingSource,','))                                                                               
  and CONVERT(date,book.IssueDate) between @fromDate and @todate                                                     
  and book.AgentID != 'B2C'                                                    
  and ((@OfficeIDList = '') or (book.OfficeID IN  ( select Data from sample_split(@OfficeIDList,','))))                    
  and pass.totalFare > 0                                        
  order by pass.pid desc                                                    
END                                                  
                                                  
select * from @temp                                          
                                                  
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetTJQData] TO [rt_read]
    AS [dbo];

