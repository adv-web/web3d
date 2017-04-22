/**
 * Created by maliut on 2017/4/21.
 */
module.exports = {

    entry: './src/index.js',   //我们告诉webpack，入口文件是：index.js,。webpack根据这文件来提取所有js和其他资源文件

    output: {
        //path: '/src',
        filename: 'bundle.js'   //打包输出的文件是bundle.js
    }

};