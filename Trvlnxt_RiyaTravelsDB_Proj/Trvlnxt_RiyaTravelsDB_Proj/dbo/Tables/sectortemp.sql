CREATE TABLE [dbo].[sectortemp] (
    [Code]           VARCHAR (20) NOT NULL,
    [Airport Name]   VARCHAR (50) NULL,
    [City]           VARCHAR (50) NULL,
    [Continent]      VARCHAR (30) NULL,
    [Country Code]   CHAR (2)     NULL,
    [Itinerary Type] VARCHAR (20) NULL,
    CONSTRAINT [PK_sectortemp] PRIMARY KEY CLUSTERED ([Code] ASC)
);

