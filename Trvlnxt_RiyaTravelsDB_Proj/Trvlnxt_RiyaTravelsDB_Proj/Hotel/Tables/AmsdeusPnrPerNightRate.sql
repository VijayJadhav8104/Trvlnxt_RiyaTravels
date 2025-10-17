CREATE TABLE [Hotel].[AmsdeusPnrPerNightRate] (
    [pk_id]        INT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [PNR]          NCHAR (100) NULL,
    [priDate]      NCHAR (100) NULL,
    [priAmount]    NCHAR (100) NULL,
    [isActive]     BIT         NULL,
    [InsertedDate] DATETIME    NULL,
    CONSTRAINT [PK_AmsdeusPnrPerNightRate] PRIMARY KEY CLUSTERED ([pk_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-PNR]
    ON [Hotel].[AmsdeusPnrPerNightRate]([PNR] ASC)
    INCLUDE([pk_id]) WITH (FILLFACTOR = 95);

