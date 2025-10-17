CREATE TABLE [dbo].[Hotel_Suppier_List] (
    [ID]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [HotelId]     INT           NULL,
    [SuppierName] VARCHAR (100) NULL,
    CONSTRAINT [PK_Hotel_Suppier_List] PRIMARY KEY CLUSTERED ([ID] ASC)
);

