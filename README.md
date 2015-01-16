# mbr voxel Deployment Scripts

- http://api.voxel.net/docs/
- https://github.com/internaplabs/hAPI-perl

## Re-Image a Machine

```
hapi -m voxel.voxservers.reimage customer_id=? device_id=? hostname=? image_id=139 kickstart=https://raw.githubusercontent.com/mbrtargeting/voxel/master/preseed.default.cfg
hapi -m voxel.voxservers.status customer_id=? device_id=? hostname=? verbosity=extended
```
