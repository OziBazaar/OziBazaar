CREATE TABLE [dbo].[Property] (
    [PropertyID]  INT            IDENTITY (1, 1) NOT NULL,
    [KeyName]     NVARCHAR (250) NOT NULL,
    [ControlType] NVARCHAR (50)  NULL,
    [DataType]    NVARCHAR (100) NULL,
    [LookupType]  NVARCHAR (150) NULL,
    [DependsOn]   NVARCHAR (150) NULL,
    [Version]     ROWVERSION     NOT NULL,
    CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED ([PropertyID] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_Property]
    ON [dbo].[Property]([PropertyID] ASC);

GO
ALTER TABLE [dbo].[Property] 
	ADD CONSTRAINT CK_DataType CHECK( [DataType] in('String','bool','Lookup','Image'))
GO
ALTER TABLE [dbo].[Property] 
	ADD CONSTRAINT CK_ValidLookupType CHECK(lookupType IS NULL OR dbo.IsValidLookupType(lookupType)=1	 )
GO
ALTER TABLE [dbo].[Property] 
	ADD CONSTRAINT CK_ControlType CHECK( [ControlType] in('TextBox','TextArea','DropDown','CheckBox','RadioButton','Image'))