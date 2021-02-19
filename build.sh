#!/bin/bash

php_version=7.3
swig_php_version=7
lib_install_dir=/usr/local/lib

# output file for SWIG to consume
outfile="i2cPi.i"

# build the i2c lib
mkdir lib/ 2>/dev/null

gcc -pthread -fno-strict-aliasing -DNDEBUG -g -fwrapv -O2 -Wall -Wstrict-prototypes -fPIC -c i2c/i2c_lib.c -o i2c/i2c_lib.o
gcc -pthread -shared -Wl,-O1 -Wl,-Bsymbolic-functions -Wl,-z,relro i2c/i2c_lib.o -o lib/libi2cPi.so

sudo install -m 0755 -d	${lib_install_dir}
sudo install -m 0755 lib/libi2cPi.so ${lib_install_dir}/libi2cPi.so
sudo ldconfig ${lib_install_dir}

echo "Writing an interface file for SWIG...."
echo "%module i2cPi" >${outfile}
echo "%{" >>${outfile}
echo "#include \"i2c/i2c_lib.h\"" >>${outfile}
echo "%}" >>${outfile}
echo >>${outfile}

echo "%include \"i2c/i2c_lib.h\"" >>${outfile}

echo "Using SWIG to create PHP module source...."
swig -v -php${swig_php_version} ${outfile}

php_includes=$(php-config --includes)
php_extensions=$(php-config --extension-dir)

echo "Compiling PHP module source...."
gcc ${php_includes} -fpic -c i2cPi_wrap.c
gcc -shared i2cPi_wrap.o -li2cPi -o i2cPi.so

echo "Copying i2cPi.so to PHP extensions dir..."
echo "extension=${php_extensions}/i2cPi.so" >i2cPi.ini

sudo cp -f i2cPi.so ${php_extensions}/
sudo chown root:root ${php_extensions}/i2cPi.so
sudo chmod 644 ${php_extensions}/i2cPi.so

sudo cp -f i2cPi.ini /etc/php/${php_version}/mods-available/i2cPi.ini
sudo chown root:root /etc/php/${php_version}/mods-available/i2cPi.ini

for i in cli apache2; do
	if [ -d /etc/php/${php_version}/${i} ]; then
		sudo ln -s /etc/php/${php_version}/mods-available/i2cPi.ini /etc/php/${php_version}/${i}/conf.d/20-i2cPi.ini 2>/dev/null
	fi
done

echo "There is a i2cPi.php include file that loads the module and provides a i2cPi class."
echo "DONE!"