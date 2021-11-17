<template>
  <p id="commitsha">__commit_sha__</p>

  <Queue />
</template>

<script>
import Queue from './components/Queue.vue'

export default {
  name: 'App',
  components: {
    Queue
  }
}
</script>

<style>
body {
  background-color: #225522;
  color: #9e9a93;
}
a {
  color: #bebaf3;
}
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  /* color: #2c3e50; */
  margin-top: 60px;
}
#commitsha {
  display: none;
}
.queue-item {
  list-style: none;
}
</style>
