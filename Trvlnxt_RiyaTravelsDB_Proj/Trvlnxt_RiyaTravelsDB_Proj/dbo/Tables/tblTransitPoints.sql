CREATE TABLE [dbo].[tblTransitPoints] (
    [Id]                BIGINT         IDENTITY (1, 1) NOT NULL,
    [TransitPoint]      NVARCHAR (10)  NOT NULL,
    [TransitPointValue] NVARCHAR (100) NOT NULL,
    [IsActive]          BIT            NULL
);

