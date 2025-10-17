CREATE TABLE [dbo].[FlightFlatDrec_Delete] (
    [ID]       INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FlatID]   INT             NULL,
    [FKID]     INT             NULL,
    [Min]      INT             NULL,
    [Max]      INT             NULL,
    [Discount] NUMERIC (18, 2) NULL,
    CONSTRAINT [PK_FlightFlatDrec_Delete] PRIMARY KEY CLUSTERED ([ID] ASC)
);

