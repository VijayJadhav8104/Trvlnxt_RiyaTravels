CREATE TABLE [dbo].[sectors] (
    [Code]           VARCHAR (20)  NOT NULL,
    [Airport Name]   VARCHAR (200) NULL,
    [City]           VARCHAR (50)  NULL,
    [Continent]      VARCHAR (30)  NULL,
    [Country Code]   CHAR (2)      NULL,
    [Itinerary Type] VARCHAR (20)  NULL,
    CONSTRAINT [PK_sectors] PRIMARY KEY CLUSTERED ([Code] ASC)
);

