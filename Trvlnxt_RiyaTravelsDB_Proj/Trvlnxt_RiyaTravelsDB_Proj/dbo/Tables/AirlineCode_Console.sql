CREATE TABLE [dbo].[AirlineCode_Console] (
    [PKId]        INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirlineCode] VARCHAR (5)  NULL,
    [type]        VARCHAR (50) NULL,
    CONSTRAINT [PK_AirlineCode_Console] PRIMARY KEY CLUSTERED ([PKId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Airlinecode]
    ON [dbo].[AirlineCode_Console]([AirlineCode] ASC);

