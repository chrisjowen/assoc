import "phoenix_html"
import Home from "./views/Home.vue"
import Vue from "vue"
import VueRouter from "vue-router"
import VueMaterial from 'vue-material'
Vue.use(VueMaterial)
Vue.use(VueRouter)

Vue.config.productionTip = false


const router = new VueRouter({
    routes: [{
            path: '/',
            component: Home
        },
        {
            path: '*',
            redirect: '/'
        }
    ]
});


new Vue({
    router,
    template: `<div>
            <router-view></router-view>
        </div>`
}).$mount('#app');