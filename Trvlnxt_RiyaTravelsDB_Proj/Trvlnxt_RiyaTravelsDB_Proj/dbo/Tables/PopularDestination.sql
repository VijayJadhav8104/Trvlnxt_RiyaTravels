CREATE TABLE [dbo].[PopularDestination] (
    [Id]                     INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PopularDestinations_Id] INT NULL,
    [Airline_Id]             INT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

