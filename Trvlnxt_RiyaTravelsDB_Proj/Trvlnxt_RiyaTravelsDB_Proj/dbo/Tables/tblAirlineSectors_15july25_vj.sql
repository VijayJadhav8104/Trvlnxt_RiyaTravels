CREATE TABLE [dbo].[tblAirlineSectors_15july25_vj] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [Carrier]    VARCHAR (10)  NULL,
    [fromSector] VARCHAR (10)  NULL,
    [toSector]   VARCHAR (10)  NULL,
    [IsActive]   BIT           NULL,
    [SupplierId] BIGINT        NULL,
    [Days]       VARCHAR (255) NULL
);

