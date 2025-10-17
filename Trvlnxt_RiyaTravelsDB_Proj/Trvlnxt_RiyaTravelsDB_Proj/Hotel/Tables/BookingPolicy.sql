CREATE TABLE [Hotel].[BookingPolicy] (
    [Pkid]        INT            IDENTITY (1, 1) NOT NULL,
    [Type]        VARCHAR (500)  NOT NULL,
    [Text]        NVARCHAR (MAX) NOT NULL,
    [IsActive]    BIT            CONSTRAINT [DF_BookingPolicy_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedDate] DATETIME       CONSTRAINT [DF_BookingPolicy_CreatedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_BookingPolicy] PRIMARY KEY CLUSTERED ([Pkid] ASC)
);

