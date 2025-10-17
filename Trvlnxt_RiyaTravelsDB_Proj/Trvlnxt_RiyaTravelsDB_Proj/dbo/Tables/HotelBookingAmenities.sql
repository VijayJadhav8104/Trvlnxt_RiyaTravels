CREATE TABLE [dbo].[HotelBookingAmenities] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [BookingFkid]   INT           NULL,
    [Facilitiesid]  VARCHAR (100) NULL,
    [FacilitieCode] VARCHAR (100) NULL,
    [FacilitieName] VARCHAR (100) NULL,
    [FaciliyieIcon] VARCHAR (100) NULL,
    CONSTRAINT [PK_HotelBookingAmenities] PRIMARY KEY CLUSTERED ([Id] ASC)
);

