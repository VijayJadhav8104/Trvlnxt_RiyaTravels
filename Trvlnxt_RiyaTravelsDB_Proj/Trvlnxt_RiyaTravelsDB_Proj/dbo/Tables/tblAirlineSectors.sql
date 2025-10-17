CREATE TABLE [dbo].[tblAirlineSectors] (
    [Id]         INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Carrier]    VARCHAR (10)  NULL,
    [fromSector] VARCHAR (10)  NULL,
    [toSector]   VARCHAR (10)  NULL,
    [IsActive]   BIT           CONSTRAINT [DF_tblAirlineSectors_IsActive] DEFAULT ((1)) NULL,
    [SupplierId] BIGINT        NULL,
    [Days]       VARCHAR (255) NULL,
    CONSTRAINT [PK_tblAirlineSectors] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NONCLUSTERED_composite_INDEX]
    ON [dbo].[tblAirlineSectors]([fromSector] ASC, [toSector] ASC, [IsActive] ASC)
    INCLUDE([Carrier]);

