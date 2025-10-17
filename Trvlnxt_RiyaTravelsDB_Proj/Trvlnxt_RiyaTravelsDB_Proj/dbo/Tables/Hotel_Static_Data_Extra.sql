CREATE TABLE [dbo].[Hotel_Static_Data_Extra] (
    [id]      INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MyGroup] VARCHAR (50)  NULL,
    [MyKey]   VARCHAR (200) NULL,
    [MyValue] VARCHAR (MAX) NULL,
    [HotelId] VARCHAR (50)  NULL,
    CONSTRAINT [PK_Hotel_Static_Data_Extra] PRIMARY KEY CLUSTERED ([id] ASC)
);

