#! /bin/bash
./bootstrap

# Change to right C++ standard for psrchive:
export CXXFLAGS=$(echo "$CXXFLAGS" | perl -pe 's/-std=\S+\s/-std=c++98 /')

# Attempt to speed up compilation on Travis MacOS:
if [[ "$TRAVIS_OS_NAME" = "osx" ]]; then
    export CXXFLAGS=$(echo "$CXXFLAGS" | sed 's/-O2//')
fi

echo "CXXFLAGS $CXXFLAGS"

./configure --prefix=$PREFIX --disable-local --enable-shared \
  --includedir=$PREFIX/include/psrchive --with-Qt-dir=no \
  PGPLOT_DIR=$PREFIX/include/pgplot
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
