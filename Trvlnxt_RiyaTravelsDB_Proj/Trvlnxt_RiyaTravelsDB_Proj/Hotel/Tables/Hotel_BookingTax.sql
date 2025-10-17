CREATE TABLE [Hotel].[Hotel_BookingTax] (
    [Id]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FKBookId]    INT           NULL,
    [Amount]      FLOAT (53)    NULL,
    [Discription] VARCHAR (MAX) NULL,
    [InsertDate]  DATETIME      NULL,
    CONSTRAINT [PK_Hotel_BookingTax] PRIMARY KEY CLUSTERED ([Id] ASC)
);

