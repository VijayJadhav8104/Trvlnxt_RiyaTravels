CREATE TABLE [dbo].[mastCountry] (
    [ID]             INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Code]           VARCHAR (50)  NULL,
    [City]           VARCHAR (100) NULL,
    [Country]        VARCHAR (100) NULL,
    [Continent]      VARCHAR (100) NULL,
    [TC Area]        INT           NULL,
    [Itinerary Type] VARCHAR (100) NULL,
    CONSTRAINT [PK_mastCountry] PRIMARY KEY CLUSTERED ([ID] ASC)
);

