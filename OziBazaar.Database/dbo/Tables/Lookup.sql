CREATE TABLE [dbo].[Lookup] (
    [LookupID]    INT           NOT NULL,
    [Description] NVARCHAR (50) NOT NULL,
    [ParentID]    INT           NULL,
    [Type]        NVARCHAR (50) NOT NULL,
    [Version]     ROWVERSION    NOT NULL,
    CONSTRAINT [PK_Lookup] PRIMARY KEY CLUSTERED ([LookupID] ASC)
);



