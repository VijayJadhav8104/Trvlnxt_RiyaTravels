CREATE TABLE [dbo].[HotelB2cExceptionlog] (
    [ID]             INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Exception]      TEXT           NULL,
    [Sbrecord]       NVARCHAR (MAX) NULL,
    [InsertedDate]   DATETIME       NULL,
    [ErrorGenerated] NVARCHAR (50)  NULL,
    CONSTRAINT [PK__HotelB2c__3214EC2700FF38A7] PRIMARY KEY CLUSTERED ([ID] ASC)
);

