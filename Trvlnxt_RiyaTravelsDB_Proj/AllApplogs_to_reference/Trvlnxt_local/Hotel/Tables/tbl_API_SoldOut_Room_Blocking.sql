CREATE TABLE [Hotel].[tbl_API_SoldOut_Room_Blocking] (
    [ID]            INT             IDENTITY (1, 1) NOT NULL,
    [HotelId]       VARCHAR (300)   NULL,
    [RoomOccCombo]  VARCHAR (200)   NULL,
    [RoomName]      VARCHAR (350)   NULL,
    [CheckIN]       DATE            NULL,
    [CheckOut]      DATE            NULL,
    [SupplierName]  VARCHAR (200)   NULL,
    [Meal]          VARCHAR (300)   NULL,
    [Refundable]    BIT             NULL,
    [Price]         DECIMAL (18, 2) NULL,
    [InsertDate]    DATETIME        NULL,
    [isActive]      BIT             CONSTRAINT [DF_tbl_API_SoldOut_Room_Blocking_isActive] DEFAULT ((1)) NULL,
    [CorrelationId] VARCHAR (300)   NULL,
    CONSTRAINT [PK_tbl_API_SoldOut_Room_Blocking] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20250708-154733]
    ON [Hotel].[tbl_API_SoldOut_Room_Blocking]([HotelId] ASC, [RoomOccCombo] ASC, [CheckIN] ASC, [CheckOut] ASC, [InsertDate] ASC)
    INCLUDE([RoomName], [SupplierName], [Meal], [Refundable], [Price]) WITH (FILLFACTOR = 90);

