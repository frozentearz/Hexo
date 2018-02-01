hexo generate
cp -R public/* ./../frozentearz.github.io
cd ./../frozentearz.github.io
git add .
git commit -m “update”
git push origin master
