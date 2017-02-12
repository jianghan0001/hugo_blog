cd /e/blog/
hugo
echo ----更新public文件夹完毕----
git add .
echo ----添加----
git commit -m "修改博客"
echo ----提交----
git push
echo ----推送本地博客----
cd public/
echo ----进入public文件夹----
git add .
echo ----添加----
git commit -m "推送博客"
echo ----提交----
git push
echo ----推送部署github----
cd -
