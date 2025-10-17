CREATE TABLE [dbo].[mExceptionInfoHotel] (
    [ID]               BIGINT        IDENTITY (1, 1) NOT NULL,
    [PageName]         VARCHAR (100) NULL,
    [MethodName]       VARCHAR (100) NULL,
    [ExceptionMessage] VARCHAR (MAX) NULL,
    [StackTrace]       VARCHAR (MAX) NULL,
    [Details]          VARCHAR (MAX) NULL,
    [ExceptionDate]    DATETIME2 (7) CONSTRAINT [DF_mExceptionInfo_ExceptionDate] DEFAULT (getdate()) NOT NULL,
    [ParameterList]    VARCHAR (MAX) NULL,
    [HotelID]          VARCHAR (50)  NULL
);

