CREATE TABLE [dbo].[SimilarAirline] (
    [Id]                INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SimilarAirline_Id] INT NULL,
    [Airline_Id]        INT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

