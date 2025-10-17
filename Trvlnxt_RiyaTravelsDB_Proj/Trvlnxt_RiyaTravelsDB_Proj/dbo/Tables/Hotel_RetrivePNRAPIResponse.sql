CREATE TABLE [dbo].[Hotel_RetrivePNRAPIResponse] (
    [id]                 INT           IDENTITY (1, 1) NOT NULL,
    [RetrivePNRResponse] VARCHAR (MAX) NULL,
    [InsertedDate]       DATETIME      NULL,
    [PNRNumber]          VARCHAR (50)  NULL,
    [MethodName]         VARCHAR (50)  NULL
);

