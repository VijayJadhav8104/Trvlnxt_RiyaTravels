CREATE TABLE [dbo].[RoomAmenityMaster] (
    [Id]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AmenityCode]  INT            NOT NULL,
    [AmenityName]  VARCHAR (1000) NOT NULL,
    [IsActive]     BIT            CONSTRAINT [DF_RoomAmenityMaster_IsActive] DEFAULT ((1)) NOT NULL,
    [InsertedDate] DATETIME       CONSTRAINT [DF_RoomAmenityMaster_InsertedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_RoomAmenityMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

