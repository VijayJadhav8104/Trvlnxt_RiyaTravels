CREATE TABLE [Hotel].[ApiBookData] (
    [Id]              INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BookingId]       VARCHAR (100) NULL,
    [Key]             VARCHAR (100) NULL,
    [Value]           VARCHAR (100) NULL,
    [InsertDate]      DATETIME      CONSTRAINT [DF_ApiBookData_InsertDate] DEFAULT (getdate()) NULL,
    [ClientBookingID] VARCHAR (150) NULL,
    CONSTRAINT [PK_ApiBookData] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_BookingId]
    ON [Hotel].[ApiBookData]([BookingId] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_ClientBookingID]
    ON [Hotel].[ApiBookData]([ClientBookingID] ASC);

