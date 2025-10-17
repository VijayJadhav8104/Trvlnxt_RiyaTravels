CREATE TABLE [dbo].[EventCityMaster] (
    [ID]       INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CityCode] VARCHAR (25)  NULL,
    [CityName] VARCHAR (250) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    UNIQUE NONCLUSTERED ([CityName] ASC)
);

