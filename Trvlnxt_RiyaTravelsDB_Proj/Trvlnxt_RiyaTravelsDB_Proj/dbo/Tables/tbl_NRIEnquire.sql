CREATE TABLE [dbo].[tbl_NRIEnquire] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [NameNri]      VARCHAR (50)  NULL,
    [EmailNri]     VARCHAR (50)  NULL,
    [PhoneNri]     VARCHAR (50)  NULL,
    [ReasonNri]    VARCHAR (50)  NULL,
    [MessageNri]   VARCHAR (500) NULL,
    [InsertedDate] DATETIME      NULL,
    CONSTRAINT [PK_NRIEnquire] PRIMARY KEY CLUSTERED ([Id] ASC)
);

