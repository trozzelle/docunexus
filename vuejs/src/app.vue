<template>
  <div id="vue">
    <alert :alert="this.$root.alert"></alert>    
    <router-view :user="this.$root.user" name="navigation"></router-view>
    <router-view :user="this.$root.user" name="adminNavigation"></router-view>
    <router-view></router-view>
    <foot></foot>
  </div>
</template>