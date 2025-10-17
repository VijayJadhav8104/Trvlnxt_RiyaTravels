CREATE TABLE [dbo].[HotelRateTypes] (
    [Id]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RateTypeName] VARCHAR (100) NULL,
    CONSTRAINT [PK_HotelRateTypes] PRIMARY KEY CLUSTERED ([Id] ASC)
);

