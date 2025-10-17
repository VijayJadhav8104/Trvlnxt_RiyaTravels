CREATE Procedure [dbo].[GetSupplierDetails]                  
As                
Begin               
            
If Not Exists( Select top 1 SupplierName from SedularWorkingUpdate where convert(date,InsertedDate) = convert(date,GETDATE()) and SchedulerName='GetSupplierVirtualBalance' order by id desc)            
Begin             
Select       
BHSM.SupplierName,      
 sum(BHSM.VirtualBalance) as VirtualBalance,       
 isnull(sum(convert(float, HB.expected_prize)),0) as TransactionAmount,      
 isnull((sum(BHSM.VirtualBalance)-sum(convert(float, HB.expected_prize))),0) as RemainingBalance,   
 isnull((sum(BHSM.VirtualBalance)+sum(convert(float, HB.expected_prize))),0) as OpningBalance      
 from B2BHotelSupplierMaster  BHSM      
 Left join       
 Hotel_BookMaster HB       
 on       
 BHSM.RhSupplierId=HB.SupplierUsername      
 and convert(date,HB.inserteddate)=convert(date,DATEADD(day,-1,Getdate()))   
  WHERE  BHSM.IsActive=1  
 group by  BHSM.SupplierName         
 END            
End 