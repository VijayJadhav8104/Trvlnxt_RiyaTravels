      
--Created Date :  10 May 2024 ----      
--- Created By : Aman Wagde ---      
      
CREATE Procedure  Hotel.InsertHotelDetailsPreference      
@Channel varchar(100)='',  
@HotelId varchar(400)='',      
@Hname Nvarchar(max)='',      
--@Status varchar(10)='',      
@line1 NVARCHAR(MAX)='' ,      
@line2 NVARCHAR(MAX) ='',      
@Pincode NVARCHAR(100)='',      
@City NVARCHAR(800)='',      
@Country varchar(400)='',      
@ContactNo varchar(200)='',      
@ChainName varchar(500)='',      
@PrefredSupplier Nvarchar(Max)='',      
@BlockedSupplier Nvarchar(MAx)='',      
@LoginUser int=0      
as      
Begin      
      
-- IF NOT EXISTS (select HotelId from hotel.HotelPrefrence where HotelId=@HotelId and Channel=@Channel and IsActive=1)      
--Begin      
--Insert into hotel.HotelPrefrence       
--(HotelId,Hotelname,HotelAddress,HotelCity,Country,Pincode,ContactNo,ChainName,PreferedSupplierName,BlockedSupplier,CreatedDate,CredatedBy,Channel,IsActive)       
--values      
--(@HotelId,@Hname,(@line1+' '+@line2),@City,@Country,@Pincode,@ContactNo,@ChainName,@PrefredSupplier,@BlockedSupplier,GETDATE(),@LoginUser,@Channel,1)      
--  SELECT SCOPE_IDENTITY();       
--  End      
--IF EXISTS(select HotelId from hotel.HotelPrefrence where HotelId=@HotelId and Channel=@Channel and IsActive=1)      
--begin  

       
      
--  Insert into hotel.HotelPrefrence       
--(HotelId,Hotelname,HotelAddress,HotelCity,Country,Pincode,ContactNo,ChainName,PreferedSupplierName,BlockedSupplier,CreatedDate,CredatedBy,Channel,IsActive)       
--values      
--(@HotelId,@Hname,(@line1+' '+@line2),@City,@Country,@Pincode,@ContactNo,@ChainName,@PrefredSupplier,@BlockedSupplier,GETDATE(),@LoginUser,@Channel,1)      
      
--     begin
--	 Update hotel.HotelPrefrence set IsActive=0 where HotelId=@HotelId and Channel=@Channel 
--	 end 
--       SELECT SCOPE_IDENTITY();  
--End      
       
       
    -- Disable IsActive for any existing records
    UPDATE hotel.HotelPrefrence
    SET IsActive = 0
    WHERE HotelId = @HotelId
    AND Channel = @Channel
    AND IsActive = 1;
  
    -- Insert the new record
    INSERT INTO hotel.HotelPrefrence       
    (
      HotelId, Hotelname, HotelAddress, HotelCity, Country, Pincode, 
      ContactNo, ChainName, PreferedSupplierName, BlockedSupplier, 
      CreatedDate, CredatedBy, Channel, IsActive
    )       
    VALUES      
    (
      @HotelId, @Hname, (@line1 + ' ' + @line2), @City, @Country, @Pincode, 
      @ContactNo, @ChainName, @PrefredSupplier, @BlockedSupplier, 
      GETDATE(), @LoginUser, @Channel, 1
    );      

    -- Return the new identity value
    SELECT SCOPE_IDENTITY();       
END;
	

 