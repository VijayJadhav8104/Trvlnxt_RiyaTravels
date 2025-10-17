CREATE TABLE [dbo].[AdvertisementMaster] (
    [Id]                 INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BlogId]             NVARCHAR (MAX) NULL,
    [AdvertisementImage] NVARCHAR (MAX) NULL,
    [InsertDate]         NVARCHAR (MAX) NULL,
    [AdvertisementURL]   NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_AdvertisementMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

