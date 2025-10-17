CREATE TABLE [dbo].[HotelAmenityMaster] (
    [Id]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AmenityCode]  INT            NOT NULL,
    [AmenityName]  VARCHAR (1000) NOT NULL,
    [IsActive]     BIT            CONSTRAINT [DF_HotelAmenityMaster_IsActive] DEFAULT ((1)) NOT NULL,
    [InsertedDate] DATETIME       CONSTRAINT [DF_HotelAmenityMaster_InsertedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_HotelAmenityMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

