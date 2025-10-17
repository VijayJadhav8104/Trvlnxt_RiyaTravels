CREATE TABLE [dbo].[HotelFacilities] (
    [id]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FacilitieCode] INT           NOT NULL,
    [FacilitieName] VARCHAR (600) NOT NULL,
    [FaciliyieIcon] VARCHAR (800) NOT NULL,
    CONSTRAINT [PK_HotelFacilities] PRIMARY KEY CLUSTERED ([id] ASC)
);

