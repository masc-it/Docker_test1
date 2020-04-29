mkdir -p studio-data/profile/AndroidStudio3.6 || exit
mkdir -p studio-data/Android || exit
mkdir -p studio-data/profile/.android || exit
mkdir -p studio-data/profile/.java || exit
mkdir -p studio-data/profile/.gradle || exit
mkdir -p studio-data/profile/.eclipse || exit
docker build -t onipot/android-studio:latest . || exit
