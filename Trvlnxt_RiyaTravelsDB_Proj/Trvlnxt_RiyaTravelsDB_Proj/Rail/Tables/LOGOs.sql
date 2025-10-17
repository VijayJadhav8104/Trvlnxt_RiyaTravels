CREATE TABLE [Rail].[LOGOs] (
    [Id]                   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Supplier]             VARCHAR (100) NULL,
    [marketingInformation] VARCHAR (100) NULL,
    [marketingCarrier]     VARCHAR (100) NULL,
    [operationCarrier]     VARCHAR (100) NULL,
    [correspondingValue]   VARCHAR (100) NULL,
    CONSTRAINT [PK_LOGOs] PRIMARY KEY CLUSTERED ([Id] ASC)
);

