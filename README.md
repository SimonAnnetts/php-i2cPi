php-i2cPi
=========

PHP bindings for using the I2C ports on a Raspberry Pi.


WARNING: This is an in-development library, it will not be bug free and fully featured.
    Please email simon at ateb dot co dot uk if you have any problems, suggestions,
    questions or words of support.

Testing:
 * Builds with gcc (Raspbian 8.3.0-6+rpi1) 8.3.0
 * Built against PHP 7.3 (can be changed by setting the PHP version in the top of the build.sh script)

Prerequisites:
    You must have git, git-core, i2c-tools, libi2c0, swig, php-dev, php-cli and php-common installed
    as well as the usual build tools gcc etc.
    

Get/setup repo:

		git clone https://github.com/SimonAnnetts/php-i2cPi
		cd php-i2cPi

Build & install with:
    
		./build.sh
		
Check that the module loads:

		php -m
		
Look for the i2cPi module in the list and that there are no errors.
    
The build script does the following things:
    
1) Builds and Installs the i2cPi library
2) Creates an interface file for SWIG using the i2cPi header files
3) Uses SWIG to create the PHP module source code and include files
4) Builds the PHP module source and then installs the shared module library (using sudo) for php-cli and apache2 module
