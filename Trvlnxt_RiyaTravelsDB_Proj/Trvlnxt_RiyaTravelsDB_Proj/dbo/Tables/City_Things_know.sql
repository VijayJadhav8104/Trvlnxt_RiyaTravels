CREATE TABLE [dbo].[City_Things_know] (
    [Id]           INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Currency]     NVARCHAR (50)  NULL,
    [Timezone]     TIME (7)       NULL,
    [Temperature]  DECIMAL (18)   NULL,
    [Precipitaion] NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

