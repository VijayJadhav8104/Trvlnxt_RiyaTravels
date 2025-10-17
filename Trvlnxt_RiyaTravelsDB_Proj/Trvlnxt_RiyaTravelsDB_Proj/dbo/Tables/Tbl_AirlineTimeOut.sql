CREATE TABLE [dbo].[Tbl_AirlineTimeOut] (
    [Id]         BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VendorName] VARCHAR (50) NULL,
    [VenderTime] INT          NULL,
    CONSTRAINT [PK_Tbl_AirlineTimeOut] PRIMARY KEY CLUSTERED ([Id] ASC)
);

