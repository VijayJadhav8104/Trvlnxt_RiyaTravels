      
      
CREATE Procedure [Hotel].[Api_Proc_InsertBookingGSTDetails]        
@BookingPkid int,        
@GstNumber varchar(50)=null,        
@CompanyName varchar(300)=null,        
@EmailId varchar(300)=null,        
@MobileNo varchar(30)=null,        
@Address varchar(300)=null,        
@City varchar(100)=null,        
@State varchar(100)=null,        
@PinCode varchar(200)=null,      
@OrderId varchar(200)=null      
As        
Begin        
 Insert into Hotel_BookingGSTDetails(PKID,GstNumber,CompanyName,EmailId,MobileNo,Address,City,State,PinCode,OrderId)        
 values(@BookingPkid,@GstNumber,@CompanyName,@EmailId,@MobileNo,@Address,@City,@State,@PinCode,@OrderId)        
End