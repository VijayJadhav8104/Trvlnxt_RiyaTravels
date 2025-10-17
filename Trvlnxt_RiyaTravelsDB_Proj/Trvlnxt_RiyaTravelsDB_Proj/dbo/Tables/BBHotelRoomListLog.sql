CREATE TABLE [dbo].[BBHotelRoomListLog] (
    [Id]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FkBookId]     INT            NULL,
    [CityId]       NVARCHAR (200) NULL,
    [CityName]     VARCHAR (200)  NULL,
    [CheckInDate]  DATETIME       NULL,
    [CheckOutDate] DATETIME       NULL,
    [Price]        VARCHAR (200)  NULL,
    [RoomType]     VARCHAR (200)  NULL,
    [CreateDate]   DATETIME       CONSTRAINT [DF_BBHotelRoomListLog_CreateDate] DEFAULT (getdate()) NULL,
    [Meal]         VARCHAR (200)  NULL,
    [SupplierName] VARCHAR (200)  NULL,
    [LocalHotelId] NVARCHAR (500) NULL,
    CONSTRAINT [PK_BBHotelRoomListLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [CommanIndex]
    ON [dbo].[BBHotelRoomListLog]([FkBookId] ASC)
    INCLUDE([Price], [SupplierName]);

