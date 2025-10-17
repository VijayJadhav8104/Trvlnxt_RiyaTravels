CREATE TABLE [Hotel].[HotelBookingValidation] (
    [Id]              INT           IDENTITY (1, 1) NOT NULL,
    [ErrorMessage]    VARCHAR (MAX) NULL,
    [ClientBookingId] VARCHAR (200) NULL,
    [CorrelationId]   VARCHAR (150) NULL,
    [CreatedOn]       DATETIME      DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

