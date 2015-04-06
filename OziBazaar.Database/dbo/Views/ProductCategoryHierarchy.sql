CREATE VIEW [dbo].[ProductCategoryHierarchy]
AS
SELECT distinct  c1.Id,
				 c1.Name,
				 c1.HierarchyId.GetLevel() AS LevelId,
				 c1.ParentId,
				 CASE ISNULL(c2.ID,0) WHEN  0 then 0 ELSE 1 END HasChild,
				 c1.EditorId
FROM [dbo].[Category] c1
LEFT join [dbo].[Category] c2 on c1.ID=c2.ParentId
WHERE c1.ID<>0


