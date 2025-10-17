--exec GetHotelBookReport '10/05/2023','10/05/2023' //commsion report                                   
                                    
CREATE proc [dbo].[GetHotelBookReport]                                    
 @fromdate varchar(20),                                    
 @todate varchar(20)                                    
as                                     
                                            
Begin                          
                    
                    
                    
  Select                           
    B.pkid                         
  ,mcn.Value as 'UserType'                            --add on 14-04-23                        
  ,case when b.MainAgentID!=0 then  'Internal'  --add column on 14-04-23                               
   when b.MainAgentID=0 then  'Agent'                            
 -- else '0'                        
   end as 'CustomerType'                        
 ,BR.AgencyName + ISNULL(+'-'+mu.FullName,'') + ISNULL(+'-'+AL1.FirstName,'') as 'AgentName' --add on 31-03-23 as well as joines                        
  -- ,concat(a.FirstName, ' ', a.LastName) as AgentName  --comment on 31-03-23                          
   , CONCAT(b.LeaderTitle, ' ', B.LeaderFirstName, ' ', B.LeaderLastName) AS PassangerName                          
   , b.TotalRooms 'TotalRoom'                          
   ,B.SelectedNights                          
   ,(select sum(cast(TotalAdults as int) + cast(TotalChildren as int)) from Hotel_BookMaster bm  where bm.pkId=b.pkId group by bm.pkId) as TotalPassanger                          
   , b.CurrentStatus as 'status'                          
   , b.SupplierName                          
   , b.BookingReference as BookingId                          
   , b.SupplierReferenceNo as 'Supplier Conf. No'                          
   , b.HotelName as Destination                          
   --, b.inserteddate as BookingDate     
   ,FORMAT(CAST(b.inserteddate AS datetime),'dd MMM yyyy hh:mm tt') as BookingDate        
    
  -- , cast (b.CheckInDate as Date) as ServiceDate        
     ,FORMAT(CAST(b.CheckInDate AS datetime),'dd MMM yyyy hh:mm tt') as ServiceDate        
    
 --  ,cast (b.CheckOutDate as Date) as CheckOutDate        
    ,FORMAT(CAST(b.CheckOutDate AS datetime),'dd MMM yyyy hh:mm tt') as CheckOutDate        
          
   , b.SupplierCurrencyCode as Supplier_Currencry                               
   , Case                          
   when BookingReference like '%RT%' then b.SupplierRate                         
   when BookingReference like '%TNH%' then (select sum(HRM.baseRate) from Hotel_Room_master HRM where HRM.book_fk_id=b.pkId)                         
                           
   end as 'Supplier_Basic'                        
                        
   , isnull(b.HotelTaxes,0) AS 'SupplierTax'   --change from '0' to HBT.Amount on  23-03-23                        
   --,  bc.SupplierCommission as 'SupplierDiscount'                             
   --, (b.SupplierRate - Bc.SupplierCommission) AS 'SupplierTotal'    // changes done on 18 oct by gary suggested             
   ,b.SupplierRate as 'Supplier Gross (Base currency)'              
   ,  b.ROEValue as 'ROE' --change 06-03-2023                     
               
   , Case                --add vase for RT on 28-03-2023                        
   when BookingReference like '%RT%' then b.AgentRate                         
   --when BookingReference like '%TNH%' then (B.SupplierRate - Bc.SupplierCommission)*b.ROEValue              
   when b.BookingPortal='TNH' or b.BookingPortal='TNHAPI' then (B.SupplierRate)*b.ROEValue              
                           
   end as 'Supplier Gross (INR)'                        
                  
  ,isnull(B.FinalROE,1) as 'ROE (INR)'                   
                  
        -- changes done for TNHAPI  suggested by gary on 12 oct 2023                      
                  
                    
  ,case when B.BookingPortal='TNH' then ((bc.SupplierCommission)*(b.FinalROE)) when B.BookingPortal='TNHAPI' then ((BC.RiyaCommission) *( b.FinalROE)) end as 'Agent Commission (INR)'                      
                  
   --,  (B.SupplierRate - Bc.SupplierCommission)*b.ROEValue as 'Supplier Gross (INR)'  -- change from cast(expected_prize as decimal(16,2)) to b.DisplayDiscountRate                        
    -- changes done for TNHAPI  suggested by gary on 5 oct 2023                  
                 
 ,B.CurrencyCode as 'Agent Currency'                  
 , case when B.BookingPortal='TNH' then bc.SupplierCommission when B.BookingPortal='TNHAPI' then   BC.RiyaCommission end as 'Supplier Commission (Agent Currency)'                      
                         
                 
  -- changes done for TNHAPI  suggested by gary on 5 oct 2023                      
 --, case when B.BookingPortal='TNH' then bc.SupplierCommission when B.BookingPortal='TNHAPI' then   BC.RiyaCommission end as 'Supplier Commission (Agent Currency)'                      
   --,bc.SupplierCommission as 'Supplier Commission (INR)'                        
                           
    , isnull(bc.GSTAmount,0) as 'GST Value'  --add GstAmount 09-03-2022(change column from Transaction fee to GST Value on 23-3-23 )                       
                       
   ,concat(b.TotalServiceCharges, ' ','(', b.GstAmountOnServiceChagres ,')') as 'Service Charges'                        
 --Changes on oct 5 2023 as per gary                      
   -- (bc.SupplierCommission-isnull(bc.GSTAmount,0))  as total supplier net (INR)                    
   --,case when B.BookingPortal='TNH'then((BC.SupplierCommission)-(BC.GSTAmount)-(B.TotalServiceCharges))  
   --when B.BookingPortal='TNHAPI'  then ((BC.RiyaCommission)-(BC.GSTAmount)-(B.TotalServiceCharges))  end  as 'Supplier Net Commission (INR)'
   --above commnented as per gary to remove total service charges minus from above dated:03/06/2025
      ,case when B.BookingPortal='TNH'then((BC.SupplierCommission)-(BC.GSTAmount))  
   when B.BookingPortal='TNHAPI'  then ((BC.RiyaCommission)-(BC.GSTAmount))  end  as 'Supplier Net Commission (INR)'
   
              
   --case when bc.Commission!='0.00' then(100.00- bc.Commission) else 0 end as 'Riya Share %'   (as discussed with faizan sir commented on 09-03-23)                        
   ,(100.00-bc.Commission) as 'Riya Share %'  --add Riya Share % 09-03-2022                        
   --(bc.Commission+bc.TDSDeductedAmount) as 'Agent Share %'     (as discussed with faizan sir commented on 09-03-23)                        
   ,bc.Commission as 'Agent Share %'     --add Agent Share % 09-03-2022                        
    -- ,bc.EarningAmount as 'Agent Part Share'   -- commemneteds and used onwards 5 oct 2023 as per gary suggested                       
  ,(BC.EarningAmount + bc.TDSDeductedAmount) as 'Agent Part Share'                      
  --,isnull(b.AgentCommission,0) as 'Agent Part Share'  --add Agent Part Share 10-03-2022                        
   --(BC.RiyaCommission+B.MarkupAmount) as 'Riya Share'     (as discussed with faizan sir commented on 09-03-23)                        
  ,(bc.SupplierCommission-isnull(bc.GSTAmount,0))*(100.00-bc.Commission)/100 as 'Riya Share'    --add Riya Share 10-03-2022                        
   ,bc.TDSDeductedAmount as 'TDS Amount' --change ( BC.SupplierCommission - BC.RiyaCommission) & column from Less GST on Commission to TDS Amount on 23-3-23.                        
                         
   -- changes done on  5 oct 23                      
   --,(BC.EarningAmount + bc.TDSDeductedAmount) as 'Gross Agent Earning'                        
   ,  bc.EarningAmount  as 'Agent Commission less TDS'                      
   , b.ROEValue 'ROE to Booking Date'                          
   ,isnull(b.AgentCommission,0) as 'Agent Commission (Local currency)' -- (as discussed with faizan sir change on 16-03-23)                        
   ,(BC.RiyaCommission+B.MarkupAmount) as 'Riya Net Revenue (Local Currency)'                          
   , (bc.SupplierCommission-isnull(bc.GSTAmount,0))*(100.00-bc.Commission)/100 as 'Riya Net Revenue (INR)'                      
                       
                    
   from Hotel_BookMaster b WITH (NOLOCK)                             
   left join Hotel_ROE_Booking_History Roe WITH (NOLOCK)  on Roe.FkBookId=b.pkId       
   left join B2BHotelSupplierMaster SM  WITH (NOLOCK) on  SM.Id=B.SupplierPkId      
   left join AgentLogin a WITH (NOLOCK)  on b.RiyaAgentID = a.UserID                            
   left join b2bhotel_commission bc WITH (NOLOCK)  on B.pkId=bc.Fk_BookId                        
   LEFT JOIN agentLogin AL1 WITH (NOLOCK)  ON  b.SubAgentId= AL1.UserID                            
   left join B2BRegistration BR  WITH (NOLOCK) on b.RiyaAgentID=BR.FKUserID                        
   left join mUser MU WITH (NOLOCK)  on b.MainAgentID=MU.ID                         
   left join mCommon  mcn WITH (NOLOCK)  on mcn.ID=a.userTypeID     
                          
where                                 
                        
cast(b.inserteddate as date) between @fromdate and  @todate                
    --and   bc.SupplierCommission>0     
    -- as discsussed based on supplier is Commission as set in supplier page or not modify booking  
 --and SM.Commission_Net in (1,3)      
 and SM.Commission_Net in (1)      
 and  b.BookingReference is not null                                  
    
    order by b.pkid desc                                        
                                     
                               
     end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetHotelBookReport] TO [rt_read]
    AS [dbo];

