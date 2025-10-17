CREATE TABLE [dbo].[Hotel_LookMaster] (
    [pkid]         BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [countryName]  VARCHAR (150) NULL,
    [cityName]     VARCHAR (150) NULL,
    [hotelName]    VARCHAR (150) NULL,
    [checkInDate]  DATETIME      NULL,
    [checkOutDate] DATETIME      NULL,
    [ratings]      VARCHAR (10)  NULL,
    [noOfRooms]    INT           NULL,
    [noOfAdult]    VARCHAR (10)  NULL,
    [noOfChild]    VARCHAR (10)  NULL,
    [childAge]     VARCHAR (20)  NULL,
    [nationality]  VARCHAR (50)  NULL,
    [residancy]    VARCHAR (50)  NULL,
    [currency]     VARCHAR (10)  NULL,
    [inserteddate] DATETIME      NULL,
    CONSTRAINT [PK_Hotel_LookMaster] PRIMARY KEY CLUSTERED ([pkid] ASC)
);

