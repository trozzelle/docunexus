module.exports = {
    publicPath: '/',
    devServer: {
        // Brings build config in line with new app structure
        // NPM serves from port 80. Apache serves at 8080, vhost to webapp/data.
        // Otherwise getEnvironment in main.js breaks CORS
        port: 80,
        proxy: {
            '^/data': {
                target: 'http://localhost:8080',
                changeOrigin: true, // so CORS doesn't bite us.
                secure: false,
                pathRewrite: {'^/data': '/'},
                logLevel: "debug"
            }
        }
    },
    lintOnSave: false,

    transpileDependencies: [
        'vuetify'
    ],

    configureWebpack: {
        devtool: 'source-map',
        resolve: {
            alias: {
                'vue$': 'vue/dist/vue.esm.js'
            }
        },
        optimization: {
            splitChunks: {
                chunks: 'all'
            }
        }
    },

    pluginOptions: {
        'style-resources-loader': {
            preProcessor: 'scss',
            patterns: []
        }
    }
};
  
  
