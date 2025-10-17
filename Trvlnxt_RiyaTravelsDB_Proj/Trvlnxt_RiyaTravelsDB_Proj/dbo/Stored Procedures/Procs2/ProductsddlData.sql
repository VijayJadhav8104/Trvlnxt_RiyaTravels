CREATE PROCEDURE [dbo].[ProductsddlData]                                    
 -- Add the parameters for the stored procedure here                                    
                                     
AS                                    
BEGIN                                    
                                  
 SET NOCOUNT ON;                                                     
                                     
                                    
 --- for Branch                                    
 select ProductName as  pkid,ProductName  from mProducts                               
 where  ProductName IN ('Flights', 'Hotels', 'Rail', 'Cruise', 'Activities','SightSeeing' )                             
                   
             
     ----- magent attribute            
            
select   pkid,ProductName  from mProducts                                   
 where  pkid IN (1, 2)           
        
 -- Hotel Preference --        
 select   'TrvlNxt'  as 'Channel'         
            union All         
    select      'rc-live-channel'  as 'Channel'        
     union All           
 select   'rbt-live-channel'  as 'Channel'        
         
--select 'Preference' as 'SelectedPreference'  
--union all  -- for time being its was commneted   
select 'Active' as 'SelectedPreferenceText','Active'as 'SelectedPreferenceValue'  
union
select 'Preference' as 'SelectedPreferenceText','Preference'as 'SelectedPreferenceValue'  

                                  
END         
        
        
        