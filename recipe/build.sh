#! /bin/bash
./bootstrap
./configure --prefix=$PREFIX --disable-local --enable-debug --enable-shared \
  --includedir=$PREFIX/include/psrchive --with-Qt-dir=no \
  CXXFLAGS="-O2 -std=c++98" PGPLOT_DIR=$PREFIX/include/pgplot
make -j2
make install

# This foo will make conda automatically define a PSRCHIVE env variable
# when the environment is activated.
etcdir=$PREFIX/etc/conda
mkdir -p $etcdir/activate.d
echo "setenv PSRCHIVE $PREFIX" > $etcdir/activate.d/psrchive-env.csh
echo "export PSRCHIVE=$PREFIX" > $etcdir/activate.d/psrchive-env.sh
mkdir -p $etcdir/deactivate.d
echo "unsetenv PSRCHIVE" > $etcdir/deactivate.d/psrchive-env.csh
echo "unset PSRCHIVE" > $etcdir/deactivate.d/psrchive-env.sh
