CREATE TABLE [Invoice].[Translations] (
    [Id]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [textToTranslate] VARCHAR (500)  NULL,
    [translatedText]  NVARCHAR (500) NULL,
    [sourceLanguage]  VARCHAR (10)   NULL,
    [targetLanguage]  VARCHAR (10)   NULL,
    CONSTRAINT [PK_Translations] PRIMARY KEY CLUSTERED ([Id] ASC)
);

