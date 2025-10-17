CREATE TABLE [dbo].[FlightFlat_Drec] (
    [ID]       INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FKID]     INT             NULL,
    [Min]      INT             NULL,
    [Max]      INT             NULL,
    [Discount] NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_FlightFlat_Drec] PRIMARY KEY CLUSTERED ([ID] ASC)
);

