CREATE TABLE [dbo].[AirlinePassengerNameFormat] (
    [Id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirlineCode] VARCHAR (10)  NOT NULL,
    [AirlineName] VARCHAR (50)  NOT NULL,
    [FirstName]   VARCHAR (50)  NOT NULL,
    [LastName]    VARCHAR (50)  NOT NULL,
    [Remarks]     VARCHAR (500) NULL,
    CONSTRAINT [PK_AirlinePassengerNameFormat] PRIMARY KEY CLUSTERED ([Id] ASC)
);

