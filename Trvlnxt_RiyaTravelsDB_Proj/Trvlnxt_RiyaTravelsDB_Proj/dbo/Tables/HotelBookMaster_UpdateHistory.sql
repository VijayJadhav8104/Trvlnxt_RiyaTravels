CREATE TABLE [dbo].[HotelBookMaster_UpdateHistory] (
    [ID]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FKID]          INT           NULL,
    [RiyaPNR]       VARCHAR (50)  NULL,
    [HotelName]     VARCHAR (150) NULL,
    [CheckInDate]   DATETIME      NULL,
    [CheckOutDate]  DATETIME      NULL,
    [cityName]      VARCHAR (50)  NULL,
    [OfflineRemark] VARCHAR (MAX) NULL,
    [CurrentStatus] VARCHAR (50)  NULL,
    CONSTRAINT [PK_HotelBookMaster_UpdateHistory] PRIMARY KEY CLUSTERED ([ID] ASC)
);

