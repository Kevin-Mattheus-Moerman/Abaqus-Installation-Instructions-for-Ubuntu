
# Abaqus 2018 installation instructions for Ubuntu 18.04

## 1. Install prerequisites

```
sudo apt install csh tcsh ksh gcc g++ gfortran libstdc++5 build-essential make libjpeg62 libmotif-dev lsb-core
```

## 2. Alter all `Linux.sh` files
Installation folders contain a bash file called `Linux.sh`. Search your installation folders and locate all of them. The locations may vary but at the time of writing they were found inside the software folders at: `~/1/inst/common/init`. These files make particular settings, two of them were causing an issue at the time of writing which is why some changes to this file are required. The full file, after changes, is given at the [bottom of this document](#linuxSH). The changes are described below.

__1) Force the distribution/release to be compatible__  
The following line in the bash file checks the particular Linux distribution used:
```sh
DSY_OS_Release=`lsb_release --short --id |sed 's/ //g'`
```
On Ubuntu this will cause it to be "Ubuntu". It appears however Ubuntu is not officially supported and the installation will not proceed because of this. The solution is to manually override the distribution. To do this open this file (e.g. `sudo gedit Linux.sh`) and comment out the above line (by placing a `#` in front of it). Once the line is commented out, add a new line which forces this parameter to denote a supported distribution, e.g. `CentOS`:
```sh
DSY_OS_Release="CentOS"
```
Note, judging from the bash file, setting other distributions may be equivalent:
```sh
"RedHatEnterpriseServer"|"RedHatEnterpriseClient"|"RedHatEnterpriseWorkstation"|"CentOS"
```
In some cases installation stalls when prerequisites are not detected (or not detected properly). After installing the `motif` package for instance the Abaqus installation may still claim it is not installed. Therefore, some users have reported that "system checks" should be disabled by also adding the line:   
```sh
export DSY_Skip_CheckPrereq=1
```
If there are many `Linux.sh` files to alter users may wish to edit them using something like:
```sh
for f in $(find //home/kevin/Downloads/AM_SIM_Abaqus_Extend.AllOS -name "Linux.sh" -type f); do
        sudo gedit $f
done
```   
## 3. Set file permissions to allow execution
Many files in the installation folder need execution permissions to be set. One quick way to do this is:
```sh
for f in $(find $(pwd) -type f); do
        chmod +x $f
done
```

## 4. Run installation GUIs
From the relevant folders run:
```
sudo ./StartGUI.sh
```

On Ubuntu 20.10 (or any after 16.04), one may experience  something like the following error:
````
../1/inst/linux_a64/code/bin/DSYInsAppliGUI: error while loading shared libraries: libpng12.so.0: cannot open shared object file: No such file or directory
````
[This link](https://www.linuxuprising.com/2018/05/fix-libpng12-0-missing-in-ubuntu-1804.html) describes that "libpng12 is no longer available in the Ubuntu repository archives". To install it manually the following can be done, after which one can retry to run the installation:
```
sudo add-apt-repository ppa:linuxuprising/libpng12
sudo apt update
sudo apt install libpng12-0
```

## 4. Make abaqus command available from any directory  
`sudo ln /var/DassaultSystemes/SIMULIA/Commands/abq2018 /usr/bin/abaqus`

---
### The `Linux.sh` file (as per 2018/08/16): <a name="linuxSH"></a>
Note this file contains two changes: 1) the release version was forced to be `"CentOS"`, and 2) checking of prerequisites was disabled.
```sh
DSY_LIBPATH_VARNAME=LD_LIBRARY_PATH

which lsb_release
if [[ $? -ne 0 ]] ; then
  echo "lsb_release is not found: check in the PDIR the list of installed packages for servers validation."
  exit 12
fi

DSY_OS_Release="CentOS" #Override release setting, old: DSY_OS_Release=`lsb_release --short --id |sed 's/ //g'`
echo "DSY_OS_Release=\""${DSY_OS_Release}"\""
export DSY_OS_Release=${DSY_OS_Release}
export DSY_Skip_CheckPrereq=1 #Added to avoid prerequisite check

if [[ -n ${DSY_Force_OS} ]]; then
  DSY_OS=${DSY_Force_OS}
  echo "DSY_Force_OS=\""${DSY_Force_OS}"\", use it for DSY_OS"
  return
fi

case ${DSY_OS_Release} in
    "RedHatEnterpriseServer"|"RedHatEnterpriseClient"|"RedHatEnterpriseWorkstation"|"CentOS")
        DSY_OS=linux_a64;;
    "SUSELINUX"|"SUSE")
        DSY_OS=linux_a64;;
    *)
        echo "Unknown linux release \""${DSY_OS_Release}"\""
        echo "exit 8"
        exit 8;;
esac
```
