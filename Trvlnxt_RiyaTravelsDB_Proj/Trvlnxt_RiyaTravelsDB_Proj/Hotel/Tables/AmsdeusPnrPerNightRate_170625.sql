CREATE TABLE [Hotel].[AmsdeusPnrPerNightRate_170625] (
    [pk_id]        INT         IDENTITY (1, 1) NOT NULL,
    [PNR]          NCHAR (100) NULL,
    [priDate]      NCHAR (100) NULL,
    [priAmount]    NCHAR (100) NULL,
    [isActive]     BIT         NULL,
    [InsertedDate] DATETIME    NULL
);

