CREATE TABLE [dbo].[Hotel_City_SuppierMapping] (
    [ID]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CityId]      INT           NULL,
    [SuppierName] VARCHAR (100) NULL,
    [CityCode]    VARCHAR (50)  NULL,
    [CityAlias]   VARCHAR (50)  NULL,
    CONSTRAINT [PK_Hotel_City_SuppierMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);

