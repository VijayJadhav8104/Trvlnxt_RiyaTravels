CREATE TABLE [Hotel].[HotelPrefrence_ErrorLog] (
    [Pkid]              INT           IDENTITY (1, 1) NOT NULL,
    [Exception]         VARCHAR (MAX) NULL,
    [createdDate]       DATETIME      NULL,
    [MethodName]        VARCHAR (500) NULL,
    [channel]           VARCHAR (200) NULL,
    [ApiName]           VARCHAR (500) NULL,
    [HotelId]           VARCHAR (200) NULL,
    [LoginUserId]       INT           NULL,
    [DyanmoDbException] VARCHAR (MAX) NULL,
    CONSTRAINT [PK_HotelPrefrence_ErrorLog] PRIMARY KEY CLUSTERED ([Pkid] ASC)
);

