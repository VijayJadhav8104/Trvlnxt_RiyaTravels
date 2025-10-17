CREATE TABLE [dbo].[APIUserIDPassword] (
    [ID]                 INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserID]             NVARCHAR (50)  NULL,
    [Password]           NVARCHAR (100) NULL,
    [SupplierName]       NVARCHAR (50)  NULL,
    [Isi2space]          INT            NULL,
    [B2BHotelSupplierId] INT            NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

