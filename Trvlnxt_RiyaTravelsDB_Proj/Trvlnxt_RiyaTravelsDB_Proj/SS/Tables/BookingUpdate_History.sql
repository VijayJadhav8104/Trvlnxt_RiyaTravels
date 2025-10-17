CREATE TABLE [SS].[BookingUpdate_History] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [FkBookid]     INT           NULL,
    [FieldName]    VARCHAR (100) NULL,
    [FieldValue]   VARCHAR (500) NULL,
    [InsertedDate] DATETIME      NULL,
    [InsertedBy]   INT           NULL,
    [UpdatedType]  VARCHAR (50)  NULL
);

