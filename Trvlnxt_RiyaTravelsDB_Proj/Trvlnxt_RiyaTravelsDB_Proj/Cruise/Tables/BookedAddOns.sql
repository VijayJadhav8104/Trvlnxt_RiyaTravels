CREATE TABLE [Cruise].[BookedAddOns] (
    [Id]           BIGINT NOT NULL,
    [fk_bookingId] BIGINT NOT NULL,
    CONSTRAINT [PK_BookedAddOns] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_BookedAddOns_Bookings] FOREIGN KEY ([fk_bookingId]) REFERENCES [Cruise].[Bookings] ([Id])
);

