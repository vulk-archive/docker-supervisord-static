curl -O http://www.plope.com/software/meld3/meld3-0.6.5.tar.gz
curl -O https://pypi.python.org/packages/source/s/setuptools/setuptools-7.0.tar.gz
curl -O http://effbot.org/media/downloads/elementtree-1.2.6-20050316.tar.gz
curl -LO https://github.com/Supervisor/supervisor/archive/3.1.2.tar.gz
find . -name \*gz | xargs -n 1 tar xvfz
# path at these lines is a string 'supervisor' whin run within the cython binary...
# since the code is expecting a list, I'm just removing it
# assuming that cython already includes everything, with the path not mattering
# I'm sure I don't have to do this in both places
sed -i '/path.append[(]subpath[)]/d' ./setuptools-7.0/pkg_resources.py
# cython doesn't seem to support zips well
sed -i 's/zip_safe=True/zip_safe=False/' setuptools-7.0/setup.py

# The version file doesn't exist... this is one big static binary
sed -i '/^version_txt.*$/d' ./supervisor-3.1.2/supervisor/options.py
sed -i 's/^VERSION.*/VERSION="3.1.2-static"/' ./supervisor-3.1.2/supervisor/options.py
# resource seems to by dynamic only...
# so our version will be unable to set rlimits.... we should look into this
sed -i '/^import resource/d' ./supervisor-3.1.2/supervisor/options.py
sed -i '/def set_rlimits/ a\
        return ["NO LIMIT SET, NOT AVALIABLE IN STATIC BINARY"]' ./supervisor-3.1.2/supervisor/options.py
# Go ahead and install these
for d in $(find */ -maxdepth 0 -type d)
do
		cd $d
		python setup.py install
		cd ..
done
python /usr/src/python/Tools/freeze/freeze.py supervisord.py -m supervisor ; make
cp supervisord /supervisord
