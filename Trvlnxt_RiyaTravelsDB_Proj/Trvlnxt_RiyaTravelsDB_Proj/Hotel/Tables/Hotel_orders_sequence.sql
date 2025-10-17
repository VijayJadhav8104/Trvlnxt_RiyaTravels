CREATE TABLE [Hotel].[Hotel_orders_sequence] (
    [Id]              INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Sequence_No]     INT NULL,
    [API_Sequence_No] INT NULL,
    CONSTRAINT [PK_Hotel_orders_sequence] PRIMARY KEY CLUSTERED ([Id] ASC)
);

