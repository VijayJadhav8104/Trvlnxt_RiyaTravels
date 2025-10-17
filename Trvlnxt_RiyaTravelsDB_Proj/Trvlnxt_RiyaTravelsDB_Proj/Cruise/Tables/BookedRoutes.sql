CREATE TABLE [Cruise].[BookedRoutes] (
    [Id]             BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FkBookingId]    BIGINT        NULL,
    [Title]          VARCHAR (50)  NULL,
    [SubTitle]       VARCHAR (100) NULL,
    [Content]        VARCHAR (MAX) NULL,
    [Image_Url]      VARCHAR (500) NULL,
    [Arrive_Time]    DATETIME      NULL,
    [Departure_Time] DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

