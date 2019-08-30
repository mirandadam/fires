import glob

fn=glob.glob('*.zip')
for i in fn:
  print('unzip -u -d temp/ '+i)
