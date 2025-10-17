          
--Hotel.GetRBTReportConsole 'test'          
          
CREATE Proc [Hotel].[GetRBTReportConsole]          
as          
begin          
        
   declare @qry varchar(8000)      
declare @column1name varchar(50)      
-- Create the column name with the instrucation in a variable      
SET @Column1Name = '[sep=,' + CHAR(13) + CHAR(10) + 'Booking Id]'      
        
      
   
  
  
 select @qry='set nocount on;      
 select           
 HB.BookingReference  ' + @Column1Name + '                   
,BR.AgencyName   as [Agency User]       
,BR.Icast  as [Agent ID]        
,ISNULL(mu.FullName," ")  as [User Name]        
,HB.LeaderTitle +" " + HB.LeaderFirstName +" "+ HB.LeaderLastName as [Lead Guest Name]        
,CONVERT(VARCHAR,HB.inserteddate, 0)  as [Booking Date]     
,FORMAT(HB.CheckInDate,"MMM dd yyyy")+" "+HB.CheckInTime as [CheckIn Date]      
,FORMAT(HB.CheckOutDate,"MMM dd yyyy")+" "+HB.CheckOutTime as [Checkout Date]    
,Convert(varchar,HB.CancellationDeadLine,0)  as [Cancellation Deadline]        
,HB.CurrentStatus  as [Booking Status]        
,Case                                                                                                                                               
      when  HB.B2BPaymentMode=1 then "Hold"                                                                                        
when HB.B2BPaymentMode=2 then "Credit Limit"                  
   when  HB.B2BPaymentMode=3 then "Make Payment"                                        
   when  HB.B2BPaymentMode=4 then "Self Balalnce"    
   when  HB.B2BPaymentMode=5 then "Pay@Hotel"    
   else   "NA"    
   end     
   as [Mode Of Payment]       
,HB.CurrencyCode   as  [Booking Currency]        
,HB.DisplayDiscountRate as [Booking Amount]         
,HB.SupplierReferenceNo as [Supplier Ref. No]      
,HB.SupplierName  as [Supplier]       
,REPLACE(HB.cityName, ",", "_") as [City]       
,REPLACE(HB.CountryName, ",", "_") as Country      
,REPLACE(HB.HotelName, ",", "_") as [Hotel Name]       
,TotalAdults + "|" +TotalChildren  as [No. of Passengers]       
,SelectedNights as[No. of Nights]        
,TotalRooms as [No. of Rooms]          
,SelectedNights as [Total Room Nights]          
,HotelConfNumber as [Hotel Confirmation]         
          
        
          
from Hotel_BookMaster  HB          
left join  agentLogin AL  on Hb.RiyaAgentID=al.UserID          
left join B2BRegistration  BR  on br.FKUserID=AL.UserID          
left join mCommon Mc on Mc.ID=Al.UsertypeId          
left join mUser MU on HB.MainAgentID=MU.ID                                                               
          
          
where           
MC.ID=5          
AND cast(HB.inserteddate as date) = DATEADD(day, -1, CAST(GETDATE() AS date))'       
        
      
      
      
      
-- Send the e-mail with the query results in attach      
exec msdb.dbo.sp_send_dbmail       
 @profile_name = 'dba_Automations'  ,      
--@recipients='anwar.khan@riya.travel;nabeen.khan@riya.travel;vikas.thapar@riya.travel',      
--@blind_copy_recipients='dba@riya.travel;developers@riya.travel;amol.patil@riya.travel;purav.modi@riya.travel;harshit.gor@riya.travel;ashley.paul@riya.travel;tnsupport.hotels@riya.travel',
@recipients='dba@riya.travel;tnsupport.hotels@riya.travel;developers@riya.travel',      
@query=@qry,      
@execute_query_database = 'riyatravels',      
@subject='TrvlNxt Hotel Daily RBT Booking Report',      
@attach_query_result_as_file = 1,      
@query_attachment_filename = 'RBT_Report.xls',      
@query_result_separator=',',      
@query_result_width =32767,      
@query_result_no_padding=1       
       
 --  ;gary.fernandes@riya.travel;tnsupport.hotels@riya.travel         
 end