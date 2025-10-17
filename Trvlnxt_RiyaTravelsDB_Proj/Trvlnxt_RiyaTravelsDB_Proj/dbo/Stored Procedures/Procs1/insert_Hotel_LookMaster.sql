CREATE procedure [dbo].[insert_Hotel_LookMaster]
@countryName varchar(150),
           @cityName varchar(150),
           @hotelName varchar(150)=null,
           @checkInDate varchar(20),
           @checkOutDate varchar(20),
           @ratings varchar(10),
           @noOfRooms int,
           @noOfAdult varchar(10)=null,
           @noOfChild varchar(10)=null,
           @childAge varchar(20)=null,
           @nationality varchar(50),
           @residancy varchar(50),
           @currency varchar(10)='INR'
         
		   as

INSERT INTO [dbo].[Hotel_LookMaster]
           ([countryName]
           ,[cityName]
           ,[hotelName]
           ,[checkInDate]
           ,[checkOutDate]
           ,[ratings]
           ,[noOfRooms]
           ,[noOfAdult]
           ,[noOfChild]
           ,[childAge]
           ,[nationality]
           ,[residancy]
           ,[currency]
           ,[inserteddate])
     VALUES
           (@countryName, 
           @cityName,
           @hotelName,
           @checkInDate,
           @checkOutDate,
           @ratings,
           @noOfRooms,
           @noOfAdult,
           @noOfChild,
           @childAge,
           @nationality,
           @residancy,
           @currency
		   ,GETDATE()
          )








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insert_Hotel_LookMaster] TO [rt_read]
    AS [dbo];

