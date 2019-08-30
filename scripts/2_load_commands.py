import glob

fn=glob.glob('temp/*.shp')

fn.sort(key=lambda x:x.split('.shp')[0].split('_')[-1])

for i in fn:
  print('echo '+i)
  prefix=i.split('fire_')[1].split('.shp')[0]
  print('shp2pgsql -d -D -g geom -s "EPGS:4326" '+i+' inputs.firm_'+prefix+' | psql -d fires -U postgres -h 127.0.0.1')

