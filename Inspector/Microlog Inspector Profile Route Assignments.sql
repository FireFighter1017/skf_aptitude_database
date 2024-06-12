-- Microlog Inspector Route assignments
SELECT ProfileElemId, ProfileId, ElementId, DownloadOrder, NAME, UpdateDate
FROM skfuser.skfuser1.AnaDeviceProfileElement join treeelem on treeelemid=Elementid
where ProfileId=30  -- Get from table AnaDeviceProfil column ProfileId
Order by DownloadOrder

;
