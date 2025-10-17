CREATE TABLE [dbo].[tblSTSAvaibilityAirline] (
    [Id]            INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Carrier]       VARCHAR (20) NULL,
    [BussinessType] VARCHAR (20) NULL,
    [IsActive]      BIT          NULL,
    CONSTRAINT [PK_tblSTSAvaibilityAirline] PRIMARY KEY CLUSTERED ([Id] ASC)
);

