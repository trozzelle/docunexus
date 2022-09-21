
# Docunexus Demo

This is a demo project built as a proof-of-concept to combine multiple public datasets to identify high-priority targets
for field, fundraising, and digital advertising applications. It currently operates over the NYS voter file and campaign
finance bulk data going back to 1999. 

## Project setup
```
cd ./php-mysql
composer update
cd ../vuejs
npm install
```

### Compiles and hot-reloads for development
```
(from vuejs directory)
npm run serve
```

### Compiles and minifies for production
```
(from vuejs directory)
npm run build
```

### Lints and fixes files
```
(from vuejs directory)
npm run lint
```

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).



# Development setup
* Go to site your development site (i.e. /home/user/www/development) and for each config.example.* file in conf/
    * copy config.example.* to config.*
    * update config.* to contain actual values
* From the root of this repo
    ```
   dev-setup.sh
    ```
* CHANGE TO A FEATURE BRANCH (i.e. never work directly on an environment branch like dev or prd)
    ```
    git checkout SOME-FEATURE-BRANCH
    ```    

# Deployment instructions
* Go to site (i.e. /var/www/production) and get latest code
    ```
    git fetch
    git pull --rebase
    ```
* For each config.example.* file in conf/
    * copy config.example.* to config.*
    * update config.* to contain actual values
* From the root of this repo
    ```
    deploy.sh
    ```
