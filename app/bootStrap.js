/**
 * @file bootStrap.js
 * @desc 程序入口
 * @author shijianguo
 * @date 2016.11.28 12:59
 */

var config = require('../conf');
var koa = require('koa');
var view = require('zeus-template');
var router = require('./router');
var app = koa();
var fs = require('fs');
var runEnv = config.runEnv;
var bodyParser = require('koa-bodyparser');
var session = require('koa-generic-session');
var redisStore = require('koa-redis');
var tclog = require('./libs/tclog.js');
var genLogid = require('./libs/logid').genLogid;
var api = require('./libs/api');
var browserify = require('./libs/browserify');

var _ = require('lodash');
//本地配置文件
var local = require('../conf/local.js');
//合并本地配置文件
global.config = _.extend(config, local);

app.keys = ['tiancai', 'xiaoguang'];

var redisClient = new require('ioredis')(config.redis);

app.use(function*(next) {
    if (this.url == '/favicon.ico') {
        //favicon return
    } else {
        yield next;
    }
})

// 设置模板
view(app, config.view);

//使用browserify打包
if (runEnv === 'dev') {
    app.use(browserify());
}

// 设置api
api(app);
app.use(require('koa-static')(config.statics.staticRoute));

app.use(bodyParser());
tclog.init();

// live-reload代理中间件
if (runEnv === 'dev') {
    app.use(function*(next) {
        yield next;
        if (this.type === 'text/html') {
            this.body += yield this.toHtml('reload');
        }
    });
}

var redis = redisStore({
    client: redisClient
});

app.redisIsOk = true;

redis.on('disconnect', function() {
    app.redisIsOk = false;
})

app.use(session({
    store: redis
}));

app.use(function*(next) {
    var logid = genLogid();
    this.req.logid = logid;
    if (app.redisIsOk) {
        var tiancainame = this.cookies.get('tiancainame', {
            signed: true
        });
        try {
            var userInfo = this.session[tiancainame];
            this.userInfo = userInfo;
        } catch (e) {
            this.userInfo = null;
        }
    } else {
        this.userInfo = null;
    }

    tclog.notice({
        logid: logid,
        type: 'pv',
        method: this.req.method,
        url: this.url,
        userInfo: this.userInfo
    })
    yield next;
});

// 设置路由
router(app);

app.use(function* error(next) {
    if (this.status === 404) {
        yield this.render('error/404', {
            noWrap: true
        });
    } else {
        yield next;
    }
});

app.listen(config.app.port);
tclog.notice('UI Server已经启动：http://127.0.0.1:' + config.app.port);
// 启动后通过IO通知watch
if (runEnv === 'dev') {
    fs.writeFile('./pid', new Date().getTime());
}