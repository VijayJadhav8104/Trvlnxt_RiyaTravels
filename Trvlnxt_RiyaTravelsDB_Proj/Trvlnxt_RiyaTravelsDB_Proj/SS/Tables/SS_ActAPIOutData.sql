CREATE TABLE [SS].[SS_ActAPIOutData] (
    [ID]            BIGINT        IDENTITY (1, 1) NOT NULL,
    [actBookingId]  VARCHAR (50)  NOT NULL,
    [bookingRefId]  VARCHAR (50)  NOT NULL,
    [CorrelationID] VARCHAR (500) NOT NULL,
    [BookingPortal] VARCHAR (50)  NOT NULL
);

