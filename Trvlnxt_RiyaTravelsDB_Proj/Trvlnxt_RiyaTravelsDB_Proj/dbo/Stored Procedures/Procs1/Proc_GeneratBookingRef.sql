  CREATE Procedure Proc_GeneratBookingRef          
  As          
  Begin          
--Select (sequence_no+1) as sequence_no,(API_Sequence_No + 1) as 'Api_Sequence_No' from [Hotel].[Hotel_orders_sequence] Where id=1        
     
    
 Select NEXT VALUE FOR Hotel.OrderNo as sequence_no        
    
    
    
  End