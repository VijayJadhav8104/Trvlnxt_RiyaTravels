CREATE TABLE [dbo].[CMS_Tour_rates] (
    [PKID_int]        BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [note_vc]         VARCHAR (250) NULL,
    [FKpackID_int]    BIGINT        NOT NULL,
    [FKcity_int]      BIGINT        NULL,
    [startdt_dt]      DATE          NOT NULL,
    [enddt_dt]        DATE          NOT NULL,
    [inserteddt_dt]   DATE          CONSTRAINT [DF_Tour_rates_inserteddt_dt] DEFAULT (getdate()) NOT NULL,
    [lastupdated_dt]  DATE          CONSTRAINT [DF_Tour_rates_lastupdated_dt] DEFAULT (getdate()) NOT NULL,
    [status_ch]       CHAR (2)      CONSTRAINT [DF_Tour_rates_status_ch] DEFAULT ('ac') NOT NULL,
    [accomodation_vc] CHAR (1)      NOT NULL,
    [travelby_ch]     CHAR (1)      CONSTRAINT [DF_Tour_rates_travelby_ch] DEFAULT ('F') NULL,
    [order_int]       INT           NULL,
    [toshow_ch]       CHAR (1)      CONSTRAINT [DF_Tour_rates_toshow_ch] DEFAULT ('N') NULL,
    CONSTRAINT [CMS_PK_Tour_rates] PRIMARY KEY CLUSTERED ([PKID_int] ASC)
);

