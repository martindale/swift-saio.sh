#
#   Author: Marcelo Martins (btorch AT gmail.com)
#   Created: 2011/05/03
#
#   Info:
#       This a script that is imported (sourced) by the main swift-saio.sh in order 
#       to install the python dependencies that are needed before swift can be built/installed.
#       Created it as a separate file so that it can be re-used or extended wihout 
#       impacting the main script.
#
#       The script still needs to use some variables that are configured in the 
#       swift-saio.cfg configuration file. 
#

################################
#  PYTHON DEPENDENCIES INSTALL  
################################

install_python_deps (){

    SYSTYPE=$1
    EVENTLET_VER="http://pypi.python.org/packages/source/e/eventlet/eventlet-0.9.15.tar.gz"

    INSTOOL="apt-get"
    INSTOOL_OPTS="-y --force-yes -qq"
    INSTOOL_UPDATE="$INSTOOL -qq update"

    if [ ! -e $SWIFT_APT_LIST ]; then 
        echo "$SWIFT_REPO" >$SWIFT_APT_LIST
        apt-get update -qq
    fi

    # Start installation of Python-modules dependencies 
    # List of Packages : python-configobj python-setuptools python-pastedeploy python-openssl python-cheetah  
    # python-scgi python-paste python-simplejson python-webob python-formencode python-netifaces  
    # python-pkg-resources libjs-jquery python-pastescript python-xattr python-dev 
    printf "\n\t - Python packages installation (dependecies) "
    printf "\n\t\t Packages: several, please check code for package listing \n"
    printf "\n\t\t Would you like to proceed ? (y/n) "

    read choice
    if [ "$choice" = "y" ]; then
        printf "\t\t Proceeding with python package(s) installation \n"
        RESULT=`$INSTOOL install python-configobj python-setuptools python-pastedeploy python-openssl python-cheetah  \
        python-scgi python-paste python-simplejson python-webob python-formencode python-netifaces  \
        python-pkg-resources libjs-jquery python-pastescript python-xattr $INSTOOL_OPTS 2>&1 `

        if [ $? -eq 0 ]; then
            printf "\n\t\t -> Succesfully done \n"
        else
            printf "\t\t\t -> $RESULT \n"
            printf "\t\t\t -> \033[1;31;40m Error found  \033[0m\n\n"
            exit 1
        fi
    else
        printf "\t\t\033[1;31;40m Quitting installation \033[0m\n\n"
        exit 101
    fi


    # Start of CrashSite installation of certain python modules
    printf "\n\t - Python packages CrashSite installation (dependecies) "
    printf "\n\t\t Packages: python-eventlet python-greenlet python-webob  \n"

    printf "\n\t\t Proceeding with python CrashSite package(s) installation "
    if [ "$IPV6_SUPPORT" = "true" ]; then
        RESULT=`$INSTOOL install python-greenlet python-webob $INSTOOL_OPTS &> /dev/null ; echo $?`
        RESULT2=`easy_install $EVENTLET_VER  &> /dev/null ; echo $?`
    else
        RESULT=`$INSTOOL install python-eventlet python-greenlet python-webob $INSTOOL_OPTS &> /dev/null ; echo $?`
        RESULT2=0
    fi 

    if [ $RESULT -eq 0 ] && [ $RESULT2 -eq 0 ]; then
        printf "\n\t\t -> Succesfully done \n"
    else
        printf "\t\t\t -> $RESULT \n"
        printf "\t\t\t -> \033[1;31;40m Error found  \033[0m\n\n"
        exit 1
    fi

return 0 
}
