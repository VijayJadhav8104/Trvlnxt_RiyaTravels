CREATE TABLE [dbo].[CityMaster] (
    [CityIDP]      UNIQUEIDENTIFIER NOT NULL,
    [StateIDF]     UNIQUEIDENTIFIER NOT NULL,
    [CountryIDF]   UNIQUEIDENTIFIER NOT NULL,
    [CityName]     NVARCHAR (50)    NOT NULL,
    [CityCode]     NVARCHAR (10)    NOT NULL,
    [IsActive]     BIT              NOT NULL,
    [CreationDate] DATETIME         NOT NULL,
    [CreatedBy]    UNIQUEIDENTIFIER NOT NULL,
    [UpdationDate] DATETIME         NULL,
    [UpdatedBy]    UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK__CityMast__D51E8B431ADA4F1D] PRIMARY KEY CLUSTERED ([CityIDP] ASC)
);

