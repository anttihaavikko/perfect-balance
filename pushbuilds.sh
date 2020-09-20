COLOR='\033[0;36m'
NC='\033[0m' # No Color

echo " "

echo "${COLOR}Pushing build for OSX${NC}"
butler push builds/osx anttihaavikko/perfect-balance:osx --fix-permissions

echo "${COLOR}Pushing build for Windows${NC}"
butler push builds/win anttihaavikko/perfect-balance:win --fix-permissions

echo "${COLOR}Pushing build for Linux${NC}"
butler push builds/linux anttihaavikko/perfect-balance:linux

echo "${COLOR}Pushing build for HTML5${NC}"
butler push builds/html5 anttihaavikko/perfect-balance:html5